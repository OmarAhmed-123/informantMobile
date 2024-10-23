// ignore_for_file: use_super_parameters, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:graduation___part1/models/ad.dart';
import 'package:provider/provider.dart';
import '../view_models/ad_view_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CreateAdView extends StatefulWidget {
  const CreateAdView({Key? key}) : super(key: key);

  @override
  _CreateAdViewState createState() => _CreateAdViewState();
}

class _CreateAdViewState extends State<CreateAdView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _media; // To hold the selected image or video file
  VideoPlayerController? _videoController; // To control video playback

  // Function to pick media from the specified source
  Future<void> _getMedia(ImageSource source, bool isVideo) async {
    final picker = ImagePicker();
    final pickedFile = isVideo
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _media =
            File(pickedFile.path); // Store the media in the _media variable
        if (isVideo) {
          _videoController = VideoPlayerController.file(_media!)
            ..initialize().then((_) {
              setState(() {}); // Refresh the UI after initialization
            });
        }
      }
    });
  }

  // Dialog for selecting image source (Gallery or Camera)
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getMedia(
                        ImageSource.gallery, false); // Open gallery for image
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showMediaTypeDialog(); // Show dialog to choose between photo and video
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Dialog for selecting media type (Photo or Video)
  void _showMediaTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Media Type'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getMedia(
                        ImageSource.camera, false); // Open camera for image
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Video'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getMedia(
                        ImageSource.camera, true); // Open camera for video
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _videoController?.dispose(); // Dispose video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Ad'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[700]!, Colors.blue[500]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // GestureDetector to open image selection (Gallery or Camera)
                GestureDetector(
                  onTap: _showImageSourceDialog, // Opens the dialog
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // Display selected media or show a placeholder
                    child: _media != null
                        ? (_media!.path.endsWith('.mp4')
                            ? _videoController!.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio:
                                        _videoController!.value.aspectRatio,
                                    child: VideoPlayer(_videoController!),
                                  )
                                : Container()
                            : Image.file(_media!, fit: BoxFit.cover))
                        : Icon(Icons.camera_alt,
                            size: 50, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 16),
                // Form fields for Ad details (Name, Description, Price)
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Ad Name',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an ad name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Button to create the Ad
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.purple[700],
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final adViewModel =
                          Provider.of<AdViewModel>(context, listen: false);
                      final newAd = Ad(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        description: _descriptionController.text,
                        price: double.parse(_priceController.text),
                        imageUrl:
                            _media?.path ?? 'https://via.placeholder.com/150',
                        createdAt: DateTime.now(),
                        earnings: 0.0,
                      );
                      adViewModel.addAd(newAd);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Ad'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
