import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundManager {
  static final SoundManager instance = SoundManager._internal();
  SoundManager._internal();

  AudioPlayer? _matchPlayer;
  AudioPlayer? _clickPlayer;
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  Future<void> playMatchSound() async {
    if (_isMuted) return;
    try {
      _matchPlayer ??= AudioPlayer();
      await _matchPlayer!.stop();
      await _matchPlayer!.play(AssetSource('media/remove_items.wav'));
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager playMatchSound error: $e');
      }
    }
  }

  Future<void> playMenuClickSound() async {
    if (_isMuted) return;
    try {
      _clickPlayer ??= AudioPlayer();
      await _clickPlayer!.stop();
      await _clickPlayer!.play(AssetSource('media/menu_click.wav'));
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager playMenuClickSound error: $e');
      }
    }
  }

  void dispose() {
    _matchPlayer?.dispose();
    _clickPlayer?.dispose();
    _matchPlayer = null;
    _clickPlayer = null;
  }
}
