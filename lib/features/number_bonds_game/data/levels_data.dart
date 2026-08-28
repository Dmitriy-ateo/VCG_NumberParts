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

  // ── ADVANCED EQUATION CALCULATION (Randomized Target Progression) ───────────
  static const List<LevelData> advancedLevels = [
    // Level 1: Target = 27 - 20 (= 7) (8 cards)
    LevelData(
      levelNumber: 1,
      targetSum: 7,
      targetEquation: '27 - 20',
      category: LevelCategory.advanced,
      title: 'Challenge 1: 27 - 20',
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

    // Level 2: Target = 18 - 13 (= 5) (8 cards - Diamond)
    LevelData(
      levelNumber: 2,
      targetSum: 5,
      targetEquation: '18 - 13',
      category: LevelCategory.advanced,
      title: 'Challenge 2: 18 - 13',
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

    // Level 3: Target = 38 - 30 (= 8) (10 cards - Cross)
    LevelData(
      levelNumber: 3,
      targetSum: 8,
      targetEquation: '38 - 30',
      category: LevelCategory.advanced,
      title: 'Challenge 3: 38 - 30',
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

    // Level 4: Target = 18 - 12 (= 6) (10 cards - Hourglass)
    LevelData(
      levelNumber: 4,
      targetSum: 6,
      targetEquation: '18 - 12',
      category: LevelCategory.advanced,
      title: 'Challenge 4: 18 - 12',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        CardSlot(x: 2.8, y: 3.0, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 1),
      ],
    ),

    // Level 5: Target = 29 - 20 (= 9) (12 cards - Castle Fortress)
    LevelData(
      levelNumber: 5,
      targetSum: 9,
      targetEquation: '29 - 20',
      category: LevelCategory.advanced,
      title: 'Challenge 5: 29 - 20',
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

    // Level 6: Target = 18 - 14 (= 4) (10 cards - Stepped Pillars)
    LevelData(
      levelNumber: 6,
      targetSum: 4,
      targetEquation: '18 - 14',
      category: LevelCategory.advanced,
      title: 'Challenge 6: 18 - 14',
      showDots: true,
      slots: [
        // Pillar 1 (Top Left)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        // Pillar 2 (Mid Left)
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        // Pillar 3 (Center)
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        // Pillar 4 (Mid Right)
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        // Pillar 5 (Bottom Right)
        CardSlot(x: 2.8, y: 3.0, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 1),
      ],
    ),

    // Level 7: Target = 20 - 10 (= 10) (12 cards - Pyramid)
    LevelData(
      levelNumber: 7,
      targetSum: 10,
      targetEquation: '20 - 10',
      category: LevelCategory.advanced,
      title: 'Challenge 7: 20 - 10',
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

    // Level 8: Target = 48 - 40 (= 8) (12 cards - Double Cross)
    LevelData(
      levelNumber: 8,
      targetSum: 8,
      targetEquation: '48 - 40',
      category: LevelCategory.advanced,
      title: 'Challenge 8: 48 - 40',
      showDots: true,
      slots: [
        CardSlot(x: 0.7, y: 0.0, layer: 0),
        CardSlot(x: 0.7, y: 0.0, layer: 1),
        CardSlot(x: 2.1, y: 0.0, layer: 0),
        CardSlot(x: 2.1, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 0.7, y: 3.0, layer: 0),
        CardSlot(x: 0.7, y: 3.0, layer: 1),
        CardSlot(x: 2.1, y: 3.0, layer: 0),
        CardSlot(x: 2.1, y: 3.0, layer: 1),
      ],
    ),

    // Level 9: Target = 39 - 33 (= 6) (12 cards - Ring)
    LevelData(
      levelNumber: 9,
      targetSum: 6,
      targetEquation: '39 - 33',
      category: LevelCategory.advanced,
      title: 'Challenge 9: 39 - 33',
      showDots: true,
      slots: [
        CardSlot(x: 0.7, y: 0.0, layer: 0),
        CardSlot(x: 0.7, y: 0.0, layer: 1),
        CardSlot(x: 2.1, y: 0.0, layer: 0),
        CardSlot(x: 2.1, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        CardSlot(x: 0.7, y: 3.0, layer: 0),
        CardSlot(x: 0.7, y: 3.0, layer: 1),
        CardSlot(x: 2.1, y: 3.0, layer: 0),
        CardSlot(x: 2.1, y: 3.0, layer: 1),
      ],
    ),

    // Level 10: Target = 59 - 50 (= 9) (14 cards - Twin Towers)
    LevelData(
      levelNumber: 10,
      targetSum: 9,
      targetEquation: '59 - 50',
      category: LevelCategory.advanced,
      title: 'Challenge 10: 59 - 50',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 0.0, layer: 2),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 2),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        CardSlot(x: 2.8, y: 3.0, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 1),
      ],
    ),

    // Level 11: Target = 37 - 30 (= 7) (14 cards - Grand Cross)
    LevelData(
      levelNumber: 11,
      targetSum: 7,
      targetEquation: '37 - 30',
      category: LevelCategory.advanced,
      title: 'Challenge 11: 37 - 30',
      showDots: true,
      slots: [
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 2),
        CardSlot(x: 1.4, y: 1.5, layer: 3),
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
      ],
    ),

    // Level 12: Target = 28 - 23 (= 5) (12 cards - Checkerboard)
    LevelData(
      levelNumber: 12,
      targetSum: 5,
      targetEquation: '28 - 23',
      category: LevelCategory.advanced,
      title: 'Challenge 12: 28 - 23',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 2),
        CardSlot(x: 1.4, y: 1.5, layer: 3),
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        CardSlot(x: 2.8, y: 3.0, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 1),
      ],
    ),

    // Level 13: Target = 28 - 18 (= 10) (16 cards - Grand Temple)
    LevelData(
      levelNumber: 13,
      targetSum: 10,
      targetEquation: '28 - 18',
      category: LevelCategory.advanced,
      title: 'Challenge 13: 28 - 18',
      showDots: false,
      slots: [
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        CardSlot(x: 1.3, y: 3.0, layer: 0),
        CardSlot(x: 1.3, y: 3.0, layer: 1),
        CardSlot(x: 2.6, y: 3.0, layer: 0),
        CardSlot(x: 2.6, y: 3.0, layer: 1),
        CardSlot(x: 3.9, y: 3.0, layer: 0),
        CardSlot(x: 3.9, y: 3.0, layer: 1),
        CardSlot(x: 0.65, y: 1.5, layer: 0),
        CardSlot(x: 0.65, y: 1.5, layer: 1),
        CardSlot(x: 1.95, y: 1.5, layer: 0),
        CardSlot(x: 1.95, y: 1.5, layer: 1),
        CardSlot(x: 3.25, y: 1.5, layer: 0),
        CardSlot(x: 3.25, y: 1.5, layer: 1),
        CardSlot(x: 1.95, y: 0.0, layer: 0),
        CardSlot(x: 1.95, y: 0.0, layer: 1),
      ],
    ),

    // Level 14: Target = 39 - 31 (= 8) (14 cards - Aztec Step Pyramid)
    LevelData(
      levelNumber: 14,
      targetSum: 8,
      targetEquation: '39 - 31',
      category: LevelCategory.advanced,
      title: 'Challenge 14: 39 - 31',
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
        CardSlot(x: 1.4, y: 0.0, layer: 2),
        CardSlot(x: 1.4, y: 0.0, layer: 3),
      ],
    ),

    // Level 15: Target = 26 - 22 (= 4) (12 cards - The Fortress)
    LevelData(
      levelNumber: 15,
      targetSum: 4,
      targetEquation: '26 - 22',
      category: LevelCategory.advanced,
      title: 'Challenge 15: 26 - 22',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
      ],
    ),

    // Level 16: Target = 14 - 5 (= 9) (14 cards - Diamond Palace)
    LevelData(
      levelNumber: 16,
      targetSum: 9,
      targetEquation: '14 - 5',
      category: LevelCategory.advanced,
      title: 'Challenge 16: 14 - 5',
      showDots: true,
      slots: [
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 2),
        CardSlot(x: 1.4, y: 1.5, layer: 3),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
      ],
    ),

    // Level 17: Target = 16 - 9 (= 7) (14 cards - Triple Arch)
    LevelData(
      levelNumber: 17,
      targetSum: 7,
      targetEquation: '16 - 9',
      category: LevelCategory.advanced,
      title: 'Challenge 17: 16 - 9',
      showDots: true,
      slots: [
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 0),
      ],
    ),

    // Level 18: Target = 25 - 15 (= 10) (16 cards - Grand Pyramidion)
    LevelData(
      levelNumber: 18,
      targetSum: 10,
      targetEquation: '25 - 15',
      category: LevelCategory.advanced,
      title: 'Challenge 18: 25 - 15',
      showDots: false,
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
        CardSlot(x: 1.4, y: 0.0, layer: 2),
        CardSlot(x: 1.4, y: 0.0, layer: 3),
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 0),
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
