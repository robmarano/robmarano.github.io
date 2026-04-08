import os
import numpy as np
import pytest
from PIL import Image
from core.image_processing import extract_chunks, stitch_image
import core.image_processing as ip

def test_extract_chunks_split_boundaries(tmp_path):
    # Dynamically inject the pytest tmp_path into the module's target dir
    ip.SHARED_DIR = str(tmp_path)
    
    # Generate an awkward dimensioned image to assert numpy split integrity
    mock_img_path = str(tmp_path / "awkward_mock.jpg")
    img = Image.new('L', (100, 100), color=128)
    img.save(mock_img_path)
    
    results = extract_chunks(mock_img_path, 3)
    
    assert len(results) == 3
    assert results[0]['shape'] == (34, 100) # Numpy splits remainder heavily on first chunks
    assert results[1]['shape'] == (33, 100)
    assert results[2]['shape'] == (33, 100)
    
    for r in results:
        assert os.path.exists(r['path'])
        
def test_stitch_image_cleanup(tmp_path):
    ip.SHARED_DIR = str(tmp_path)
    
    # Mock some chunks
    p1 = str(tmp_path / "out_1.npy")
    p2 = str(tmp_path / "out_2.npy")
    np.save(p1, np.ones((50, 100), dtype=np.uint8))
    np.save(p2, np.ones((50, 100), dtype=np.uint8))
    
    t1 = str(tmp_path / "temp_1.npy")
    t2 = str(tmp_path / "temp_2.npy")
    np.save(t1, np.ones(1))
    np.save(t2, np.ones(1))
    
    out_file = str(tmp_path / "final.jpg")
    stitch_image([p1, p2], out_file)
    
    assert os.path.exists(out_file)
    # Ensure Memory leak is closed
    assert not os.path.exists(p1)
    assert not os.path.exists(t1)
