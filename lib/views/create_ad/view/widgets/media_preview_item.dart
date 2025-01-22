import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class MediaPreviewItem extends StatelessWidget {
  final File mediaFile;
  final bool isVideo;
  final VideoPlayerController? videoController;
  final VoidCallback onRemove;
  final Animation<double> scaleAnimation;

  const MediaPreviewItem({
    Key? key,
    required this.mediaFile,
    required this.isVideo,
    required this.videoController,
    required this.onRemove,
    required this.scaleAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Stack(
        children: [
          Container(
            width: 150,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[400]!, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: isVideo
                  ? AspectRatio(
                      aspectRatio: videoController!.value.aspectRatio,
                      child: VideoPlayer(videoController!),
                    )
                  : Image.file(mediaFile, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
