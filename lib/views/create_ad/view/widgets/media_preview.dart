import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'media_preview_item.dart';
import 'add_media_button.dart';

class MediaPreview extends StatelessWidget {
  final List<File> mediaFiles;
  final List<bool> isVideo;
  final List<VideoPlayerController?> videoControllers;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final Function(int) onRemoveMedia;
  final VoidCallback onAddMedia;

  const MediaPreview({
    Key? key,
    required this.mediaFiles,
    required this.isVideo,
    required this.videoControllers,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.onRemoveMedia,
    required this.onAddMedia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: mediaFiles.length + 1,
          itemBuilder: (context, index) {
            if (index == mediaFiles.length) {
              return AddMediaButton(
                scaleAnimation: scaleAnimation,
                onTap: onAddMedia,
              );
            }
            return MediaPreviewItem(
              mediaFile: mediaFiles[index],
              isVideo: isVideo[index],
              videoController: videoControllers[index],
              onRemove: () => onRemoveMedia(index),
              scaleAnimation: scaleAnimation,
            );
          },
        ),
      ),
    );
  }
}
