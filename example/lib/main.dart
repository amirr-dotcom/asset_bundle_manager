import 'dart:io';
import 'package:flutter/material.dart';
import 'package:asset_bundle_manage/asset_bundle_manage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Bundle Manage Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AssetBundleService _bundleService = AssetBundleService();
  String _status = 'Idle';
  double _progress = 0;
  List<String> _imagePaths = [];
  int _installedVersion = 0;
  int _targetVersion = 1;
  bool _isDownloading = false;

  final String bundleId = 'test_bundle';
  final String bundleUrl = 'https://github.com/ultralytics/yolov5/releases/download/v1.0/coco128.zip';

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final version = await _bundleService.getInstalledVersion(bundleId);
    final images = await _bundleService.getAllImages(bundleId);
    setState(() {
      _installedVersion = version ?? 0;
      _imagePaths = images;
      if (_installedVersion > 0) {
        _status = 'Installed v$_installedVersion';
      } else {
        _status = 'Not installed';
      }
    });
  }

  Future<void> _downloadBundle() async {
    setState(() {
      _isDownloading = true;
      _status = 'Downloading v$_targetVersion...';
      _progress = 0;
    });

    try {
      await _bundleService.downloadBundle(
        bundleId: bundleId,
        url: bundleUrl,
        version: _targetVersion,
        onProgress: (received, total) {
          if (total > 0) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );

      await _checkStatus();
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> _clearAll() async {
    await _bundleService.clearAll();
    await _checkStatus();
    setState(() {
      _status = 'Cleared all bundles';
      _targetVersion = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool updateAvailable = _installedVersion < _targetVersion;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Asset Bundle Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Installed Version: ${_installedVersion > 0 ? _installedVersion : "None"}'),
                            Text('Target Version: $_targetVersion'),
                          ],
                        ),
                        if (_installedVersion > 0)
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              setState(() {
                                _targetVersion = _installedVersion + 1;
                              });
                            },
                            tooltip: 'Simulate Update',
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Status: $_status', style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (_isDownloading) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: _progress),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (!updateAvailable && _installedVersion > 0)
                  const Text('✅ Up to date')
                else
                  ElevatedButton.icon(
                    onPressed: _isDownloading ? null : _downloadBundle,
                    icon: Icon(updateAvailable && _installedVersion > 0 ? Icons.system_update : Icons.download),
                    label: Text(updateAvailable && _installedVersion > 0 ? 'Update to v$_targetVersion' : 'Download v$_targetVersion'),
                  ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _isDownloading ? null : _clearAll,
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Images in bundle (${_imagePaths.length}):', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Expanded(
              child: _imagePaths.isEmpty
                  ? const Center(child: Text('No images to display'))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _imagePaths.length,
                      itemBuilder: (context, index) {
                        final path = _imagePaths[index];
                        return Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(path),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, color: Colors.red),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              path.split('/').last,
                              style: const TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
