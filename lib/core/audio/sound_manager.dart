import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundManager {
  SoundManager._internal() {
    _isTestEnv = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
  }

  static final SoundManager instance = SoundManager._internal();

  late final bool _isTestEnv;
  final List<AudioPlayer> _sfxPool = [];
  int _nextSfxIndex = 0;
  static const int _sfxPoolSize = 4;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  Future<void> init() async {
    if (_isTestEnv) return;

    try {
      if (_sfxPool.isEmpty) {
        for (int i = 0; i < _sfxPoolSize; i++) {
          _sfxPool.add(AudioPlayer());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager init error: $e');
      }
    }
  }

  Future<void> playMenuClickSound() async {
    await _playSfx('media/menu_click.wav');
  }

  Future<void> playMatchSound() async {
    await _playSfx('media/remove_items.wav');
  }

  Future<void> playWrongPickSound() async {
    await _playSfx('media/wrong_pick.wav');
  }

  Future<void> playSuccessSound() async {
    await _playSfx('media/success_alert.wav');
  }

  Future<void> _playSfx(String assetName) async {
    if (_isMuted) return;
    if (_isTestEnv) {
      if (kDebugMode) {
        print('SoundManager [TEST SFX]: $assetName');
      }
      return;
    }

    try {
      if (_sfxPool.isEmpty) {
        for (int i = 0; i < _sfxPoolSize; i++) {
          _sfxPool.add(AudioPlayer());
        }
      }

      final player = _sfxPool[_nextSfxIndex];
      _nextSfxIndex = (_nextSfxIndex + 1) % _sfxPoolSize;

      await player.stop();
      await player.play(AssetSource(assetName));
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager _playSfx error ($assetName): $e');
      }
    }
  }

  void dispose() {
    for (final player in _sfxPool) {
      player.dispose();
    }
    _sfxPool.clear();
  }
}
