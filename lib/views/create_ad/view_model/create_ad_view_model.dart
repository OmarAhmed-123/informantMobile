import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../../../variables.dart';

class CreateAdViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File> mediaFiles = [];
  List<bool> isVideo = [];
  List<VideoPlayerController?> videoControllers = [];

  Future<void> pickMedia(ImageSource source, {required bool isVideo}) async {
    try {
      if (isVideo) {
        final XFile? videoFile = await _picker.pickVideo(
          source: source,
          maxDuration: const Duration(minutes: 5),
        );

        if (videoFile != null) {
          final videoController =
              VideoPlayerController.file(File(videoFile.path));
          await videoController.initialize();

          mediaFiles.add(File(videoFile.path));
          this.isVideo.add(true);
          videoControllers.add(videoController);
          notifyListeners();
        }
      } else {
        final XFile? imageFile = await _picker.pickImage(source: source);

        if (imageFile != null) {
          mediaFiles.add(File(imageFile.path));
          this.isVideo.add(false);
          videoControllers.add(null);
          notifyListeners();
        }
      }
    } catch (e) {
      throw Exception('Error picking media: $e');
    }
  }

  void removeMedia(int index) {
    if (isVideo[index]) {
      videoControllers[index]?.dispose();
    }
    mediaFiles.removeAt(index);
    isVideo.removeAt(index);
    videoControllers.removeAt(index);
    notifyListeners();
  }

  Future<void> createAd() async {
    if (formKey.currentState!.validate()) {
      try {
        List<String> imageUrls = mediaFiles.map((file) => file.path).toList();

        List<Map<String, dynamic>> newAd = [
          {
            "name": nameController.text,
            "details": descriptionController.text,
            "stars": 0,
            "potentialRevenue": double.parse(priceController.text),
            "images": imageUrls,
            "availablePlaces": 10,
            "creatorName": "COMPANY NAME"
          }
        ];
        ads.add(newAd as Map<String, dynamic>);
      } catch (e) {
        throw Exception('Error creating ad: $e');
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    for (final controller in videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }
}
