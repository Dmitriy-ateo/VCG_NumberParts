import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/core/l10n/locale_controller.dart';
import 'package:number_parts/core/widgets/bouncy_button.dart';
import 'package:number_parts/core/widgets/settings_dialog.dart';
import 'package:number_parts/features/home/domain/grade_filter_controller.dart';
import 'package:number_parts/features/home/presentation/home_screen.dart';
import 'package:number_parts/features/home/presentation/widgets/game_tile_card.dart';

void main() {
  group('GradeFilterController Tests', () {
    test('Initial filter is all and matches all grades', () {
      final controller = GradeFilterController();
      expect(controller.selectedFilter, GradeFilterOption.all);
      expect(controller.matchesGrade(minGrade: 0, maxGrade: 1), isTrue);
      expect(controller.matchesGrade(minGrade: 1, maxGrade: 2), isTrue);
    });

    test('Filter grades 0 to 1 matches only grade 0-1 games', () {
      final controller = GradeFilterController();
      controller.setFilter(GradeFilterOption.grades0to1);

      expect(controller.selectedFilter, GradeFilterOption.grades0to1);
      expect(controller.matchesGrade(minGrade: 0, maxGrade: 1), isTrue);
      expect(controller.matchesGrade(minGrade: 1, maxGrade: 2), isFalse);
    });

    test('Filter grades 1 to 2 matches only grade 1-2 games', () {
      final controller = GradeFilterController();
      controller.setFilter(GradeFilterOption.grades1to2);

      expect(controller.selectedFilter, GradeFilterOption.grades1to2);
      expect(controller.matchesGrade(minGrade: 0, maxGrade: 1), isFalse);
      expect(controller.matchesGrade(minGrade: 1, maxGrade: 2), isTrue);
    });

    test('cycleFilter cycles through options', () {
      final controller = GradeFilterController();
      expect(controller.selectedFilter, GradeFilterOption.all);

      controller.cycleFilter();
      expect(controller.selectedFilter, GradeFilterOption.grades0to1);

      controller.cycleFilter();
      expect(controller.selectedFilter, GradeFilterOption.grades1to2);

      controller.cycleFilter();
      expect(controller.selectedFilter, GradeFilterOption.all);
    });

    test('Notifies listeners on filter change', () {
      final controller = GradeFilterController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.setFilter(GradeFilterOption.grades0to1);
      expect(notifyCount, 1);

      // Same filter should not notify
      controller.setFilter(GradeFilterOption.grades0to1);
      expect(notifyCount, 1);

      controller.setFilter(GradeFilterOption.all);
      expect(notifyCount, 2);
    });
  });

  group('HomeScreen Grade Sorting & Filtering Widget Tests', () {
    testWidgets('Games are sorted with Fox Miners (Grades 0-1) first', (tester) async {
      final localeController = LocaleController();

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(localeController: localeController),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Find all GameTileCards
      final gameCards = tester.widgetList<GameTileCard>(find.byType(GameTileCard)).toList();
      expect(gameCards.length, 4);

      // Verify Fox Miners is first
      expect(gameCards[0].game.id, 'fox_miners');
      expect(gameCards[0].game.minGrade, 0);
      expect(gameCards[0].game.maxGrade, 1);

      // Remaining games have grade >= 1
      for (int i = 1; i < gameCards.length; i++) {
        expect(gameCards[i].game.minGrade, 1);
        expect(gameCards[i].game.maxGrade, 2);
      }
    });

    testWidgets('Tapping grade filter button opens dialog and filters games', (tester) async {
      final localeController = LocaleController();

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(localeController: localeController),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Find the filter button with graduation cap
      final filterBtn = find.widgetWithText(BouncyButton, '🎓');
      expect(filterBtn, findsOneWidget);

      await tester.tap(filterBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Dialog opens showing grade filter options
      expect(find.text('🎒'), findsOneWidget); // Grades 0-1 option icon
      expect(find.text('📚'), findsOneWidget); // Grades 1-2 option icon

      // Tap Grades 0-1 option
      await tester.tap(find.text('🎒'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Now only Fox Miners should be rendered
      final filteredCards = tester.widgetList<GameTileCard>(find.byType(GameTileCard)).toList();
      expect(filteredCards.length, 1);
      expect(filteredCards[0].game.id, 'fox_miners');

      // The filter button in app bar should now show active badge
      expect(find.text('0–1'), findsOneWidget);

      // Re-open filter and select All
      await tester.tap(find.widgetWithText(BouncyButton, '🎓'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('🌟'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // All 4 games should be back
      expect(find.byType(GameTileCard), findsNWidgets(4));
    });

    testWidgets('Settings dialog contains grade filter and updates home screen', (tester) async {
      final localeController = LocaleController();

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(localeController: localeController),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap Settings button
      final settingsBtn = find.byIcon(Icons.settings_rounded);
      expect(settingsBtn, findsOneWidget);
      await tester.tap(settingsBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify SettingsDialog is displayed
      expect(find.byType(SettingsDialog), findsOneWidget);

      // Select Grades 1-2 chip in settings
      final grade12Chip = find.descendant(
        of: find.byType(SettingsDialog),
        matching: find.text('Grades 1–2'),
      );
      expect(grade12Chip, findsOneWidget);
      await tester.tap(grade12Chip);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Close settings dialog
      final closeBtn = find.byIcon(Icons.close_rounded);
      await tester.tap(closeBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify only Grades 1-2 games are displayed (3 games, excluding Fox Miners)
      final activeCards = tester.widgetList<GameTileCard>(find.byType(GameTileCard)).toList();
      expect(activeCards.length, 3);
      expect(activeCards.any((c) => c.game.id == 'fox_miners'), isFalse);
    });
  });
}

