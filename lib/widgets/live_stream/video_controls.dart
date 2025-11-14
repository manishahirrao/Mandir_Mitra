import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../models/live_stream.dart';
import '../../utils/app_theme.dart';

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onFullScreenToggle;
  final Function(CameraAngle) onCameraSwitch;
  final List<CameraAngle> availableCameras;
  final CameraAngle currentCamera;

  const VideoControls({
    super.key,
    required this.controller,
    required this.onFullScreenToggle,
    required this.onCameraSwitch,
    required this.availableCameras,
    required this.currentCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Play/Pause Button
          Center(
            child: IconButton(
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 64,
                color: Colors.white,
              ),
              onPressed: () {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              },
            ),
          ),
          const Spacer(),
          // Bottom Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress Bar
                VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: AppTheme.sacredBlue,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.white24,
                  ),
                ),
                const SizedBox(height: 8),
                // Control Buttons
                Row(
                  children: [
                    Text(
                      _formatDuration(controller.value.position),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const Text(
                      ' / ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      _formatDuration(controller.value.duration),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const Spacer(),
                    if (availableCameras.length > 1)
                      PopupMenuButton<CameraAngle>(
                        icon: const Icon(Icons.videocam, color: Colors.white),
                        onSelected: onCameraSwitch,
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: CameraAngle.main,
                            child: Text('Main View'),
                          ),
                          const PopupMenuItem(
                            value: CameraAngle.deityCloseup,
                            child: Text('Deity Close-up'),
                          ),
                          const PopupMenuItem(
                            value: CameraAngle.fullTemple,
                            child: Text('Full Temple'),
                          ),
                        ],
                      ),
                    IconButton(
                      icon: const Icon(Icons.fullscreen, color: Colors.white),
                      onPressed: onFullScreenToggle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
