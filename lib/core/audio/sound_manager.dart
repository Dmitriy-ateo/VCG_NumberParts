import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SoundManager {
  static final SoundManager instance = SoundManager._internal();
  SoundManager._internal();

  Uint8List? _clickBytes;
  Uint8List? _matchBytes;
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  /// Preload audio bytes into memory for instant zero-latency playback across all platforms
  Future<void> init() async {
    try {
      final clickData = await rootBundle.load('assets/media/menu_click.wav');
      _clickBytes = clickData.buffer.asUint8List();

      final matchData = await rootBundle.load('assets/media/remove_items.wav');
      _matchBytes = matchData.buffer.asUint8List();
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager init error: $e');
      }
    }
  }

  Future<void> playMatchSound() async {
    if (_isMuted) return;
    try {
      final player = AudioPlayer();
      await player.setVolume(1.0);
      if (_matchBytes != null) {
        await player.play(BytesSource(_matchBytes!), mode: PlayerMode.lowLatency);
      } else {
        await player.play(AssetSource('media/remove_items.wav'), mode: PlayerMode.lowLatency);
      }
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager playMatchSound error: $e');
      }
    }
  }

  Future<void> playMenuClickSound() async {
    if (_isMuted) return;
    try {
      final player = AudioPlayer();
      await player.setVolume(1.0);
      if (_clickBytes != null) {
        await player.play(BytesSource(_clickBytes!), mode: PlayerMode.lowLatency);
      } else {
        await player.play(AssetSource('media/menu_click.wav'), mode: PlayerMode.lowLatency);
      }
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (e) {
      if (kDebugMode) {
        print('SoundManager playMenuClickSound error: $e');
      }
    }
  }
}
