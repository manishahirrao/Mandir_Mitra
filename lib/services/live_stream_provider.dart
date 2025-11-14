import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/live_stream.dart';

class LiveStreamProvider with ChangeNotifier {
  LiveStream? _currentStream;
  List<ChatMessage> _messages = [];
  int _viewerCount = 0;
  bool _isConnected = false;
  Timer? _viewerUpdateTimer;
  Timer? _messageTimer;

  LiveStreamProvider();

  LiveStream? get currentStream => _currentStream;
  List<ChatMessage> get messages => _messages;
  int get viewerCount => _viewerCount;
  bool get isConnected => _isConnected;

  Future<LiveStream?> getStreamByRitual(String ritualId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock live stream data
    _currentStream = LiveStream(
      id: 'STREAM001',
      ritualId: ritualId,
      streamUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      status: StreamStatus.live,
      startTime: DateTime.now().subtract(const Duration(minutes: 15)),
      viewerCount: 234,
      availableCameras: [
        CameraAngle.main,
        CameraAngle.deityCloseup,
        CameraAngle.fullTemple,
      ],
      ritualName: 'Satyanarayan Puja',
      templeName: 'Shri Jagannath Temple',
      priestName: 'Pandit Ramesh Sharma',
      priestAvatar: 'https://i.pravatar.cc/150?img=12',
      totalDuration: 60,
      currentPart: 2,
      totalParts: 4,
      currentActivity: 'Offering prayers',
      recordingAvailable: false,
    );

    _viewerCount = _currentStream!.viewerCount;
    _generateMockMessages();
    
    return _currentStream;
  }

  Future<void> joinStream(String streamId) async {
    _isConnected = true;
    _startViewerCountUpdates();
    _startMockMessageStream();
    notifyListeners();
  }

  Future<void> leaveStream(String streamId) async {
    _isConnected = false;
    _viewerUpdateTimer?.cancel();
    _messageTimer?.cancel();
    notifyListeners();
  }

  void _startViewerCountUpdates() {
    _viewerUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Simulate viewer count changes
      final change = (DateTime.now().second % 3) - 1; // -1, 0, or 1
      _viewerCount = (_viewerCount + change).clamp(100, 500);
      
      if (_currentStream != null) {
        _currentStream = LiveStream(
          id: _currentStream!.id,
          ritualId: _currentStream!.ritualId,
          streamUrl: _currentStream!.streamUrl,
          status: _currentStream!.status,
          startTime: _currentStream!.startTime,
          endTime: _currentStream!.endTime,
          viewerCount: _viewerCount,
          availableCameras: _currentStream!.availableCameras,
          ritualName: _currentStream!.ritualName,
          templeName: _currentStream!.templeName,
          priestName: _currentStream!.priestName,
          priestAvatar: _currentStream!.priestAvatar,
          totalDuration: _currentStream!.totalDuration,
          currentPart: _currentStream!.currentPart,
          totalParts: _currentStream!.totalParts,
          currentActivity: _currentStream!.currentActivity,
          recordingAvailable: _currentStream!.recordingAvailable,
          recordingUrl: _currentStream!.recordingUrl,
        );
      }
      
      notifyListeners();
    });
  }

  void _startMockMessageStream() {
    _messageTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      _addMockMessage();
    });
  }

  void _generateMockMessages() {
    final mockMessages = [
      'Beautiful ritual! 🙏',
      'Feeling blessed watching this',
      'Om Namah Shivaya',
      'Thank you for streaming this',
      'The priest is very knowledgeable',
      'Can we see the deity closer?',
      'Jai Shri Ram! 🚩',
      'This is so peaceful',
      'Blessed to witness this',
      'Amazing experience',
      'The mantras are so powerful',
      'Thank you Panditji',
      'Har Har Mahadev',
      'Feeling divine energy',
      'Beautiful temple',
    ];

    final names = [
      'Priya Sharma',
      'Rajesh Kumar',
      'Anita Desai',
      'Vikram Singh',
      'Meera Patel',
      'Amit Verma',
      'Sita Reddy',
      'Arjun Nair',
    ];

    for (int i = 0; i < 15; i++) {
      _messages.add(ChatMessage(
        id: 'MSG${DateTime.now().millisecondsSinceEpoch + i}',
        streamId: _currentStream?.id ?? 'STREAM001',
        userId: 'USER${i + 2}',
        userName: names[i % names.length],
        userAvatar: 'https://i.pravatar.cc/150?img=${i + 1}',
        message: mockMessages[i % mockMessages.length],
        timestamp: DateTime.now().subtract(Duration(minutes: 15 - i)),
        type: MessageType.user,
      ));
    }

    // Add system messages
    _messages.insert(
      0,
      ChatMessage(
        id: 'SYS001',
        streamId: _currentStream?.id ?? 'STREAM001',
        userId: 'SYSTEM',
        userName: 'System',
        userAvatar: '',
        message: 'Ritual started',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        type: MessageType.system,
      ),
    );
  }

  void _addMockMessage() {
    final messages = [
      'This is wonderful',
      'Jai Mata Di',
      'Blessed to be here',
      'Thank you for this',
      'Om Shanti',
    ];

    final names = ['Ravi', 'Lakshmi', 'Krishna', 'Radha', 'Ganesh'];

    _messages.add(ChatMessage(
      id: 'MSG${DateTime.now().millisecondsSinceEpoch}',
      streamId: _currentStream?.id ?? 'STREAM001',
      userId: 'USER${DateTime.now().second}',
      userName: names[DateTime.now().second % names.length],
      userAvatar: 'https://i.pravatar.cc/150?img=${DateTime.now().second % 20}',
      message: messages[DateTime.now().second % messages.length],
      timestamp: DateTime.now(),
      type: MessageType.user,
    ));

    notifyListeners();
  }

  Future<void> sendMessage(String streamId, String message) async {
    final newMessage = ChatMessage(
      id: 'MSG${DateTime.now().millisecondsSinceEpoch}',
      streamId: streamId,
      userId: 'USER001',
      userName: 'You',
      userAvatar: 'https://i.pravatar.cc/150?img=33',
      message: message,
      timestamp: DateTime.now(),
      type: MessageType.user,
      isOwn: true,
    );

    _messages.add(newMessage);
    notifyListeners();
  }

  Future<void> sendReaction(String streamId, ReactionType reaction) async {
    // In production, this would send to backend
    await Future.delayed(const Duration(milliseconds: 100));
    notifyListeners();
  }

  Future<void> makeOffering(String streamId, VirtualOffering offering) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Add system message
    _messages.add(ChatMessage(
      id: 'SYS${DateTime.now().millisecondsSinceEpoch}',
      streamId: streamId,
      userId: 'SYSTEM',
      userName: 'System',
      userAvatar: '',
      message: 'You offered ${offering.name}',
      timestamp: DateTime.now(),
      type: MessageType.admin,
    ));

    notifyListeners();
  }

  @override
  void dispose() {
    _viewerUpdateTimer?.cancel();
    _messageTimer?.cancel();
    super.dispose();
  }
}
