import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioRecorderHelper {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<bool> hasPermission() async {
    try {
      final status = await Permission.microphone.request();
      return status == PermissionStatus.granted;
    } catch (e) {
      debugPrint('Error checking microphone permission: $e');
      return false;
    }
  }

  Future<void> start() async {
    if (_isRecording) return;

    try {
      if (await hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final path =
            '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        final audioConfig = const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        );

        await _recorder.start(audioConfig, path: path);
        _isRecording = true;
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<String?> stop() async {
    if (!_isRecording) return null;

    try {
      final path = await _recorder.stop();
      _isRecording = false;
      return path;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _isRecording = false;
      return null;
    }
  }

  Future<void> dispose() async {
    try {
      if (_isRecording) {
        await _recorder.stop();
      }
      // Dispose the recorder
      await _recorder.dispose();
    } catch (e) {
      debugPrint('Error disposing audio recorder: $e');
    }
  }
}

// AudioPermissionHandler Class Implementation
class AudioPermissionHandler {
  static Future<bool> hasPermission() async {
    try {
      PermissionStatus microphoneStatus = await Permission.microphone.status;

      if (!microphoneStatus.isGranted) {
        microphoneStatus = await Permission.microphone.request();
      }

      if (Platform.isAndroid) {
        PermissionStatus storageStatus = await Permission.storage.status;

        if (!storageStatus.isGranted) {
          storageStatus = await Permission.storage.request();
        }

        return microphoneStatus.isGranted && storageStatus.isGranted;
      }

      return microphoneStatus.isGranted;
    } catch (e) {
      debugPrint('Error checking permissions: $e');
      return false;
    }
  }

  static Future<bool> requestPermission() async {
    try {
      PermissionStatus microphoneStatus = await Permission.microphone.request();

      if (Platform.isAndroid) {
        PermissionStatus storageStatus = await Permission.storage.request();
        return microphoneStatus.isGranted && storageStatus.isGranted;
      }

      return microphoneStatus.isGranted;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  static Future<void> openSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      debugPrint('Error opening settings: $e');
    }
  }
}
