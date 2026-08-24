import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundManager {
  static final SoundManager instance = SoundManager._internal();
  SoundManager._internal();

  AudioPlayer? _clickPlayer;
  AudioPlayer? _matchPlayer;
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  Future<void> init() async {
    try {
      _clickPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
      _matchPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
      await _clickPlayer!.setSource(AssetSource('media/menu_click.wav'));
      await _matchPlayer!.setSource(AssetSource('media/remove_items.wav'));
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager init error: $e');
      }
    }
  }

  Future<void> playMenuClickSound() async {
    if (_isMuted) return;
    try {
      if (_clickPlayer != null) {
        await _clickPlayer!.stop();
        await _clickPlayer!.play(AssetSource('media/menu_click.wav'));
      } else {
        final player = AudioPlayer();
        await player.play(AssetSource('media/menu_click.wav'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager playMenuClickSound error: $e');
      }
    }
  }

  Future<void> playMatchSound() async {
    if (_isMuted) return;
    try {
      if (_matchPlayer != null) {
        await _matchPlayer!.stop();
        await _matchPlayer!.play(AssetSource('media/remove_items.wav'));
      } else {
        final player = AudioPlayer();
        await player.play(AssetSource('media/remove_items.wav'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager playMatchSound error: $e');
      }
    }
  }

  void dispose() {
    _clickPlayer?.dispose();
    _matchPlayer?.dispose();
    _clickPlayer = null;
    _matchPlayer = null;
  }
}
