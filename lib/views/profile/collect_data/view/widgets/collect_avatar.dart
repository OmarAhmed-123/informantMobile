import 'package:flutter/material.dart';
import '../../view_model/collect_view_model.dart';
import 'package:image_picker/image_picker.dart';

class CollectAvatar extends StatelessWidget {
  final CollectViewModel viewModel;
  final Animation<double> scaleAnimation;

  const CollectAvatar({
    Key? key,
    required this.viewModel,
    required this.scaleAnimation,
  }) : super(key: key);

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.blue),
                  ),
                  title: const Text('Select from Gallery'),
                  onTap: () {
                    viewModel.pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.blue),
                  ),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    viewModel.pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: GestureDetector(
        onTap: () => _showImagePicker(context),
        child: Hero(
          tag: 'profile_image',
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.shade400,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: viewModel.selectedImage != null
                  ? FileImage(viewModel.selectedImage!)
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
              child: viewModel.selectedImage == null
                  ? Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: Colors.grey.withOpacity(0.7),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
