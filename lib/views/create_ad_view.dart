// ignore_for_file: use_super_parameters, library_private_types_in_public_api, unused_import, duplicate_ignore, unnecessary_null_comparison

/*
import 'package:flutter/material.dart';
import 'package:graduation___part1/models/ad.dart';
import 'package:provider/provider.dart';
import '../view_models/ad_view_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  File? _mediaFile; // To hold the selected image file

  // Function to pick an image from the gallery or camera
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    // Pick image from the specified source (Gallery or Camera)
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _mediaFile =
            File(pickedFile.path); // Store the image in the _mediaFile variable
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
                    _getImage(ImageSource.gallery); // Open gallery
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.camera); // Open camera
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
                    // Display selected image or show a placeholder
                    child: _mediaFile != null
                        ? Image.file(_mediaFile!, fit: BoxFit.cover)
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
                        details: _descriptionController.text,
                        price: double.parse(_priceController.text),
                        imageUrl: _mediaFile != null
                            ? [_mediaFile!.path]
                            : ['https://via.placeholder.com/150'],
                        createdAt: DateTime.now(),
                        earnings: 0.0,
                        stars: 0,
                        potentialRevenue: 0.0,
                        availablePlaces: 0,
                        creatorName: 'New Creator',
                        description:
                            _descriptionController.text, // Add this line
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
//it is comment to save the code not forget
*/

//this code make design is divide the camera icon to 3 parts
/*
// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:graduation___part1/models/ad.dart';
import 'package:provider/provider.dart';
import '../view_models/ad_view_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:animations/animations.dart';

class CreateAdView extends StatefulWidget {
  const CreateAdView({Key? key}) : super(key: key);

  @override
  _CreateAdViewState createState() => _CreateAdViewState();
}

class _CreateAdViewState extends State<CreateAdView>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  List<File> _mediaFiles = []; // To hold multiple media files
  List<bool> _isVideo = []; // Track which files are videos
  List<VideoPlayerController?> _videoControllers = [];
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _fadeController.dispose();
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeVideoController(File videoFile, int index) async {
    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    setState(() {
      _videoControllers[index] = controller;
    });
  }

  // Function to pick multiple images from gallery
  Future<void> _getMultipleMedia(ImageSource source,
      {bool isVideo = false}) async {
    final picker = ImagePicker();
    if (isVideo) {
      final XFile? videoFile = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );
      if (videoFile != null) {
        setState(() {
          _mediaFiles.add(File(videoFile.path));
          _isVideo.add(true);
          _videoControllers.add(null);
        });
        await _initializeVideoController(
            _mediaFiles.last, _mediaFiles.length - 1);
      }
    } else {
      final List<XFile> images = await picker.pickMultiImage();
      setState(() {
        for (var image in images) {
          _mediaFiles.add(File(image.path));
          _isVideo.add(false);
          _videoControllers.add(null);
        }
      });
    }
  }

  void _showMediaTypeDialog(ImageSource source) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Choose Media Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.purple),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _getMultipleMedia(source);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam, color: Colors.blue),
                title: const Text('Record Video'),
                onTap: () {
                  Navigator.pop(context);
                  _getMultipleMedia(source, isVideo: true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Choose Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.purple),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getMultipleMedia(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _showMediaTypeDialog(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaPreview() {
    return Container(
      height: 200,
      child: _mediaFiles.isEmpty
          ? GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Icon(Icons.add_a_photo, size: 50, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _mediaFiles.length + 1,
              itemBuilder: (context, index) {
                if (index == _mediaFiles.length) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            Icon(Icons.add, size: 50, color: Colors.grey[600]),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _isVideo[index]
                            ? _videoControllers[index] != null
                                ? AspectRatio(
                                    aspectRatio: _videoControllers[index]!
                                        .value
                                        .aspectRatio,
                                    child:
                                        VideoPlayer(_videoControllers[index]!),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator())
                            : Image.file(
                                _mediaFiles[index],
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              if (_isVideo[index]) {
                                _videoControllers[index]?.dispose();
                              }
                              _mediaFiles.removeAt(index);
                              _isVideo.removeAt(index);
                              _videoControllers.removeAt(index);
                            });
                          },
                        ),
                      ),
                      if (_isVideo[index])
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: IconButton(
                            icon: Icon(
                              _videoControllers[index]?.value.isPlaying ?? false
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_videoControllers[index]?.value.isPlaying ??
                                    false) {
                                  _videoControllers[index]?.pause();
                                } else {
                                  _videoControllers[index]?.play();
                                }
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Ad'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple[700]!, Colors.blue[500]!],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[50]!, Colors.blue[50]!],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildMediaPreview(),
                  const SizedBox(height: 16),
                  _buildAnimatedTextField(
                    controller: _nameController,
                    labelText: 'Ad Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an ad name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildAnimatedTextField(
                    controller: _descriptionController,
                    labelText: 'Description',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildAnimatedTextField(
                    controller: _priceController,
                    labelText: 'Price',
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple[700],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final adViewModel =
                              Provider.of<AdViewModel>(context, listen: false);
                          final newAd = Ad(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: _nameController.text,
                            details: _descriptionController.text,
                            price: double.parse(_priceController.text),
                            imageUrl:
                                _mediaFiles.map((file) => file.path).toList(),
                            createdAt: DateTime.now(),
                            earnings: 0.0,
                            stars: 0,
                            potentialRevenue: 0.0,
                            availablePlaces: 0,
                            creatorName: 'New Creator',
                            description: _descriptionController.text,
                          );
                          adViewModel.addAd(newAd);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Create Ad',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.purple[700]!, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.purple[700]!, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.purple[200]!, width: 1),
          ),
          labelStyle: TextStyle(color: Colors.purple[700]),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
*/

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

