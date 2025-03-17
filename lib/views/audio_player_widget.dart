import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    // Setup audio player
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    try {
      if (File(widget.audioPath).existsSync()) {
        // Local file
        await _audioPlayer.setSourceDeviceFile(widget.audioPath);
      } else {
        // Assume it's a URL
        await _audioPlayer.setSourceUrl(widget.audioPath);
      }
    } catch (e) {
      print('Error setting audio source: $e');
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // Play/Pause button
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () async {
              if (_isPlaying) {
                await _audioPlayer.pause();
              } else {
                await _audioPlayer.resume();
              }

              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
          ),

          // Progress slider
          Expanded(
            child: Slider(
              value: _position.inMilliseconds.toDouble(),
              min: 0.0,
              max: _duration.inMilliseconds.toDouble() + 1.0,
              onChanged: (value) async {
                final position = Duration(milliseconds: value.toInt());
                await _audioPlayer.seek(position);

                // If the audio was paused, keep it paused
                if (!_isPlaying) {
                  await _audioPlayer.pause();
                }
              },
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
            ),
          ),

          // Duration text
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              _formatDuration(_position),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
