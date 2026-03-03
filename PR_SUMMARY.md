# Pull Request Summary: ECE 465 Session 5 - Map-Reduce and Histogram Equalizer Enhancements

## Intended Changes
1. Expand Week 05 notes with a comprehensive deep-dive into the Map-Reduce paradigm (concept, history, bash & python examples).
2. Fix broken file upload mechanism in the `k8s_histogram_eq` frontend.
3. Write automated Unit and Integration tests using `pytest` and `httpx` to verify backend processing and local fallback routing.
4. Overhaul the AngularJS frontend UI aesthetics with Material Design glassmorphism and Cooper Union branding.
5. Provide UI visibility into cluster nodes and real-time distributed system logging.
6. Support deleting uploaded artifacts fully, spanning original uploads and processed output images.

## Implementation Details
1. **Curriculum Additions**: Added Section 9 to `notes_week_05.md` detailing Map-Reduce concepts, historical implementations (Google Bigtable, Hadoop), and simple shell scripting map-reduce piping.
2. **File Uploads**: Fixed an AngularJS core issue where the file model was shadowed by child scopes. Wrapped `upload.myFile` inside an object to restore seamless binary chunking to the FastAPI backend.
3. **Automated Testing Suite**: Built `test_master.py` and `test_integration.py` in the `master` module. Ensured local volume directories (`UPLOAD_DIR`) were overridden conditionally via environmental variables for safe tests. Tests successfully validated local-fallback `cv2` mapping over mock TCP sockets.
4. **Premium UI & Glassmorphism**: Rewrote `style.css` to inject modern `Outfit` typography, dark theme Cooper Union Maroon gradients, and soft shadow transitions inside `<md-card>`.
5. **Distributed Logging Console & Node Visualization**: 
   - Configured custom raw TCP `LOG <worker_id> <msg>` instructions inside `worker.py`. 
   - Built a `/logs` sliding-window API ring buffer on Master. 
   - Constructed a `$watchCollection`-powered auto-scrolling terminal console within the main SPA dashboard pinging the Master backend every 2000ms.
   - Connected active nodes render visually as dynamic, CSS-animation pulsing green badges.
6. **Artifact Management Deletion**: Wrote `DELETE /files/{filename}` endpoints that physically deletes raw bytes AND dynamically searches for generated `_equalized` derivatives. Tied this into Javascript `$scope.deleteProcessedFile` and `$scope.deleteFile` UI functions.
