from PIL import Image
import numpy as np
import os

SHARED_DIR = '/shared'

def extract_chunks(img_path, num_chunks):
    img = Image.open(img_path).convert('L')
    arr = np.array(img)
    # Split the array horizontally into distinct chunks
    chunks = np.array_split(arr, num_chunks)
    
    chunk_data = []
    for i, chk in enumerate(chunks):
        chunk_path = os.path.join(SHARED_DIR, f"temp_{os.path.basename(img_path)}_{i}.npy")
        np.save(chunk_path, chk)
        chunk_data.append({
            "chunk_id": i,
            "path": chunk_path,
            "shape": chk.shape
        })
    return chunk_data

def process_histogram_task(payload):
    arr = np.load(payload["path"])
    hist, _ = np.histogram(arr.flatten(), 256, [0,256])
    return {**payload, "histogram": hist.tolist()}

def compute_global_cdf(histograms):
    global_hist = np.sum(histograms, axis=0)
    cdf = global_hist.cumsum()
    
    # Mask to ignore 0-values efficiently
    cdf_masked = np.ma.masked_equal(cdf, 0)
    cdf_masked = (cdf_masked - cdf_masked.min()) * 255 / (cdf_masked.max() - cdf_masked.min())
    cdf_final = np.ma.filled(cdf_masked, 0).astype('uint8')
    
    return cdf_final.tolist()

def apply_cdf_task(payload):
    arr = np.load(payload["path"])
    cdf = np.array(payload["cdf"])
    equalized = cdf[arr]
    
    out_path = payload["path"].replace("temp_", "out_")
    np.save(out_path, equalized)
    return {**payload, "out_path": out_path}

def stitch_image(chunk_paths, out_path):
    arrays = [np.load(p) for p in chunk_paths]
    final_arr = np.vstack(arrays)
    img = Image.fromarray(final_arr.astype('uint8'))
    img.save(out_path)
    
    for p in chunk_paths:
        try:
            os.remove(p)
            temp_path = p.replace("out_", "temp_")
            os.remove(temp_path)
        except OSError:
            pass
