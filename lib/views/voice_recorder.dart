import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart' as record_plugin;

class VoiceRecorder {
  final record_plugin.AudioRecorder _audioRecorder =
      record_plugin.AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<bool> hasPermission() async {
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

  Future<void> startRecording() async {
    if (!_isRecording) {
      try {
        final directory = await getTemporaryDirectory();
        final filePath =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        // Check if the recorder has permission and is ready
        final hasPermissions = await _audioRecorder.hasPermission();
        if (!hasPermissions) {
          throw Exception('Microphone permission not granted');
        }

        // Configure and start the recording
        await _audioRecorder.start(
          const record_plugin.RecordConfig(
            encoder: record_plugin.AudioEncoder.aacLc,
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

  Future<String?> stopRecording() async {
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

  Future<void> cancelRecording() async {
    if (_isRecording) {
      try {
        await _audioRecorder.stop();
        _isRecording = false;
      } catch (e) {
        print('Error canceling recording: $e');
        _isRecording = false;
      }
    }
  }

  Future<void> disposeRecorder() async {
    try {
      await _audioRecorder.dispose();
    } catch (e) {
      print('Error disposing recorder: $e');
    }
  }
}
