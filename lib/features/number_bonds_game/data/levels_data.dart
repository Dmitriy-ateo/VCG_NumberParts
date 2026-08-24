import '../domain/models/level_data.dart';

class LevelsData {
  // ── CLASSIC NUMBER BONDS (4 to 10) ───────────────────────────
  static const List<LevelData> classicLevels = [
    // Level 1: Bonds of 4 (6 cards, 3 stacks of 2)
    LevelData(
      levelNumber: 1,
      targetSum: 4,
      category: LevelCategory.classic,
      title: 'Target 4: Introduction',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 1.3, y: 0.0, layer: 0),
        CardSlot(x: 1.3, y: 0.0, layer: 1),
        CardSlot(x: 2.6, y: 0.0, layer: 0),
        CardSlot(x: 2.6, y: 0.0, layer: 1),
      ],
    ),

    // Level 2: Bonds of 5 (8 cards, 4 stacks of 2)
    LevelData(
      levelNumber: 2,
      targetSum: 5,
      category: LevelCategory.classic,
      title: 'Target 5: Twin Pillars',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
      ],
    ),

    // Level 3: Bonds of 6 (8 cards, Diamond shape)
    LevelData(
      levelNumber: 3,
      targetSum: 6,
      category: LevelCategory.classic,
      title: 'Target 6: Diamond',
      showDots: true,
      slots: [
        // North
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        // West
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        // East
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        // South
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
      ],
    ),

    // Level 4: Bonds of 7 (10 cards, Cross shape)
    LevelData(
      levelNumber: 4,
      targetSum: 7,
      category: LevelCategory.classic,
      title: 'Target 7: The Cross',
      showDots: true,
      slots: [
        // Center 3-layer stack
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 2),
        // Top stack
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        // Bottom stack
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
        // Left
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        // Right stack
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
      ],
    ),

    // Level 5: Bonds of 8 (12 cards, Small Pyramid)
    LevelData(
      levelNumber: 5,
      targetSum: 8,
      category: LevelCategory.classic,
      title: 'Target 8: Pyramid',
      showDots: true,
      slots: [
        // Base Row (3 stacks = 6 cards)
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
        CardSlot(x: 2.8, y: 3.0, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 1),
        // Mid Row (2 stacks = 4 cards)
        CardSlot(x: 0.7, y: 1.5, layer: 0),
        CardSlot(x: 0.7, y: 1.5, layer: 1),
        CardSlot(x: 2.1, y: 1.5, layer: 0),
        CardSlot(x: 2.1, y: 1.5, layer: 1),
        // Peak (1 stack = 2 cards)
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
      ],
    ),

    // Level 6: Bonds of 9 (12 cards, Castle shape)
    LevelData(
      levelNumber: 6,
      targetSum: 9,
      category: LevelCategory.classic,
      title: 'Target 9: Castle Fortress',
      showDots: true,
      slots: [
        // Left Tower (Top 3-stack, Bottom 2-stack)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 0.0, layer: 2),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        // Right Tower (Top 3-stack, Bottom 2-stack)
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 2),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        // Center Gate (2-stack)
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
      ],
    ),

    // Level 7: Milestone Big 10 (14 cards, 7 stacks of 2)
    LevelData(
      levelNumber: 7,
      targetSum: 10,
      category: LevelCategory.classic,
      title: 'Target 10: Grand Milestone',
      showDots: true,
      slots: [
        // Row 1 (3 stacks)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        // Row 2 (3 stacks)
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        // Row 3 (1 center stack)
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
      ],
    ),
  ];

  // ── ADVANCED EQUATION CALCULATION (e.g. 15 - 7 = 8) ───────────
  static const List<LevelData> advancedLevels = [
    // Level 1: Target = 10 - 6 (= 4)
    LevelData(
      levelNumber: 1,
      targetSum: 4,
      targetEquation: '10 - 6',
      category: LevelCategory.advanced,
      title: 'Equation: 10 - 6',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
      ],
    ),

    // Level 2: Target = 14 - 9 (= 5)
    LevelData(
      levelNumber: 2,
      targetSum: 5,
      targetEquation: '14 - 9',
      category: LevelCategory.advanced,
      title: 'Equation: 14 - 9',
      showDots: true,
      slots: [
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
      ],
    ),

    // Level 3: Target = 15 - 9 (= 6)
    LevelData(
      levelNumber: 3,
      targetSum: 6,
      targetEquation: '15 - 9',
      category: LevelCategory.advanced,
      title: 'Equation: 15 - 9',
      showDots: true,
      slots: [
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 2),
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
      ],
    ),

    // Level 4: Target = 15 - 8 (= 7)
    LevelData(
      levelNumber: 4,
      targetSum: 7,
      targetEquation: '15 - 8',
      category: LevelCategory.advanced,
      title: 'Equation: 15 - 8',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 0.0, layer: 2),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 2),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
      ],
    ),

    // Level 5: Target = 15 - 7 (= 8)
    LevelData(
      levelNumber: 5,
      targetSum: 8,
      targetEquation: '15 - 7',
      category: LevelCategory.advanced,
      title: 'Equation: 15 - 7',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
        CardSlot(x: 2.8, y: 3.0, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 1),
        CardSlot(x: 0.7, y: 1.5, layer: 0),
        CardSlot(x: 0.7, y: 1.5, layer: 1),
        CardSlot(x: 2.1, y: 1.5, layer: 0),
        CardSlot(x: 2.1, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
      ],
    ),

    // Level 6: Target = 18 - 9 (= 9)
    LevelData(
      levelNumber: 6,
      targetSum: 9,
      targetEquation: '18 - 9',
      category: LevelCategory.advanced,
      title: 'Equation: 18 - 9',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
      ],
    ),

    // Level 7: Target = 20 - 10 (= 10)
    LevelData(
      levelNumber: 7,
      targetSum: 10,
      targetEquation: '20 - 10',
      category: LevelCategory.advanced,
      title: 'Equation: 20 - 10',
      showDots: false,
      slots: [
        // Base (4 stacks = 8 cards)
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        CardSlot(x: 1.3, y: 3.0, layer: 0),
        CardSlot(x: 1.3, y: 3.0, layer: 1),
        CardSlot(x: 2.6, y: 3.0, layer: 0),
        CardSlot(x: 2.6, y: 3.0, layer: 1),
        CardSlot(x: 3.9, y: 3.0, layer: 0),
        CardSlot(x: 3.9, y: 3.0, layer: 1),
        // Mid (3 stacks = 6 cards)
        CardSlot(x: 0.65, y: 1.5, layer: 0),
        CardSlot(x: 0.65, y: 1.5, layer: 1),
        CardSlot(x: 1.95, y: 1.5, layer: 0),
        CardSlot(x: 1.95, y: 1.5, layer: 1),
        CardSlot(x: 3.25, y: 1.5, layer: 0),
        CardSlot(x: 3.25, y: 1.5, layer: 1),
        // Peak (1 stack = 2 cards)
        CardSlot(x: 1.95, y: 0.0, layer: 0),
        CardSlot(x: 1.95, y: 0.0, layer: 1),
      ],
    ),
  ];

  static List<LevelData> get allLevels => [...classicLevels, ...advancedLevels];

  static LevelData getLevel(int levelNumber, [LevelCategory category = LevelCategory.classic]) {
    final list = category == LevelCategory.classic ? classicLevels : advancedLevels;
    return list.firstWhere(
      (lvl) => lvl.levelNumber == levelNumber,
      orElse: () => list.first,
    );
  }
}
