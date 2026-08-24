import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/app/app.dart';
import 'package:number_parts/core/l10n/locale_controller.dart';

void main() {
  testWidgets('NumberPartsApp landing page smoke test', (WidgetTester tester) async {
    final localeController = LocaleController();

    await tester.pumpWidget(NumberPartsApp(localeController: localeController));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify app title & widgets appear
    expect(find.text('NumberParts'), findsOneWidget);
    expect(find.text('⭐'), findsOneWidget);
  });
}
