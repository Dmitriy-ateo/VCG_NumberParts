import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/app/app.dart';
import 'package:number_parts/core/l10n/locale_controller.dart';

void main() {
  testWidgets('HeromaApp landing page smoke test', (WidgetTester tester) async {
    final localeController = LocaleController();

    await tester.pumpWidget(HeromaApp(localeController: localeController));
    // Let splash finish and transition to HomeScreen
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 700));

    // Verify app logo & widgets appear
    expect(find.byType(Image), findsWidgets);
    expect(find.text('⭐'), findsOneWidget);
  });
}
