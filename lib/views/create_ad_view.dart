/*
//the old animation

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
  CreateAdViewS createState() => CreateAdViewS();
}

class CreateAdViewS extends State<CreateAdView>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  List<File> mediaFiles = [];
  List<bool> video = [];
  List<VideoPlayerController?> videoControllers = [];
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  final ImagePicker pick = ImagePicker();
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );
    animationController.forward();
  }

  Future<void> initiVideoController(File videoFile, int index) async {
    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    setState(() {
      videoControllers[index] = controller;
    });
  }

  Future<void> getMedia(ImageSource source, {bool isVideo = false}) async {
    final picker = ImagePicker();
    if (isVideo) {
      final XFile? videoFile = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );
      if (videoFile != null) {
        setState(() {
          mediaFiles.add(File(videoFile.path));
          video.add(true);
          videoControllers.add(null);
        });
        await initiVideoController(mediaFiles.last, mediaFiles.length - 1);
      }
    } else {
      final List<XFile> images = await picker.pickMultiImage();
      setState(() {
        for (var image in images) {
          mediaFiles.add(File(image.path));
          video.add(false);
          videoControllers.add(null);
        }
      });
    }
  }

  Future<void> pickMedia(ImageSource source, {required bool isVideo}) async {
    if (isVideo) {
      final XFile? videoFile = await pick.pickVideo(source: source);
      if (videoFile != null) {
        final videoController =
            VideoPlayerController.file(File(videoFile.path));
        await videoController.initialize();
        setState(() {
          mediaFiles.add(File(videoFile.path));
          video.add(true);
          videoControllers.add(videoController);
        });
        askToPickMore(isVideo: true);
      }
    } else {
      final XFile? imageFile = await pick.pickImage(source: source);
      if (imageFile != null) {
        setState(() {
          mediaFiles.add(File(imageFile.path));
          video.add(false);
          videoControllers.add(null);
        });
        askToPickMore(isVideo: false);
      }
    }
  }

  Future<void> askToPickMore({required bool isVideo}) async {
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
      await pickMedia(ImageSource.camera, isVideo: isVideo);
    }
  }

  void showMedia() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: scaleAnimation,
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
                buildMediaOption(
                  icon: Icons.photo_library,
                  title: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    showOptions2();
                  },
                ),
                const SizedBox(height: 16),
                buildMediaOption(
                  icon: Icons.camera_alt,
                  title: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    showOptions();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

void showOptions2() {

    showDialog(

      context: context,

      builder: (BuildContext context) {

        return ScaleTransition(

          scale: scaleAnimation,

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

                buildMediaOption(

                  icon: Icons.photo_camera,

                  title: 'Photo Gallery',

                  onTap: () {

                    Navigator.pop(context);

                    getMedia(ImageSource.gallery);

                  },

                ),

                const SizedBox(height: 16),

                buildMediaOption(

                  icon: Icons.videocam,

                  title: 'Video Gallery',

                  onTap: () {

                    Navigator.pop(context);

                    getMedia(ImageSource.gallery, isVideo: true);

                  },

                ),

              ],

            ),

          ),

        );

      },

    );

  }    
    
    
  void showOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: scaleAnimation,
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
                buildMediaOption(
                  icon: Icons.photo_camera,
                  title: 'Take Photo',
                  onTap: () {
                    Navigator.pop(context);
                    pickMedia(ImageSource.camera, isVideo: false);
                  },
                ),
                const SizedBox(height: 16),
                buildMediaOption(
                  icon: Icons.videocam,
                  title: 'Record Video',
                  onTap: () {
                    Navigator.pop(context);
                    pickMedia(ImageSource.camera, isVideo: true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMediaOption({
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

  Widget buildMediaPreview() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mediaFiles.length + 1,
        itemBuilder: (context, index) {
          if (index == mediaFiles.length) {
            return GestureDetector(
              onTap: showMedia,
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
                  child: video[index]
                      ? AspectRatio(
                          aspectRatio:
                              videoControllers[index]!.value.aspectRatio,
                          child: VideoPlayer(videoControllers[index]!),
                        )
                      : Image.file(mediaFiles[index], fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (video[index]) {
                        videoControllers[index]?.dispose();
                      }
                      mediaFiles.removeAt(index);
                      video.removeAt(index);
                      videoControllers.removeAt(index);
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
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    for (final controller in videoControllers) {
      controller?.dispose();
    }
    animationController.dispose();
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
            key: formKey,
            child: Column(
              children: [
                buildMediaPreview(),
                const SizedBox(height: 24),
                buildAnimatedForm(
                  controller: nameController,
                  label: 'Ad Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an ad name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                buildAnimatedForm(
                  controller: descriptionController,
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
                buildAnimatedForm(
                  controller: priceController,
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
                  animation: animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: scaleAnimation.value,
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
                            if (formKey.currentState!.validate()) {
                              final adViewModel = Provider.of<AdViewModel>(
                                  context,
                                  listen: false);
                              final newAd = Ad(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                name: nameController.text,
                                details: descriptionController.text,
                                description: descriptionController
                                    .text, // Added missing description parameter
                                price: double.parse(priceController.text),
                                imageUrl:
                                    mediaFiles // Changed 'images' to 'imageUrl' to match the Ad model
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

  Widget buildAnimatedForm({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
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
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:graduation___part1/models/ad.dart';
import 'package:graduation___part1/view_models/ad_view_model.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:graduation___part1/views/barOfHome.dart';

class CreateAdView extends StatefulWidget {
  const CreateAdView({Key? key}) : super(key: key);

  @override
  CreateAdViewState createState() => CreateAdViewState();
}

class CreateAdViewState extends State<CreateAdView>
    with TickerProviderStateMixin {
  // Form controllers
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  // Media handling
  final ImagePicker _picker = ImagePicker();
  List<File> mediaFiles = [];
  List<bool> isVideo = [];
  List<VideoPlayerController?> videoControllers = [];

  // Animations
  late AnimationController _formAnimationController;
  late AnimationController _mediaAnimationController;
  late AnimationController _buttonAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Form animations
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Media preview animations
    _mediaAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mediaAnimationController,
      curve: Curves.easeIn,
    ));

    // Button animations
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
    _formAnimationController.forward();
    _mediaAnimationController.forward();
    _buttonAnimationController.forward();
  }

  Future<void> _initializeVideoController(File videoFile, int index) async {
    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    setState(() {
      videoControllers[index] = controller;
    });
  }

  Future<void> _pickMedia(ImageSource source, {required bool isVideo}) async {
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

          setState(() {
            mediaFiles.add(File(videoFile.path));
            this.isVideo.add(true);
            videoControllers.add(videoController);
          });

          _mediaAnimationController.reset();
          _mediaAnimationController.forward();

          _showPickMoreDialog(isVideo: true);
        }
      } else {
        final XFile? imageFile = await _picker.pickImage(source: source);

        if (imageFile != null) {
          setState(() {
            mediaFiles.add(File(imageFile.path));
            this.isVideo.add(false);
            videoControllers.add(null);
          });

          _mediaAnimationController.reset();
          _mediaAnimationController.forward();

          _showPickMoreDialog(isVideo: false);
        }
      }
    } catch (e) {
      _showErrorDialog('Error picking media: $e');
    }
  }

  Future<void> _showPickMoreDialog({required bool isVideo}) async {
    final bool? pickMore = await showDialog<bool>(
      context: context,
      builder: (context) => _buildAnimatedDialog(
        title: isVideo ? "Add another video?" : "Add another photo?",
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
        ],
      ),
    );

    if (pickMore == true) {
      await _pickMedia(ImageSource.gallery, isVideo: isVideo);
    }
  }

  Widget _buildAnimatedDialog({
    required String title,
    required List<Widget> actions,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        actions: actions,
      ),
    );
  }

  void _showMediaSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildAnimatedDialog(
        title: 'Choose Media Source',
        actions: [
          _buildMediaOption(
            icon: Icons.photo_library,
            title: 'Gallery',
            onTap: () {
              Navigator.pop(context);
              _showMediaTypeDialog(ImageSource.gallery);
            },
          ),
          _buildMediaOption(
            icon: Icons.camera_alt,
            title: 'Camera',
            onTap: () {
              Navigator.pop(context);
              _showMediaTypeDialog(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  void _showMediaTypeDialog(ImageSource source) {
    showDialog(
      context: context,
      builder: (context) => _buildAnimatedDialog(
        title: 'Choose Media Type',
        actions: [
          _buildMediaOption(
            icon: Icons.photo_camera,
            title:
                source == ImageSource.camera ? 'Take Photo' : 'Photo Gallery',
            onTap: () {
              Navigator.pop(context);
              _pickMedia(source, isVideo: false);
            },
          ),
          _buildMediaOption(
            icon: Icons.videocam,
            title:
                source == ImageSource.camera ? 'Record Video' : 'Video Gallery',
            onTap: () {
              Navigator.pop(context);
              _pickMedia(source, isVideo: true);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: InkWell(
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
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: mediaFiles.length + 1,
          itemBuilder: (context, index) {
            if (index == mediaFiles.length) {
              return _buildAddMediaButton();
            }
            return _buildMediaPreviewItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildAddMediaButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _showMediaSourceDialog,
        child: Container(
          width: 150,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
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
          child: const Icon(
            Icons.add_photo_alternate,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreviewItem(int index) {
    return ScaleTransition(
      scale: _scaleAnimation,
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
              child: isVideo[index]
                  ? AspectRatio(
                      aspectRatio: videoControllers[index]!.value.aspectRatio,
                      child: VideoPlayer(videoControllers[index]!),
                    )
                  : Image.file(mediaFiles[index], fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => _removeMedia(index),
            ),
          ),
        ],
      ),
    );
  }

  void _removeMedia(int index) {
    setState(() {
      if (isVideo[index]) {
        videoControllers[index]?.dispose();
      }
      mediaFiles.removeAt(index);
      isVideo.removeAt(index);
      videoControllers.removeAt(index);
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => _buildAnimatedDialog(
        title: 'Error',
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _createAd() async {
    if (formKey.currentState!.validate()) {
      try {
        final adViewModel = Provider.of<AdViewModel>(context, listen: false);
        final newAd = Ad(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: nameController.text,
          details: descriptionController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          imageUrl: mediaFiles.map((file) => file.path).toList(),
          createdAt: DateTime.now(),
          earnings: 0.0,
          stars: 0,
          potentialRevenue: 0.0,
          availablePlaces: 0,
          creatorName: 'New Creator',
        );

        adViewModel.addAd(newAd);
        Navigator.pop(context);
      } catch (e) {
        _showErrorDialog('Error creating ad: $e');
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    for (final controller in videoControllers) {
      controller?.dispose();
    }

    // Dispose animation controllers
    _formAnimationController.dispose();
    _mediaAnimationController.dispose();
    _buttonAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.home, color: Colors.white),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeView1()),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
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
        child: SlideTransition(
          position: _slideAnimation,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _buildMediaPreview(),
                const SizedBox(height: 24),
                _buildFormFields(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildAnimatedFormField(
          controller: nameController,
          label: 'Ad Name',
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter an ad name';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildAnimatedFormField(
          controller: descriptionController,
          label: 'Description',
          maxLines: 3,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter a description';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildAnimatedFormField(
          controller: priceController,
          label: 'Price',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter a price';
            if (double.tryParse(value!) == null)
              return 'Please enter a valid number';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedFormField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
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
  }

  Widget _buildSubmitButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
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
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _createAd,
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
  }
}
