import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioRecorderHelper {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<bool> hasPermission() async {
    return await AudioPermissionHandler.hasPermission();
  }

  Future<void> start() async {
    if (!_isRecording) {
      try {
        final directory = await getTemporaryDirectory();
        final filePath =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );
        _isRecording = true;
      } catch (e) {
        print('Error starting recording: $e');
        rethrow;
      }
    }
  }

  Future<String?> stop() async {
    if (_isRecording) {
      try {
        final path = await _audioRecorder.stop();
        _isRecording = false;
        return path;
      } catch (e) {
        print('Error stopping recording: $e');
        _isRecording = false;
        return null;
      }
    }
    return null;
  }

  Future<void> dispose() async {
    if (_isRecording) {
      try {
        await _audioRecorder.stop();
      } catch (e) {
        print('Error stopping recording during dispose: $e');
      }
    }
    _isRecording = false;
    await _audioRecorder.dispose();
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
      print('Error checking permissions: $e');
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
      print('Error requesting permissions: $e');
      return false;
    }
  }

  static Future<bool> isPermanentlyDenied() async {
    try {
      bool microphoneDenied = await Permission.microphone.isPermanentlyDenied;

      if (Platform.isAndroid) {
        bool storageDenied = await Permission.storage.isPermanentlyDenied;
        return microphoneDenied || storageDenied;
      }

      return microphoneDenied;
    } catch (e) {
      print('Error checking permanent denial: $e');
      return false;
    }
  }

  static Future<void> openSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('Error opening settings: $e');
    }
  }
}