class _CreateAdViewState extends State<CreateAdView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  List<File> _mediaFiles = []; // To hold multiple media files
  List<bool> _isVideo = []; // Track which files are videos
  List<VideoPlayerController?> _videoControllers = [];
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final picker = ImagePicker();
    if (isVideo) {
      final XFile? videoFile = await picker.pickVideo(source: source);
      if (videoFile != null) {
        final videoController =
            VideoPlayerController.file(File(videoFile.path));
        await videoController.initialize();
        setState(() {
          _mediaFiles.add(File(videoFile.path));
          _isVideo.add(true);
          _videoControllers.add(videoController);
        });
      }
    } else {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _mediaFiles.addAll(images.map((image) => File(image.path)));
          _isVideo.addAll(List.generate(images.length, (_) => false));
          _videoControllers.addAll(List.generate(images.length, (_) => null));
        });
      }
    }
  }

  void _showMediaSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: AlertDialog(
            backgroundColor: Colors.grey[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text(
              'Choose Media Source',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMediaOption(
                  icon: Icons.photo_library,
                  title: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickMedia(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 16),
                _buildMediaOption(
                  icon: Icons.camera_alt,
                  title: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _showCameraOptionsDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCameraOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: AlertDialog(
            backgroundColor: Colors.grey[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text(
              'Choose Camera Mode',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMediaOption(
                  icon: Icons.photo_camera,
                  title: 'Take Photo',
                  onTap: () {
                    Navigator.pop(context);
                    _pickMedia(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 16),
                _buildMediaOption(
                  icon: Icons.videocam,
                  title: 'Record Video',
                  onTap: () {
                    Navigator.pop(context);
                    _pickMedia(ImageSource.camera, isVideo: true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[700]!, Colors.blue[900]!],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mediaFiles.length + 1,
        itemBuilder: (context, index) {
          if (index == _mediaFiles.length) {
            return GestureDetector(
              onTap: _showMediaSourceDialog,
              child: Container(
                width: 150,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[400]!, width: 2),
                ),
                child: const Icon(
                  Icons.add_photo_alternate,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            );
          }

          return Stack(
            children: [
              Container(
                width: 150,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[400]!, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _isVideo[index]
                      ? AspectRatio(
                          aspectRatio:
                              _videoControllers[index]!.value.aspectRatio,
                          child: VideoPlayer(_videoControllers[index]!),
                        )
                      : Image.file(_mediaFiles[index], fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (_isVideo[index]) {
                        _videoControllers[index]?.dispose();
                      }
                      _mediaFiles.removeAt(index);
                      _isVideo.removeAt(index);
                      _videoControllers.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create Ad',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.6),
              Colors.black,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildMediaPreview(),
                const SizedBox(height: 24),
                _buildAnimatedFormField(
                  controller: _nameController,
                  label: 'Ad Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an ad name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildAnimatedFormField(
                  controller: _descriptionController,
                  label: 'Description',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildAnimatedFormField(
                  controller: _priceController,
                  label: 'Price',
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
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade700,
                              Colors.blue.shade900,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade900.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final adViewModel = Provider.of<AdViewModel>(
                                  context,
                                  listen: false);
                              final newAd = Ad(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                name: _nameController.text,
                                details: _descriptionController.text,
                                description: _descriptionController
                                    .text, // Added missing description parameter
                                price: double.parse(_priceController.text),
                                imageUrl:
                                    _mediaFiles // Changed 'images' to 'imageUrl' to match the Ad model
                                        .map((file) => file.path)
                                        .toList(),
                                createdAt: DateTime.now(),
                                earnings: 0.0,
                                stars: 0,
                                potentialRevenue: 0.0,
                                availablePlaces: 0,
                                creatorName: 'New Creator',
                              );
                              adViewModel.addAd(newAd);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Create Ad',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFormField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade900.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              maxLines: maxLines ?? 1,
              keyboardType: keyboardType,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.blue.shade200),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue.shade900),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.red.shade400),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.red.shade400, width: 2),
                ),
              ),
              validator: validator,
            ),
          ),
        );
      },
    );
  }
}
