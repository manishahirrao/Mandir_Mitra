enum StreamStatus {
  scheduled,
  live,
  ended,
}

enum CameraAngle {
  main,
  deityCloseup,
  fullTemple,
}

enum MessageType {
  user,
  system,
  admin,
}

enum ReactionType {
  heart,
  foldedHands,
  om,
}

class LiveStream {
  final String id;
  final String ritualId;
  final String streamUrl;
  final StreamStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final int viewerCount;
  final List<CameraAngle> availableCameras;
  final String ritualName;
  final String templeName;
  final String priestName;
  final String priestAvatar;
  final int totalDuration; // in minutes
  final int currentPart;
  final int totalParts;
  final String currentActivity;
  final bool recordingAvailable;
  final String? recordingUrl;

  LiveStream({
    required this.id,
    required this.ritualId,
    required this.streamUrl,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.viewerCount,
    required this.availableCameras,
    required this.ritualName,
    required this.templeName,
    required this.priestName,
    required this.priestAvatar,
    required this.totalDuration,
    required this.currentPart,
    required this.totalParts,
    required this.currentActivity,
    this.recordingAvailable = false,
    this.recordingUrl,
  });

  bool get isLive => status == StreamStatus.live;
  bool get isScheduled => status == StreamStatus.scheduled;
  bool get hasEnded => status == StreamStatus.ended;

  Duration get timeUntilStart {
    if (isScheduled) {
      return startTime.difference(DateTime.now());
    }
    return Duration.zero;
  }

  int get minutesRemaining {
    if (!isLive) return 0;
    final elapsed = DateTime.now().difference(startTime).inMinutes;
    return totalDuration - elapsed;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ritualId': ritualId,
      'streamUrl': streamUrl,
      'status': status.toString(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'viewerCount': viewerCount,
      'availableCameras': availableCameras.map((c) => c.toString()).toList(),
      'ritualName': ritualName,
      'templeName': templeName,
      'priestName': priestName,
      'priestAvatar': priestAvatar,
      'totalDuration': totalDuration,
      'currentPart': currentPart,
      'totalParts': totalParts,
      'currentActivity': currentActivity,
      'recordingAvailable': recordingAvailable,
      'recordingUrl': recordingUrl,
    };
  }

  factory LiveStream.fromJson(Map<String, dynamic> json) {
    return LiveStream(
      id: json['id'],
      ritualId: json['ritualId'],
      streamUrl: json['streamUrl'],
      status: StreamStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      viewerCount: json['viewerCount'],
      availableCameras: (json['availableCameras'] as List)
          .map((c) => CameraAngle.values.firstWhere((e) => e.toString() == c))
          .toList(),
      ritualName: json['ritualName'],
      templeName: json['templeName'],
      priestName: json['priestName'],
      priestAvatar: json['priestAvatar'],
      totalDuration: json['totalDuration'],
      currentPart: json['currentPart'],
      totalParts: json['totalParts'],
      currentActivity: json['currentActivity'],
      recordingAvailable: json['recordingAvailable'] ?? false,
      recordingUrl: json['recordingUrl'],
    );
  }
}

class ChatMessage {
  final String id;
  final String streamId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String message;
  final DateTime timestamp;
  final MessageType type;
  final bool isOwn;

  ChatMessage({
    required this.id,
    required this.streamId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isOwn = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'streamId': streamId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'isOwn': isOwn,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      streamId: json['streamId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      isOwn: json['isOwn'] ?? false,
    );
  }
}

class StreamQuality {
  final String label;
  final String resolution;
  final int bitrate;

  StreamQuality({
    required this.label,
    required this.resolution,
    required this.bitrate,
  });

  static List<StreamQuality> get availableQualities => [
        StreamQuality(label: 'Auto', resolution: 'auto', bitrate: 0),
        StreamQuality(label: '1080p', resolution: '1920x1080', bitrate: 5000),
        StreamQuality(label: '720p', resolution: '1280x720', bitrate: 2500),
        StreamQuality(label: '480p', resolution: '854x480', bitrate: 1000),
        StreamQuality(label: '360p', resolution: '640x360', bitrate: 500),
      ];
}

class VirtualOffering {
  final String id;
  final String name;
  final int price;
  final String icon;

  VirtualOffering({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
  });

  static List<VirtualOffering> get offerings => [
        VirtualOffering(id: 'flowers', name: 'Flowers', price: 51, icon: '🌸'),
        VirtualOffering(id: 'coconut', name: 'Coconut', price: 101, icon: '🥥'),
        VirtualOffering(id: 'prasad', name: 'Special Prasad', price: 251, icon: '🍯'),
      ];
}
