import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceRecorder {
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;
  bool _isRecording = false;
  Timer? _timer;
  int _recordingDuration = 0;

  final StreamController<int> _durationController = StreamController<int>.broadcast();
  Stream<int> get durationStream => _durationController.stream;

  bool get isRecording => _isRecording;
  int get recordingDuration => _recordingDuration;

  Future<void> initialize() async {
    if (await _checkPermission()) {
      final isRecordPermitted = await Permission.microphone.status.isGranted;
      print("Recording supported: $isRecordPermitted");
    }
  }

  Future<bool> _checkPermission() async {
    if (!kIsWeb) {
      final status = await Permission.microphone.request();
      return status == PermissionStatus.granted;
    }
    return true;
  }

  Future<void> startRecording() async {
    if (!_isRecording) {
      if (await _checkPermission()) {
        _recordingPath = await _getRecordingPath();

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _recordingPath!,
        );

        _isRecording = true;
        _recordingDuration = 0;
        _startTimer();
      }
    }
  }

  Future<String> _getRecordingPath() async {
    if (kIsWeb) {
      return 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    }

    final directory = await getTemporaryDirectory();
    return '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordingDuration++;
      _durationController.add(_recordingDuration);
    });
  }

  Future<String?> stopRecording() async {
    _timer?.cancel();

    if (_isRecording) {
      try {
        final path = await _audioRecorder.stop();
        _isRecording = false;
        return path; // Return the nullable path
      } catch (e) {
        print('Error stopping recording: $e');
        _isRecording = false;
        return null;
      }
    }
    return null;
  }

  Future<void> cancelRecording() async {
    _timer?.cancel();

    if (_isRecording) {
      try {
        await _audioRecorder.stop();
        _isRecording = false;

        if (_recordingPath != null && !kIsWeb) {
          final file = File(_recordingPath!);
          if (await file.exists()) {
            await file.delete();
          }
        }
      } catch (e) {
        print('Error canceling recording: $e');
        _isRecording = false;
      }
    }
  }

  void dispose() {
    _timer?.cancel();
    _durationController.close();

    if (_isRecording) {
      _audioRecorder.stop();
    }
    _audioRecorder.dispose();
  }
}