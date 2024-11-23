/*
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with TickerProviderStateMixin {
  CameraController? _controller;
  List<File> _capturedImages = [];
  late AnimationController _flashAnimationController;
  late Animation<double> _flashAnimation;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _flashAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _flashAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);

    try {
      // Flash animation
      _flashAnimationController
          .forward()
          .then((_) => _flashAnimationController.reverse());

      final image = await _controller!.takePicture();
      setState(() {
        _capturedImages.add(File(image.path));
      });
    } catch (e) {
      print('Error capturing image: $e');
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _flashAnimationController.dispose();
    super.dispose();
  }

  Widget _buildCapturedImagesPreview() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _capturedImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _capturedImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _capturedImages.removeAt(index);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
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
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Transform.scale(
            scale: 1.0,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
            ),
          ),

          // Flash Animation
          AnimatedBuilder(
            animation: _flashAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _flashAnimation.value,
                child: Container(
                  color: Colors.white,
                ),
              );
            },
          ),

          // Captured Images Preview
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: _buildCapturedImagesPreview(),
          ),

          // Controls
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                  GestureDetector(
                    onTap: _captureImage,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        color: _isCapturing ? Colors.grey : Colors.transparent,
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context, _capturedImages);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with TickerProviderStateMixin {
  CameraController? _controller;
  List<File> _capturedImages = [];
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  late AnimationController _flashAnimationController;
  late Animation<double> _flashAnimation;
  bool _isCapturing = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeCamera();
  }

  void _initializeControllers() {
    _flashAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _flashAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showError('No cameras found');
        return;
      }

      await _setupCamera(selectedCameraIndex);
    } catch (e) {
      _showError('Error initializing camera: $e');
    }
  }

  Future<void> _setupCamera(int index) async {
    if (cameras.isEmpty) return;

    // Dispose previous controller if exists
    await _controller?.dispose();

    _controller = CameraController(
      cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _showError('Error setting up camera: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _switchCamera() async {
    setState(() {
      _isCameraInitialized = false;
      selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    });
    await _setupCamera(selectedCameraIndex);
  }

  Future<void> _captureImage() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);

    try {
      // Flash animation
      _flashAnimationController
          .forward()
          .then((_) => _flashAnimationController.reverse());

      final XFile image = await _controller!.takePicture();

      setState(() {
        _capturedImages.add(File(image.path));
      });

      // Show success animation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image captured successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      _showError('Error capturing image: $e');
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  Widget _buildCapturedImagesPreview() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: _capturedImages.isEmpty ? 0 : 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _capturedImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                Hero(
                  tag: 'image_$index',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _capturedImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _capturedImages.removeAt(index);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCameraControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          GestureDetector(
            onTap: _captureImage,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isCapturing ? Colors.grey : Colors.white,
                  width: 4,
                ),
                color: _isCapturing
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.transparent,
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: _isCapturing ? 50 : 60,
                  height: _isCapturing ? 50 : 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isCapturing ? Colors.grey : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.switch_camera),
            color: Colors.white,
            onPressed: cameras.length > 1 ? _switchCamera : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview
            Transform.scale(
              scale: 1.0,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                ),
              ),
            ),

            // Flash Animation
            AnimatedBuilder(
              animation: _flashAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _flashAnimation.value,
                  child: Container(
                    color: Colors.white,
                  ),
                );
              },
            ),

            // Camera UI Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),

            // Captured Images Preview
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: _buildCapturedImagesPreview(),
            ),

            // Controls
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: _buildCameraControls(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _flashAnimationController.dispose();
    super.dispose();
  }
}
