// video_model.dart
class VideoModel {
  final String videoTitle;
  final String videoThumbnail;
  final String videoUrl;
  final String? videoDescription;

  VideoModel({
    required this.videoTitle,
    required this.videoThumbnail,
    required this.videoUrl,
    this.videoDescription,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      videoTitle: json['videoTitle'] ?? '',
      videoThumbnail: json['videoThumbnail'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      videoDescription: json['videoDescription'],
    );
  }
}
