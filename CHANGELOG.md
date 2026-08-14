## 0.1.0

* **Feature Rich Initial Release**.
* Added `AssetBundleService` for managing remote ZIP bundles.
* Support for progress tracking and versioning.
* **Atomic Updates**: Installs bundles using a swap-and-backup mechanism to ensure data integrity.
* **Asset Discovery**: Recursive search for images (png, jpg, jpeg, webp), audio (mp3, wav, m4a, aac, ogg), and video (mp4, mov, mkv, webm).
* **Robust Logic**: Added `getInstalledVersion` and `isUpdateAvailable` for easy update management.
* **File Management**: Methods to list, check existence, and delete specific files or folders within bundles.
* **Security & Performance**: Stream-based ZIP extraction with Path Traversal (Zip Slip) protection.
