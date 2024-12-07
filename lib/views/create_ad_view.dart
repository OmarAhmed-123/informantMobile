import 'package:flutter/material.dart';
import 'package:graduation___part1/models/ad.dart';
import 'package:provider/provider.dart';
import '../view_models/ad_view_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:graduation___part1/views/barOfHome.dart';

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
  final ImagePicker _picker = ImagePicker();
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

  Future<void> _initializeVideoController(File videoFile, int index) async {
    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    setState(() {
      _videoControllers[index] = controller;
    });
  }

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

  Future<void> _pickMedia(ImageSource source, {required bool isVideo}) async {
    if (isVideo) {
      final XFile? videoFile = await _picker.pickVideo(source: source);
      if (videoFile != null) {
        final videoController =
            VideoPlayerController.file(File(videoFile.path));
        await videoController.initialize();
        setState(() {
          _mediaFiles.add(File(videoFile.path));
          _isVideo.add(true);
          _videoControllers.add(videoController);
        });
        _askToPickMore(isVideo: true);
      }
    } else {
      final XFile? imageFile = await _picker.pickImage(source: source);
      if (imageFile != null) {
        setState(() {
          _mediaFiles.add(File(imageFile.path));
          _isVideo.add(false);
          _videoControllers.add(null);
        });
        _askToPickMore(isVideo: false);
      }
    }
  }

  Future<void> _askToPickMore({required bool isVideo}) async {
    final bool? pickMore = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isVideo ? "Add another video?" : "Add another photo?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No"),
            )
          ],
        );
      },
    );

    if (pickMore == true) {
      await _pickMedia(ImageSource.camera, isVideo: isVideo);
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
                    _getMultipleMedia(ImageSource.gallery);
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
                    _pickMedia(ImageSource.camera, isVideo: false);
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
    for (final controller in _videoControllers) {
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
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView1()),
              );
            },
          ),
        ],
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
