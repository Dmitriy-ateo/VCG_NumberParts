import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Audio assets exist and are loadable from bundle', () async {
    final clickData = await rootBundle.load('assets/media/menu_click.mp3');
    expect(clickData.lengthInBytes, greaterThan(0));

    final matchData = await rootBundle.load('assets/media/remove_items.wav');
    expect(matchData.lengthInBytes, greaterThan(0));
  });
}
