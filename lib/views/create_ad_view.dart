/*
// ignore_for_file: unnecessary_null_comparison
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createAd() async {
    if (formKey.currentState!.validate()) {
      HttpRequest.post({
        "endPoint": "/user/createAd",
        "name": nameController.text,
        "details": descriptionController.text,
        "imageName": "",
        "images": "",
        "planNum": 0,
        "setToPublic": false,
        "link": "",
      }).then((res) => {
            if (res.statusCode == 200)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ad created successfully!'),
                    backgroundColor: Colors.green,
                  ),
                ),
              }
          });

      // Navigate back
      Navigator.pop(context);
    }
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

/*
// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';

import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:graduation___part1/views/home_view.dart';
import 'package:graduation___part1/views/barOfHome.dart';

class Plan {
  final int id;
  final String name;
  final String description;
  final double price;
  final double NoMonths;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.NoMonths,
  });
}

class CreateAdView extends StatefulWidget {
  const CreateAdView({Key? key}) : super(key: key);

  @override
  CreateAdViewS createState() => CreateAdViewS();
}

class CreateAdViewS extends State<CreateAdView> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  late String imageAd;
  // Media handling
  List<File> mediaFiles = [];
  List<bool> video = [];
  List<VideoPlayerController?> videoControllers = [];
  final ImagePicker pick = ImagePicker();

  // Animation controllers
  late AnimationController animationController;
  late AnimationController planAnimationController;
  late Animation<double> scaleAnimation;
  late Animation<double> planSlideAnimation;

  // Plan selection
  Plan? selectedPlan;
  final List<Plan> plans = [
    Plan(
      id: 0,
      name: 'Basic Plan',
      description: 'Boost your business with cost-effective advertising by choosing our Basic Plan, which offers a competitive view rate of 0.11% for additional views. Save money while maximizing your reach.\n🔥MONTHES: 1',
      price: 4500,
      NoMonths:1
    ),
    Plan(
      id: 1,
      name: 'Growth Accelerator Plan',
      description: 'Growth Accelerator Plan: Maximize Exposure with Indeed and Google Ads Our Growth Accelerator Plan is crafted to significantly expand your reach by leveraging both Indeed and Google Ads. This plan is designed to attract more employers and increase visibility for your ads, offering a competitive rate of 0.13% per 100 views.\n🔥MONTHES: 2',
      price: 15000,
      NoMonths:2
    ),
    Plan(
      id: 2,
      name: 'Omni-Channel Growth Mastery Plan',
      description: 'Omni-Channel Growth Mastery Plan: Unlock the Full Potential of Multi-Platform Advertising Our Omni-Channel Growth Mastery Plan is expertly crafted to maximize your brand’s exposure across the most impactful digital advertising platforms. This comprehensive plan strategically targets key touchpoints, ensuring your message reaches the right audience through Google, YouTube, Facebook, Twitter, and other major social media channels. Managed by a team of seasoned freelancers and influencers, this plan offers a highly effective rate of 0.002% per 100 views. \n🔥MONTHES: 3',
      price: 50000,
      NoMonths:3
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Main animation controller
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Plan selection animation controller
    planAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Scale animation for form elements
    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    // Slide animation for plan selection
    planSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: planAnimationController, curve: Curves.easeInOut),
    );

    animationController.forward();
    planAnimationController.forward();
  }

  Widget _buildPlanSelector() {
    return AnimatedBuilder(
      animation: planAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - planSlideAnimation.value)),
          child: Opacity(
            opacity: planSlideAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...plans.map((plan) => _buildPlanCard(plan)).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanCard(Plan plan) {
    final isSelected = selectedPlan?.id == plan.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = plan;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [Colors.blue[700]!, Colors.purple[900]!]
                : [Colors.grey[900]!, Colors.grey[800]!],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[300],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${plan.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: isSelected ? Colors.green[300] : Colors.grey[400],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.description,
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
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
      final byte = File(imageFile!.path);
      final bytes = await byte.readAsBytes();
      imageAd = base64Encode(bytes);
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

  Future<void> _createAd() async {
    if (formKey.currentState!.validate() && selectedPlan != null) {
      HttpRequest.post({
        "endPoint": "/user/createAd",
        "name": nameController.text,
        "details": descriptionController.text,
        "imageName": "1.jpeg",
        "images": imageAd,
        "planNum": selectedPlan!.id,
        "setToPublic": false,
        "link": linkController.text,
      }).then((res) {
        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ad created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      });
    } else if (selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a plan'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView1()),
            ),
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
                  controller: linkController,
                  label: 'Site Link (Optional)',
                  keyboardType: TextInputType.url,
                ),
                _buildPlanSelector(),
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

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    for (final controller in videoControllers) {
      controller?.dispose();
    }
    animationController.dispose();
    planAnimationController.dispose();
    super.dispose();
  }
}
*/

// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:graduation___part1/views/barOfHome.dart';

// Plan model representing different advertising plans
class Plan {
  final int id;
  final String name;
  final String description;
  final double price;
  final double NoMonths;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.NoMonths,
  });
}

// Cubit for managing the state of ad creation
class CreateAdCubit extends Cubit<void> {
  CreateAdCubit() : super(null);

