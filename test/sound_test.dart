import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Assets exist and can be loaded from rootBundle', () async {
    final clickData = await rootBundle.load('assets/media/menu_click.wav');
    expect(clickData.lengthInBytes, greaterThan(0));

    final removeData = await rootBundle.load('assets/media/remove_items.wav');
    expect(removeData.lengthInBytes, greaterThan(0));
  });
}
