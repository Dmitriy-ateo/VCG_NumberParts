import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/core/storage/progress_repository.dart';
import 'package:number_parts/features/fox_miner_game/domain/logic/miner_levels_catalog.dart';
import 'package:number_parts/features/fox_miner_game/domain/models/miner_game_state.dart';
import 'package:number_parts/features/fox_miner_game/domain/models/miner_level_data.dart';
import 'package:number_parts/features/fox_miner_game/presentation/controllers/fox_miner_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:number_parts/core/audio/sound_manager.dart';

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

  group('FoxMinerGame Logic & Controller Tests', () {
    test('Level catalog calculates tens, singles, and optimal swings accurately', () {
      final level42 = MinerLevelsCatalog.allLevels.firstWhere((l) => l.targetNumber == 42);
      expect(level42.tensCount, 4);
      expect(level42.singlesCount, 2);
      expect(level42.tensValue, 40);
      expect(level42.optimalSwings, 6);

      final level14 = MinerLevelsCatalog.getLevel(1);
      expect(level14.targetNumber, 14);
      expect(level14.tensCount, 1);
      expect(level14.singlesCount, 4);
      expect(level14.optimalSwings, 5);

      final level50 = MinerLevelsCatalog.allLevels.firstWhere((l) => l.targetNumber == 50);
      expect(level50.tensCount, 5);
      expect(level50.singlesCount, 0);
      expect(level50.optimalSwings, 5);
    });

    test('Decomposes 42 into 40 and 2 perfectly with 3 stars', () async {
      const level = MinerLevelData(
        levelNumber: 6,
        targetNumber: 42,
        tier: MinerDifficultyTier.intermediate,
      );
      final repo = ProgressRepository();
      final controller = FoxMinerController(level: level, progressRepository: repo);

      expect(controller.remainingNumber, 42);
      expect(controller.tensCollected, 0);
      expect(controller.singlesCollected, 0);
      expect(controller.isCompleted, isFalse);

      // Mine 4 tens
      controller.mineTens();
      expect(controller.remainingNumber, 32);
      expect(controller.tensCollected, 10);
      expect(controller.lastAction, LastActionType.minedTens);

      controller.mineTens();
      controller.mineTens();
      controller.mineTens();
      expect(controller.remainingNumber, 2);
      expect(controller.tensCollected, 40);
      expect(controller.totalSwings, 4);

      // Mine 2 singles
      controller.mineSingles();
      expect(controller.remainingNumber, 1);
      expect(controller.singlesCollected, 1);
      expect(controller.lastAction, LastActionType.minedSingles);

      controller.mineSingles();
      expect(controller.remainingNumber, 0);
      expect(controller.singlesCollected, 2);
      expect(controller.isCompleted, isTrue);
      expect(controller.totalSwings, 6);
      expect(controller.missedSwings, 0);
      expect(controller.starsEarned, 3);
    });

    test('Detects missed clicks when remaining < 10 and maintains non-negative crystal value', () async {
      const level = MinerLevelData(
        levelNumber: 2,
        targetNumber: 23,
        tier: MinerDifficultyTier.beginner,
      );
      final repo = ProgressRepository();
      final controller = FoxMinerController(level: level, progressRepository: repo);

      // Mine 2 tens
      controller.mineTens();
      controller.mineTens();
      expect(controller.remainingNumber, 3);

      // Attempt to mine 10 when only 3 remains -> should register as missed click
      controller.mineTens();
      expect(controller.remainingNumber, 3, reason: 'Remaining number must not go negative');
      expect(controller.missedSwings, 1);
      expect(controller.lastAction, LastActionType.missedTens);

      // Mine remaining 3 singles
      controller.mineSingles();
      controller.mineSingles();
      controller.mineSingles();
      expect(controller.remainingNumber, 0);
      expect(controller.isCompleted, isTrue);
      expect(controller.totalSwings, 6);
      expect(controller.missedSwings, 1);
      expect(controller.starsEarned, 2, reason: '1 miss yields 2 stars');
    });

    test('Round tens with zero singles (e.g. 30 = 30 + 0) complete directly when tens are mined', () async {
      const level = MinerLevelData(
        levelNumber: 13,
        targetNumber: 30,
        tier: MinerDifficultyTier.master,
      );
      final repo = ProgressRepository();
      final controller = FoxMinerController(level: level, progressRepository: repo);

      controller.mineTens();
      controller.mineTens();
      controller.mineTens();

      expect(controller.remainingNumber, 0);
      expect(controller.tensCollected, 30);
      expect(controller.singlesCollected, 0);
      expect(controller.isCompleted, isTrue);
      expect(controller.starsEarned, 3);
    });

    test('Reset level restores initial state', () async {
      const level = MinerLevelData(
        levelNumber: 1,
        targetNumber: 14,
        tier: MinerDifficultyTier.beginner,
      );
      final repo = ProgressRepository();
      final controller = FoxMinerController(level: level, progressRepository: repo);

      controller.mineTens();
      controller.mineSingles();
      expect(controller.remainingNumber, 3);

      controller.resetLevel();
      expect(controller.remainingNumber, 14);
      expect(controller.tensCollected, 0);
      expect(controller.singlesCollected, 0);
      expect(controller.totalSwings, 0);
      expect(controller.isCompleted, isFalse);
    });

    test('Kid Fox cannot mine more than 10 singles; must hand over 10 to Mom cart before continuing', () async {
      const level = MinerLevelData(
        levelNumber: 1,
        targetNumber: 25,
        tier: MinerDifficultyTier.beginner,
      );
      final repo = ProgressRepository();
      final controller = FoxMinerController(level: level, progressRepository: repo);

      // Mine 10 singles with Kid Fox
      for (int i = 0; i < 10; i++) {
        expect(controller.canMineSingles, isTrue);
        controller.mineSingles();
      }

      expect(controller.singlesCollected, 10);
      expect(controller.remainingNumber, 15);
      expect(controller.isKidFull, isTrue);
      expect(controller.canHandoverTen, isTrue);
      expect(controller.canMineSingles, isFalse);

      // 11th single attempt is blocked
      controller.mineSingles();
      expect(controller.singlesCollected, 10, reason: 'Kid cart must not exceed 10');
      expect(controller.remainingNumber, 15, reason: 'Crystal must not decrement when kid is full');

      // Handover 10 to Mom cart
      controller.handoverTen();
      expect(controller.tensCollected, 10);
      expect(controller.singlesCollected, 0);
      expect(controller.remainingNumber, 15);
      expect(controller.isKidFull, isFalse);
      expect(controller.canHandoverTen, isFalse);
      expect(controller.canMineSingles, isTrue);
      expect(controller.lastAction, LastActionType.handedOverTen);

      // Now Kid can continue mining
      controller.mineSingles();
      expect(controller.singlesCollected, 1);
      expect(controller.remainingNumber, 14);
    });

    test('When remaining reaches 0 on the 10th single, level does not complete until 10 is handed to Mom', () async {
      const level = MinerLevelData(
        levelNumber: 1,
        targetNumber: 10,
        tier: MinerDifficultyTier.beginner,
      );
      final repo = ProgressRepository();
      final controller = FoxMinerController(level: level, progressRepository: repo);

      // Mine 10 singles to break crystal
      for (int i = 0; i < 10; i++) {
        controller.mineSingles();
      }

      expect(controller.remainingNumber, 0);
      expect(controller.singlesCollected, 10);
      expect(controller.isKidFull, isTrue);
      expect(controller.canHandoverTen, isTrue);
      expect(controller.isCompleted, isFalse, reason: 'Level must not complete while kid holds 10 singles');

      // Hand over 10 to Mom cart
      controller.handoverTen();
      expect(controller.tensCollected, 10);
      expect(controller.singlesCollected, 0);
      expect(controller.isCompleted, isTrue, reason: 'Level completes after handing 10 to Mom');
      expect(controller.starsEarned, 1, reason: 'Took 10 swings for optimal 1 swing, so 1 star earned');
    });

    test('Tapping Mom Fox when Kid has 10 singles performs handover', () async {
      const level = MinerLevelData(
        levelNumber: 1,
        targetNumber: 20,
        tier: MinerDifficultyTier.beginner,
      );
      final repo = ProgressRepository();
      final controller = FoxMinerController(level: level, progressRepository: repo);

      for (int i = 0; i < 10; i++) {
        controller.mineSingles();
      }
      expect(controller.singlesCollected, 10);
      expect(controller.tensCollected, 0);

      // Tapping Mom Fox when kid has 10
      controller.mineTens();
      expect(controller.tensCollected, 10);
      expect(controller.singlesCollected, 0);
      expect(controller.lastAction, LastActionType.handedOverTen);
    });

    test('3 stars awarded ONLY for optimal swings (10/10), 46 hits yields 1 star', () async {
      const level = MinerLevelData(
        levelNumber: 8,
        targetNumber: 64,
        tier: MinerDifficultyTier.intermediate,
      );
      expect(level.optimalSwings, 10); // 6 tens + 4 ones

      // Case 1: Perfect 10/10 hits -> 3 stars
      final repo = ProgressRepository();
      final controllerPerfect = FoxMinerController(level: level, progressRepository: repo);
      for (int i = 0; i < 6; i++) {
        controllerPerfect.mineTens();
      }
      for (int i = 0; i < 4; i++) {
        controllerPerfect.mineSingles();
      }
      expect(controllerPerfect.isCompleted, isTrue);
      expect(controllerPerfect.totalSwings, 10);
      expect(controllerPerfect.starsEarned, 3, reason: '10/10 optimal hits earns 3 stars');

      // Case 2: 11 hits (1 extra swing) -> 2 stars
      final controllerNear = FoxMinerController(level: level, progressRepository: repo);
      for (int i = 0; i < 6; i++) {
        controllerNear.mineTens();
      }
      // 1 missed ten swing when only 4 remains
      controllerNear.mineTens();
      expect(controllerNear.missedSwings, 1);
      for (int i = 0; i < 4; i++) {
        controllerNear.mineSingles();
      }
      expect(controllerNear.isCompleted, isTrue);
      expect(controllerNear.totalSwings, 11);
      expect(controllerNear.starsEarned, 2, reason: '11/10 hits (1 extra swing) earns 2 stars');

      // Case 3: 46 hits (like mining 40 ones + handovers + tens) -> 1 star
      final controllerMany = FoxMinerController(level: level, progressRepository: repo);
      // Mine 40 ones (4 batches of 10 with handovers = 40 swings)
      for (int batch = 0; batch < 4; batch++) {
        for (int i = 0; i < 10; i++) {
          controllerMany.mineSingles();
        }
        controllerMany.handoverTen();
      }
      // Remaining is 24. Mine 2 tens (2 swings) -> remaining 4
      controllerMany.mineTens();
      controllerMany.mineTens();
      // Mine 4 ones (4 swings) -> remaining 0. Total swings = 40 + 2 + 4 = 46 swings!
      for (int i = 0; i < 4; i++) {
        controllerMany.mineSingles();
      }
      expect(controllerMany.isCompleted, isTrue);
      expect(controllerMany.totalSwings, 46);
      expect(controllerMany.starsEarned, 1, reason: '46 hits out of 10 must NOT get 3 stars; yields 1 star');
    });
  });
}
