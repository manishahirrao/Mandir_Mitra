import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import '../services/live_stream_provider.dart';
import '../models/live_stream.dart';
import '../utils/app_theme.dart';
import '../widgets/live_stream/chat_section.dart';
import '../widgets/live_stream/video_controls.dart';
import '../widgets/live_stream/reaction_overlay.dart';

class LiveStreamScreen extends StatefulWidget {
  final String ritualId;

  const LiveStreamScreen({super.key, required this.ritualId});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _showControls = true;
  bool _isFullScreen = false;
  bool _chatExpanded = false;
  CameraAngle _currentCamera = CameraAngle.main;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    final provider = Provider.of<LiveStreamProvider>(context, listen: false);
    final stream = await provider.getStreamByRitual(widget.ritualId);

    if (stream != null && mounted) {
      await provider.joinStream(stream.id);
      _initializeVideoPlayer(stream.streamUrl);
    }
  }

  Future<void> _initializeVideoPlayer(String url) async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    
    try {
      await _controller!.initialize();
      await _controller!.play();
      setState(() {
        _isLoading = false;
      });

      _controller!.addListener(() {
        if (mounted) setState(() {});
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load stream')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    final provider = Provider.of<LiveStreamProvider>(context, listen: false);
    if (provider.currentStream != null) {
      provider.leaveStream(provider.currentStream!.id);
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<LiveStreamProvider>(
          builder: (context, provider, child) {
            final stream = provider.currentStream;
            if (stream == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            return Column(
              children: [
                _buildVideoSection(stream),
                if (!_isFullScreen) ...[
                  _buildRitualInfoBar(stream),
                  Expanded(
                    child: ChatSection(
                      streamId: stream.id,
                      isExpanded: _chatExpanded,
                      onToggle: () {
                        setState(() {
                          _chatExpanded = !_chatExpanded;
                        });
                      },
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoSection(LiveStream stream) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          // Video Player
          if (_controller != null && _controller!.value.isInitialized)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                });
              },
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
            )
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Connecting...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

          // Live Indicator
          Positioned(
            top: 16,
            left: 16,
            child: _buildLiveIndicator(stream),
          ),

          // Back Button
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Video Controls
          if (_showControls && _controller != null)
            VideoControls(
              controller: _controller!,
              onFullScreenToggle: _toggleFullScreen,
              onCameraSwitch: _switchCamera,
              availableCameras: stream.availableCameras,
              currentCamera: _currentCamera,
            ),

          // Reaction Overlay
          Positioned(
            bottom: 16,
            right: 16,
            child: ReactionOverlay(streamId: stream.id),
          ),

          // Virtual Offering Button
          if (!_isFullScreen)
            Positioned(
              bottom: 16,
              left: 16,
              child: ElevatedButton.icon(
                onPressed: () => _showOfferingSheet(stream.id),
                icon: const Icon(Icons.volunteer_activism),
                label: const Text('Make Offering'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sacredBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          // Share Button
          Positioned(
            top: 16,
            right: 60,
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () => _shareStream(stream),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveIndicator(LiveStream stream) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'LIVE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${stream.viewerCount} watching',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRitualInfoBar(LiveStream stream) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[900],
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(stream.priestAvatar),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stream.ritualName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${stream.templeName} • ${stream.priestName}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${stream.minutesRemaining} min left',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Part ${stream.currentPart}/${stream.totalParts}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _switchCamera(CameraAngle camera) {
    setState(() {
      _currentCamera = camera;
    });
    // In production, this would switch the stream URL
  }

  void _shareStream(LiveStream stream) {
    Share.share(
      'Watch the live ${stream.ritualName} with me on Mandir Mitra!\nhttps://mandirmitra.app/stream/${stream.id}',
    );
  }

  void _showOfferingSheet(String streamId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Make a Virtual Offering',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...VirtualOffering.offerings.map((offering) => Card(
                  child: ListTile(
                    leading: Text(
                      offering.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(offering.name),
                    trailing: Text(
                      '₹${offering.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.divineGold,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await Provider.of<LiveStreamProvider>(context, listen: false)
                          .makeOffering(streamId, offering);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Thank you for offering ${offering.name}!'),
                          ),
                        );
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
