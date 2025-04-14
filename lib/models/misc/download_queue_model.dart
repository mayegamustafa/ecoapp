class FileDownloaderQueueModel {
  FileDownloaderQueueModel({
    required this.id,
    required this.url,
    required this.progress,
    required this.downloadPath,
  });

  final String downloadPath;
  final int id;
  final double? progress;
  final String url;

  FileDownloaderQueueModel updateProgress(double? progress) {
    return FileDownloaderQueueModel(
      id: id,
      url: url,
      downloadPath: downloadPath,
      progress: progress,
    );
  }

  FileDownloaderQueueModel copyWith({
    int? id,
    String? url,
    double? progress,
    String? downloadPath,
  }) {
    return FileDownloaderQueueModel(
      id: id ?? this.id,
      url: url ?? this.url,
      progress: progress ?? this.progress,
      downloadPath: downloadPath ?? this.downloadPath,
    );
  }
}
