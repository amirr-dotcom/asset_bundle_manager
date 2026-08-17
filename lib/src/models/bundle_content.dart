/// Represents a summary of all content types found within an asset bundle.
class BundleContent {
  /// List of absolute paths to image files (.png, .jpg, .jpeg, .webp).
  final List<String> images;

  /// List of absolute paths to audio files (.mp3, .wav, .m4a, .aac, .ogg).
  final List<String> audio;

  /// List of absolute paths to subtitle or JSON files (.json).
  final List<String> subtitles;

  /// List of absolute paths to video files (.mp4, .mov, .mkv, .webm).
  final List<String> videos;

  /// Creates a [BundleContent] instance.
  BundleContent({
    required this.images,
    required this.audio,
    required this.subtitles,
    required this.videos,
  });

  /// Returns true if all content lists are empty.
  bool get isEmpty =>
      images.isEmpty && audio.isEmpty && subtitles.isEmpty && videos.isEmpty;

  /// Returns true if the bundle contains images.
  bool get hasImages => images.isNotEmpty;

  /// Returns true if the bundle contains audio files.
  bool get hasAudio => audio.isNotEmpty;

  /// Returns true if the bundle contains subtitle or JSON files.
  bool get hasSubtitles => subtitles.isNotEmpty;

  /// Returns true if the bundle contains video files.
  bool get hasVideos => videos.isNotEmpty;
}
