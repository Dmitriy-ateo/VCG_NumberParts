import '../domain/models/level_data.dart';

class LevelsData {
  static const List<LevelData> allLevels = [
    // Level 1: Introduction to 5 (6 cards, 3 stacks of 2)
    LevelData(
      levelNumber: 1,
      targetSum: 5,
      title: 'Level 1: Sum 5',
      showDots: true,
      slots: [
        // Stack 1 (Left)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        // Stack 2 (Center)
        CardSlot(x: 1.3, y: 0.0, layer: 0),
        CardSlot(x: 1.3, y: 0.0, layer: 1),
        // Stack 3 (Right)
        CardSlot(x: 2.6, y: 0.0, layer: 0),
        CardSlot(x: 2.6, y: 0.0, layer: 1),
      ],
    ),

    // Level 2: 2x2 Grid (8 cards, 4 stacks of 2)
    LevelData(
      levelNumber: 2,
      targetSum: 5,
      title: 'Level 2: Twin Pillars',
      showDots: true,
      slots: [
        // Row 1
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        // Row 2
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
      ],
    ),

    // Level 3: Diamond 6 (8 cards, 4 stacks in diamond)
    LevelData(
      levelNumber: 3,
      targetSum: 6,
      title: 'Level 3: Diamond 6',
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

    // Level 4: The Cross 7 (10 cards)
    LevelData(
      levelNumber: 4,
      targetSum: 7,
      title: 'Level 4: Cross 7',
      showDots: true,
      slots: [
        // Center 3-layer stack
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 2),
        // Top stack (2 layers)
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        // Bottom stack (2 layers)
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
        // Left (1 layer)
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        // Right stack (2 layers)
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
      ],
    ),

    // Level 5: Small Pyramid (12 cards, 6 stacks of 2)
    LevelData(
      levelNumber: 5,
      targetSum: 8,
      title: 'Level 5: Small Pyramid',
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

    // Level 6: Castle 9 (12 cards)
    LevelData(
      levelNumber: 6,
      targetSum: 9,
      title: 'Level 6: Castle 9',
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
      title: 'Level 7: The Big 10!',
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

    // Level 8: Aztec Temple 10 (16 cards, 4x2 grid of 2-stacks)
    LevelData(
      levelNumber: 8,
      targetSum: 10,
      title: 'Level 8: Aztec Temple',
      showDots: false,
      slots: [
        // Row 1 (4 stacks)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 1.3, y: 0.0, layer: 0),
        CardSlot(x: 1.3, y: 0.0, layer: 1),
        CardSlot(x: 2.6, y: 0.0, layer: 0),
        CardSlot(x: 2.6, y: 0.0, layer: 1),
        CardSlot(x: 3.9, y: 0.0, layer: 0),
        CardSlot(x: 3.9, y: 0.0, layer: 1),
        // Row 2 (4 stacks)
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 1.3, y: 1.5, layer: 0),
        CardSlot(x: 1.3, y: 1.5, layer: 1),
        CardSlot(x: 2.6, y: 1.5, layer: 0),
        CardSlot(x: 2.6, y: 1.5, layer: 1),
        CardSlot(x: 3.9, y: 1.5, layer: 0),
        CardSlot(x: 3.9, y: 1.5, layer: 1),
      ],
    ),

    // Level 9: Grand Pyramid 10 (18 cards)
    LevelData(
      levelNumber: 9,
      targetSum: 10,
      title: 'Level 9: Grand Pyramid',
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
        // Top (2 stacks = 4 cards)
        CardSlot(x: 1.3, y: 0.0, layer: 0),
        CardSlot(x: 1.3, y: 0.0, layer: 1),
        CardSlot(x: 2.6, y: 0.0, layer: 0),
        CardSlot(x: 2.6, y: 0.0, layer: 1),
      ],
    ),

    // Level 10: Butterfly 12 (18 cards)
    LevelData(
      levelNumber: 10,
      targetSum: 12,
      title: 'Level 10: Butterfly 12',
      showDots: false,
      slots: [
        // Left Wing (3 stacks = 6 cards)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 1.5, layer: 0),
        CardSlot(x: 0.0, y: 1.5, layer: 1),
        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        // Right Wing (3 stacks = 6 cards)
        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 1.5, layer: 0),
        CardSlot(x: 2.8, y: 1.5, layer: 1),
        CardSlot(x: 2.8, y: 3.0, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 1),
        // Center Body (3 stacks = 6 cards)
        CardSlot(x: 1.4, y: 0.0, layer: 0),
        CardSlot(x: 1.4, y: 0.0, layer: 1),
        CardSlot(x: 1.4, y: 1.5, layer: 0),
        CardSlot(x: 1.4, y: 1.5, layer: 1),
        CardSlot(x: 1.4, y: 3.0, layer: 0),
        CardSlot(x: 1.4, y: 3.0, layer: 1),
      ],
    ),

    // Level 11: Fortress 15 (20 cards)
    LevelData(
      levelNumber: 11,
      targetSum: 15,
      title: 'Level 11: Fortress 15',
      showDots: false,
      slots: [
        // 4 Corner Towers (3 layers each = 12 cards)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 0.0, layer: 1),
        CardSlot(x: 0.0, y: 0.0, layer: 2),

        CardSlot(x: 2.8, y: 0.0, layer: 0),
        CardSlot(x: 2.8, y: 0.0, layer: 1),
        CardSlot(x: 2.8, y: 0.0, layer: 2),

        CardSlot(x: 0.0, y: 3.0, layer: 0),
        CardSlot(x: 0.0, y: 3.0, layer: 1),
        CardSlot(x: 0.0, y: 3.0, layer: 2),

        CardSlot(x: 2.8, y: 3.0, layer: 0),
        CardSlot(x: 2.8, y: 3.0, layer: 1),
        CardSlot(x: 2.8, y: 3.0, layer: 2),

        // 4 Walls (2 layers each = 8 cards)
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

    // Level 12: Master Pyramid 20 (22 cards)
    LevelData(
      levelNumber: 12,
      targetSum: 20,
      title: 'Level 12: Master 20',
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

        // Mid Row (3 stacks = 6 cards)
        CardSlot(x: 0.65, y: 1.5, layer: 0),
        CardSlot(x: 0.65, y: 1.5, layer: 1),
        CardSlot(x: 1.95, y: 1.5, layer: 0),
        CardSlot(x: 1.95, y: 1.5, layer: 1),
        CardSlot(x: 3.25, y: 1.5, layer: 0),
        CardSlot(x: 3.25, y: 1.5, layer: 1),

        // Top Row (2 stacks = 4 cards)
        CardSlot(x: 1.3, y: 0.0, layer: 0),
        CardSlot(x: 1.3, y: 0.0, layer: 1),
        CardSlot(x: 2.6, y: 0.0, layer: 0),
        CardSlot(x: 2.6, y: 0.0, layer: 1),

        // Apex Center (1 4-layer stack = 4 cards)
        CardSlot(x: 1.95, y: 0.75, layer: 0),
        CardSlot(x: 1.95, y: 0.75, layer: 1),
        CardSlot(x: 1.95, y: 0.75, layer: 2),
        CardSlot(x: 1.95, y: 0.75, layer: 3),
      ],
    ),
  ];

  static LevelData getLevel(int levelNumber) {
    return allLevels.firstWhere(
      (lvl) => lvl.levelNumber == levelNumber,
      orElse: () => allLevels.first,
    );
  }
}