  Future<void> createAd({
    required String name,
    required String details,
    required String imageName,
    required String images,
    required int planNum,
    required bool setToPublic,
    required String link,
  }) async {
    try {
      // Simulate a network call using Cubit
      final response = await HttpRequest.post({
        "endPoint": "/user/createAd",
        "name": name,
        "details": details,
        "imageName": imageName,
        "images": images,
        "planNum": planNum,
        "setToPublic": setToPublic,
        "link": link,
      });

      if (response.statusCode == 200) {
        // Handle successful ad creation
        emit(null); // Emit a state change if needed
      } else {
        // Handle error
        throw Exception('Failed to create ad');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Error: $e');
    }
  }
}

// Main widget for creating an ad
class CreateAdView extends StatefulWidget {
  const CreateAdView({Key? key}) : super(key: key);

  @override
  CreateAdViewS createState() => CreateAdViewS();
}

class CreateAdViewS extends State<CreateAdView> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  late String imageAd;

  // Media handling
  List<File> mediaFiles = [];
  List<bool> video = [];
  List<VideoPlayerController?> videoControllers = [];
  final ImagePicker pick = ImagePicker();

  // Animation controllers
  late AnimationController animationController;
  late AnimationController planAnimationController;
  late Animation<double> scaleAnimation;
  late Animation<double> planSlideAnimation;

  // Plan selection
  Plan? selectedPlan;
  final List<Plan> plans = [
    Plan(
      id: 0,
      name: 'Basic Plan',
      description:
          'Boost your business with cost-effective advertising by choosing our Basic Plan, which offers a competitive view rate of 0.11% for additional views. Save money while maximizing your reach.\n🔥MONTHES: 1',
      price: 4500,
      NoMonths: 1,
    ),
    Plan(
      id: 1,
      name: 'Growth Accelerator Plan',
      description:
          'Growth Accelerator Plan: Maximize Exposure with Indeed and Google Ads Our Growth Accelerator Plan is crafted to significantly expand your reach by leveraging both Indeed and Google Ads. This plan is designed to attract more employers and increase visibility for your ads, offering a competitive rate of 0.13% per 100 views.\n🔥MONTHES: 2',
      price: 15000,
      NoMonths: 2,
    ),
    Plan(
      id: 2,
      name: 'Omni-Channel Growth Mastery Plan',
      description:
          'Omni-Channel Growth Mastery Plan: Unlock the Full Potential of Multi-Platform Advertising Our Omni-Channel Growth Mastery Plan is expertly crafted to maximize your brand’s exposure across the most impactful digital advertising platforms. This comprehensive plan strategically targets key touchpoints, ensuring your message reaches the right audience through Google, YouTube, Facebook, Twitter, and other major social media channels. Managed by a team of seasoned freelancers and influencers, this plan offers a highly effective rate of 0.002% per 100 views. \n🔥MONTHES: 3',
      price: 50000,
      NoMonths: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Main animation controller
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Plan selection animation controller
    planAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Scale animation for form elements
    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    // Slide animation for plan selection
    planSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: planAnimationController, curve: Curves.easeInOut),
    );

    animationController.forward();
    planAnimationController.forward();
  }

  // Method to get media (images or videos) from the gallery
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

  // Method to initialize video controller
  Future<void> initiVideoController(File videoFile, int index) async {
    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    setState(() {
      videoControllers[index] = controller;
    });
  }

  // Method to pick media (images or videos) from the camera
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
        final byte = File(imageFile.path);
        final bytes = await byte.readAsBytes();
        setState(() {
          imageAd = base64Encode(bytes);
          mediaFiles.add(File(imageFile.path));
          video.add(false);
          videoControllers.add(null);
        });
        askToPickMore(isVideo: false);
      }
    }
  }

  // Method to ask the user if they want to pick more media
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
            ),
          ],
        );
      },
    );

    if (pickMore == true) {
      await pickMedia(ImageSource.camera, isVideo: isVideo);
    }
  }

  // Build media preview widget
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

  // Show media selection options
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

  // Show options for media selection from gallery
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

  // Show options for media selection from camera
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

  // Build media option widget
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

  // Build plan selector widget
  Widget _buildPlanSelector() {
    return AnimatedBuilder(
      animation: planAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - planSlideAnimation.value)),
          child: Opacity(
            opacity: planSlideAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...plans.map((plan) => _buildPlanCard(plan)).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build plan card widget
  Widget _buildPlanCard(Plan plan) {
    final isSelected = selectedPlan?.id == plan.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = plan;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [Colors.blue[700]!, Colors.purple[900]!]
                : [Colors.grey[900]!, Colors.grey[800]!],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[300],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${plan.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: isSelected ? Colors.green[300] : Colors.grey[400],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.description,
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateAdCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView1()),
              ),
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
                    controller: linkController,
                    label: 'Site Link (Optional)',
                    keyboardType: TextInputType.url,
                  ),
                  _buildPlanSelector(),
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
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createAd() async {
    if (formKey.currentState!.validate() && selectedPlan != null) {
      final cubit = context.read<CreateAdCubit>();
      await cubit.createAd(
        name: nameController.text,
        details: descriptionController.text,
        imageName: "1.jpeg",
        images: imageAd,
        planNum: selectedPlan!.id,
        setToPublic: false,
        link: linkController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (selectedPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a plan'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    for (final controller in videoControllers) {
      controller?.dispose();
    }
    animationController.dispose();
    planAnimationController.dispose();
    super.dispose();
  }
}
