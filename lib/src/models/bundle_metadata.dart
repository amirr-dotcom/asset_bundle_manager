import 'dart:convert';

/// Metadata for a downloaded asset bundle.
class BundleMetadata {
  /// The unique identifier for the bundle.
  final String bundleId;

  /// The version number of the bundle.
  final int version;

  /// The timestamp when the bundle was downloaded.
  final DateTime downloadedAt;

  /// The remote URL from which the bundle was downloaded.
  final String sourceUrl;

  /// The size of the downloaded ZIP file in bytes.
  final int size;

  /// Creates a [BundleMetadata] instance.
  BundleMetadata({
    required this.bundleId,
    required this.version,
    required this.downloadedAt,
    required this.sourceUrl,
    required this.size,
  });

  /// Converts this metadata to a JSON map.
  Map<String, dynamic> toJson() => {
        'bundleId': bundleId,
        'version': version,
        'downloadedAt': downloadedAt.toIso8601String(),
        'sourceUrl': sourceUrl,
        'size': size,
      };

  /// Creates a [BundleMetadata] from a JSON map.
  factory BundleMetadata.fromJson(Map<String, dynamic> json) => BundleMetadata(
        bundleId: json['bundleId'],
        version: json['version'],
        downloadedAt: DateTime.parse(json['downloadedAt']),
        sourceUrl: json['sourceUrl'],
        size: json['size'],
      );

  /// Converts this metadata to a raw JSON string.
  String toRawJson() => json.encode(toJson());

  /// Creates a [BundleMetadata] from a raw JSON string.
  factory BundleMetadata.fromRawJson(String str) =>
      BundleMetadata.fromJson(json.decode(str));
}
