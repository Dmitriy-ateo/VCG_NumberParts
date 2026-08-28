import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundManager {
  SoundManager._internal();

  static final SoundManager instance = SoundManager._internal();

  final List<AudioPlayer> _sfxPool = [];
  int _nextSfxIndex = 0;
  static const int _sfxPoolSize = 4;

  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _isInGameSession = false;

  final ValueNotifier<bool> isMusicEnabled = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isSfxEnabled = ValueNotifier<bool>(true);

  static const String _prefMusicKey = 'heroma_music_enabled';
  static const String _prefSfxKey = 'heroma_sfx_enabled';

  bool get isMuted => !isSfxEnabled.value;

  void toggleMute() {
    toggleSfx();
  }

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isMusicEnabled.value = prefs.getBool(_prefMusicKey) ?? true;
      isSfxEnabled.value = prefs.getBool(_prefSfxKey) ?? true;
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager init error: $e');
      }
    }
  }

  Future<void> toggleMusic() async {
    final nextState = !isMusicEnabled.value;
    isMusicEnabled.value = nextState;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefMusicKey, nextState);
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager save music pref error: $e');
      }
    }

    if (nextState) {
      if (_isInGameSession) {
        await startBackgroundMusic();
      }
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> toggleSfx() async {
    final nextState = !isSfxEnabled.value;
    isSfxEnabled.value = nextState;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefSfxKey, nextState);
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager save sfx pref error: $e');
      }
    }
  }

  Future<void> startBackgroundMusic() async {
    _isInGameSession = true;
    if (!isMusicEnabled.value) return;

    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.40); // Soft, pleasant ambient background volume
      await _musicPlayer.stop();
      await _musicPlayer.play(AssetSource('media/background_game.wav'));
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager startBackgroundMusic error: $e');
      }
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager stopBackgroundMusic error: $e');
      }
    }
  }

  void leaveGameSession() {
    _isInGameSession = false;
    stopBackgroundMusic();
  }

  Future<void> playMenuClickSound() async {
    await _playSfx('media/menu_click.wav');
  }

  Future<void> playSwitchScreensSound() async {
    await _playSfx('media/switch_screens.wav');
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

  Future<void> playLoseSound() async {
    await _playSfx('media/lose_alert.wav');
  }

  Future<void> playDoorOpenSound() async {
    await _playSfx('media/door_open.wav');
  }

  Future<void> playDoorWrongSound() async {
    await _playSfx('media/door_wrong.wav');
  }

  Future<void> playTrampolineJumpSound() async {
    await _playSfx('media/trampoline_jump.wav');
  }

  Future<void> playTrampolineCrashSound() async {
    await _playSfx('media/trampoline_crash.wav');
  }

  Future<void> _playSfx(String assetName) async {
    if (!isSfxEnabled.value) return;

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
    _musicPlayer.dispose();
    for (final player in _sfxPool) {
      player.dispose();
    }
    _sfxPool.clear();
  }
}
