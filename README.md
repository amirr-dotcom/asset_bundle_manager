# Asset Bundle Manage

A Flutter package to efficiently manage, download, and version remote asset bundles (ZIP files). This package allows you to keep your app size small by downloading large assets (like image sequences, 3D models, or high-res textures) on demand.

## Features

*   **Remote Download**: Download ZIP bundles from any URL with progress tracking.
*   **Version Management**: Automatically handles versioning. Re-downloads and updates only when a new version is available.
*   **Atomic Updates**: Installs bundles using a swap-and-backup mechanism to ensure data integrity.
*   **Safe & Efficient Extraction**: Memory-efficient ZIP extraction using streams with security checks against path traversal (Zip Slip).
*   **Asset Discovery**: Convenient methods to find images, audio, and video files recursively within a bundle.
*   **File Management**: Easy API to locate, list, and delete files or folders within bundles.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  asset_bundle_manage: ^0.0.1
```

## Usage

### 1. Initialize and Download a Bundle

```dart
final service = AssetBundleService();

await service.downloadBundle(
  bundleId: 'hero_animation',
  url: 'https://example.com/bundles/hero_v1.zip',
  version: 1,
  onProgress: (received, total) {
    print('Progress: ${(received / total * 100).toStringAsFixed(0)}%');
  },
);
```

### 2. Versioning and Updates

```dart
// Check currently installed version
int? currentVersion = await service.getInstalledVersion('hero_animation');

// Check if an update is available (target version 2)
bool hasUpdate = await service.isUpdateAvailable('hero_animation', 2);

if (hasUpdate) {
  // Proceed with download...
}
```

### 3. Access Assets in the Bundle

```dart
// Get all images (png, jpg, jpeg, webp)
List<String> images = await service.getAllImages('hero_bundle');

// Get all audio files (mp3, wav, m4a, aac, ogg)
List<String> audio = await service.getAllAudio('hero_bundle');

// Get all video files (mp4, mov, mkv, webm)
List<String> videos = await service.getAllVideo('hero_bundle');

// Get the absolute path to a specific file
String filePath = await service.getFilePath('hero_bundle', 'data/config.json');

// List all items in the root of the bundle
List<FileSystemEntity> items = await service.listFiles('hero_bundle', '');
```

## Additional information

For a complete implementation, check the `example` folder which includes a UI for downloading and updating bundles with live progress.

### Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

### Issues
If you encounter any bugs or have feature requests, please file them on the [Issue Tracker](https://github.com/your-repo/asset_bundle_manage/issues).
