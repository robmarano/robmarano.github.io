import pytest
from fastapi.testclient import TestClient
from main import app, UPLOAD_DIR_STR
import os

client = TestClient(app)

def test_upload_file():
    # Create a dummy file
    file_content = b"fake image bytes"
    response = client.post(
        "/upload",
        files={"file": ("test_image.jpg", file_content, "image/jpeg")}
    )
    assert response.status_code == 200
    assert response.json() == {"filename": "test_image.jpg", "status": "uploaded"}
    
    # Verify file is on disk
    assert os.path.exists(f"{UPLOAD_DIR_STR}/test_image.jpg")
    
    # Clean up
    if os.path.exists(f"{UPLOAD_DIR_STR}/test_image.jpg"):
        os.remove(f"{UPLOAD_DIR_STR}/test_image.jpg")

def test_upload_invalid_extension():
    file_content = b"fake text bytes"
    response = client.post(
        "/upload",
        files={"file": ("test.txt", file_content, "text/plain")}
    )
    assert response.status_code == 400
    assert "detail" in response.json()
