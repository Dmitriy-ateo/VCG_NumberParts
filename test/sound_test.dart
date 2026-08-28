import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Audio assets exist and are loadable from bundle', () async {
    final clickData = await rootBundle.load('assets/media/menu_click.wav');
    expect(clickData.lengthInBytes, greaterThan(0));

    final matchData = await rootBundle.load('assets/media/remove_items.wav');
    expect(matchData.lengthInBytes, greaterThan(0));

    final wrongData = await rootBundle.load('assets/media/wrong_pick.wav');
    expect(wrongData.lengthInBytes, greaterThan(0));

    final successData = await rootBundle.load('assets/media/success_alert.wav');
    expect(successData.lengthInBytes, greaterThan(0));

    final loseData = await rootBundle.load('assets/media/lose_alert.wav');
    expect(loseData.lengthInBytes, greaterThan(0));

    final switchScreensData = await rootBundle.load('assets/media/switch_screens.wav');
    expect(switchScreensData.lengthInBytes, greaterThan(0));

    final doorOpenData = await rootBundle.load('assets/media/door_open.wav');
    expect(doorOpenData.lengthInBytes, greaterThan(0));

    final doorWrongData = await rootBundle.load('assets/media/door_wrong.wav');
    expect(doorWrongData.lengthInBytes, greaterThan(0));

    final trampolineJumpData = await rootBundle.load('assets/media/trampoline_jump.wav');
    expect(trampolineJumpData.lengthInBytes, greaterThan(0));

    final trampolineCrashData = await rootBundle.load('assets/media/trampoline_crash.wav');
    expect(trampolineCrashData.lengthInBytes, greaterThan(0));

    final backgroundMusicData = await rootBundle.load('assets/media/background_game.wav');
    expect(backgroundMusicData.lengthInBytes, greaterThan(0));

    final backgroundMenuData = await rootBundle.load('assets/media/background_menu.wav');
    expect(backgroundMenuData.lengthInBytes, greaterThan(0));
  });
}
