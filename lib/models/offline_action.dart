class OfflineAction {
  final String id;
  final String actionType;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final int retryCount;
  final String status; // pending, processing, success, failed

  OfflineAction({
    required this.id,
    required this.actionType,
    required this.payload,
    required this.timestamp,
    this.retryCount = 0,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actionType': actionType,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
      'retryCount': retryCount,
      'status': status,
    };
  }

  factory OfflineAction.fromJson(Map<String, dynamic> json) {
    return OfflineAction(
      id: json['id'],
      actionType: json['actionType'],
      payload: Map<String, dynamic>.from(json['payload']),
      timestamp: DateTime.parse(json['timestamp']),
      retryCount: json['retryCount'] ?? 0,
      status: json['status'] ?? 'pending',
    );
  }

  OfflineAction copyWith({
    String? id,
    String? actionType,
    Map<String, dynamic>? payload,
    DateTime? timestamp,
    int? retryCount,
    String? status,
  }) {
    return OfflineAction(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
    );
  }
}

class DownloadedContent {
  final String id;
  final String contentType; // ritual, order, stream, invoice
  final String contentId;
  final String filePath;
  final int fileSize; // in bytes
  final DateTime downloadedAt;

  DownloadedContent({
    required this.id,
    required this.contentType,
    required this.contentId,
    required this.filePath,
    required this.fileSize,
    required this.downloadedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentType': contentType,
      'contentId': contentId,
      'filePath': filePath,
      'fileSize': fileSize,
      'downloadedAt': downloadedAt.toIso8601String(),
    };
  }

  factory DownloadedContent.fromJson(Map<String, dynamic> json) {
    return DownloadedContent(
      id: json['id'],
      contentType: json['contentType'],
      contentId: json['contentId'],
      filePath: json['filePath'],
      fileSize: json['fileSize'],
      downloadedAt: DateTime.parse(json['downloadedAt']),
    );
  }

  String get formattedSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
