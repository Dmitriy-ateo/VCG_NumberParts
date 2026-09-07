import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/core/audio/sound_manager.dart';
import 'package:number_parts/core/l10n/app_localizations.dart';
import 'package:number_parts/features/fox_miner_game/domain/models/miner_level_data.dart';
import 'package:number_parts/features/fox_miner_game/presentation/fox_miner_game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (methodCall) async => 1,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (methodCall) async => 1,
    );
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SoundManager.instance.isSfxEnabled.value = false;
    SoundManager.instance.isMusicEnabled.value = false;
  });

  testWidgets('FoxMinerGameScreen shows handover banner at 10 singles and transfers to Mom cart',
      (WidgetTester tester) async {
    const level = MinerLevelData(
      levelNumber: 1,
      targetNumber: 25,
      tier: MinerDifficultyTier.beginner,
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [AppLocalizations.delegate],
        supportedLocales: [Locale('en')],
        home: FoxMinerGameScreen(level: level),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial targets and 0s
    expect(find.text('25'), findsWidgets);

    // Find Kid Fox button
    final kidButtonFinder = find.byKey(const ValueKey('miner_button_kid'));
    expect(kidButtonFinder, findsOneWidget);

    // Tap Kid Fox 9 times
    for (int i = 0; i < 9; i++) {
      await tester.tap(kidButtonFinder);
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();

    // Still not full (9 singles)
    expect(find.byKey(const ValueKey('handover_arrow_button')), findsNothing);

    // Tap Kid Fox 10th time -> reaches 10 singles!
    await tester.tap(kidButtonFinder);
    await tester.pump(const Duration(milliseconds: 400));

    // Now handover arrow button appears between carts
    expect(find.byKey(const ValueKey('handover_arrow_button')), findsOneWidget);
    expect(find.text('Full (10)!'), findsWidgets);

    // Tap the handover arrow button
    await tester.tap(find.byKey(const ValueKey('handover_arrow_button')));
    await tester.pump(const Duration(milliseconds: 400));

    // 10 is now transferred to Mom cart, kid has 0
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('miner_button_mom')),
        matching: find.text('10'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('miner_button_kid')),
        matching: find.text('0'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('handover_arrow_button')), findsNothing);

    // Kid Fox can now continue mining
    await tester.tap(kidButtonFinder);
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('miner_button_kid')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Tapping full Kid cart directly performs handover to Mom cart',
      (WidgetTester tester) async {
    const level = MinerLevelData(
      levelNumber: 1,
      targetNumber: 20,
      tier: MinerDifficultyTier.beginner,
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [AppLocalizations.delegate],
        supportedLocales: [Locale('en')],
        home: FoxMinerGameScreen(level: level),
      ),
    );
    await tester.pumpAndSettle();

    final kidButtonFinder = find.byKey(const ValueKey('miner_button_kid'));

    // Mine 10 singles
    for (int i = 0; i < 10; i++) {
      await tester.tap(kidButtonFinder);
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('miner_button_kid')),
        matching: find.text('10'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('miner_button_mom')),
        matching: find.text('0'),
      ),
      findsOneWidget,
    );

    // Tap Kid's cart directly
    await tester.tap(kidButtonFinder);
    await tester.pump(const Duration(milliseconds: 400));

    // Cart is handed over!
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('miner_button_mom')),
        matching: find.text('10'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('miner_button_kid')),
        matching: find.text('0'),
      ),
      findsOneWidget,
    );
  });
}
