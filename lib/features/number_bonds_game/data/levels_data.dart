import '../domain/models/level_data.dart';

class LevelsData {
  static const List<LevelData> allLevels = [
    // Level 1: Introduction to 5 (6 cards, 2 layers)
    LevelData(
      levelNumber: 1,
      targetSum: 5,
      title: 'Level 1: Sum 5',
      showDots: true,
      slots: [
        // Layer 0 (Bottom)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.35, layer: 0),
        CardSlot(x: 1.15, y: 1.35, layer: 0),
        // Layer 1 (Top)
        CardSlot(x: 0.575, y: 0.0, layer: 1),
        CardSlot(x: 0.575, y: 1.35, layer: 1),
      ],
    ),

    // Level 2: Twin Columns (8 cards, 2 layers)
    LevelData(
      levelNumber: 2,
      targetSum: 5,
      title: 'Level 2: Twin Pillars',
      showDots: true,
      slots: [
        // Layer 0
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.35, layer: 0),
        CardSlot(x: 2.3, y: 0.0, layer: 0),
        CardSlot(x: 2.3, y: 1.35, layer: 0),
        // Layer 1
        CardSlot(x: 0.0, y: 0.675, layer: 1),
        CardSlot(x: 2.3, y: 0.675, layer: 1),
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 1.15, y: 1.35, layer: 0),
      ],
    ),

    // Level 3: Diamond (8 cards, 2 layers)
    LevelData(
      levelNumber: 3,
      targetSum: 6,
      title: 'Level 3: Diamond 6',
      showDots: true,
      slots: [
        // Layer 0
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.0, layer: 0),
        CardSlot(x: 2.3, y: 1.0, layer: 0),
        CardSlot(x: 1.15, y: 2.0, layer: 0),
        // Layer 1
        CardSlot(x: 0.575, y: 0.5, layer: 1),
        CardSlot(x: 1.725, y: 0.5, layer: 1),
        CardSlot(x: 0.575, y: 1.5, layer: 1),
        CardSlot(x: 1.725, y: 1.5, layer: 1),
      ],
    ),

    // Level 4: The Cross (10 cards, 2 layers)
    LevelData(
      levelNumber: 4,
      targetSum: 7,
      title: 'Level 4: Cross 7',
      showDots: true,
      slots: [
        // Layer 0
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.2, layer: 0),
        CardSlot(x: 1.15, y: 1.2, layer: 0),
        CardSlot(x: 2.3, y: 1.2, layer: 0),
        CardSlot(x: 1.15, y: 2.4, layer: 0),
        // Layer 1
        CardSlot(x: 0.575, y: 0.6, layer: 1),
        CardSlot(x: 1.725, y: 0.6, layer: 1),
        CardSlot(x: 0.575, y: 1.8, layer: 1),
        CardSlot(x: 1.725, y: 1.8, layer: 1),
        CardSlot(x: 1.15, y: 1.2, layer: 1),
      ],
    ),

    // Level 5: Small Pyramid (12 cards, 3 layers)
    LevelData(
      levelNumber: 5,
      targetSum: 8,
      title: 'Level 5: Small Pyramid',
      showDots: true,
      slots: [
        // Layer 0 (Bottom 3x2)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 2.3, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.35, layer: 0),
        CardSlot(x: 1.15, y: 1.35, layer: 0),
        CardSlot(x: 2.3, y: 1.35, layer: 0),
        // Layer 1 (Mid)
        CardSlot(x: 0.575, y: 0.0, layer: 1),
        CardSlot(x: 1.725, y: 0.0, layer: 1),
        CardSlot(x: 0.575, y: 1.35, layer: 1),
        CardSlot(x: 1.725, y: 1.35, layer: 1),
        // Layer 2 (Peak)
        CardSlot(x: 1.15, y: 0.675, layer: 2),
        CardSlot(x: 1.15, y: 0.0, layer: 2),
      ],
    ),

    // Level 6: Castle (12 cards, 3 layers)
    LevelData(
      levelNumber: 6,
      targetSum: 9,
      title: 'Level 6: Castle 9',
      showDots: true,
      slots: [
        // Layer 0
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.35, layer: 0),
        CardSlot(x: 1.15, y: 1.35, layer: 0),
        CardSlot(x: 2.3, y: 1.35, layer: 0),
        CardSlot(x: 2.3, y: 0.0, layer: 0),
        // Layer 1
        CardSlot(x: 0.0, y: 0.675, layer: 1),
        CardSlot(x: 2.3, y: 0.675, layer: 1),
        CardSlot(x: 0.575, y: 1.35, layer: 1),
        CardSlot(x: 1.725, y: 1.35, layer: 1),
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        // Layer 2
        CardSlot(x: 1.15, y: 0.675, layer: 2),
        CardSlot(x: 1.15, y: 1.35, layer: 2),
      ],
    ),

    // Level 7: Target 10 - Milestone Pyramid (14 cards, 3 layers)
    LevelData(
      levelNumber: 7,
      targetSum: 10,
      title: 'Level 7: The Big 10!',
      showDots: true,
      slots: [
        // Layer 0
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 2.3, y: 0.0, layer: 0),
        CardSlot(x: 3.45, y: 0.0, layer: 0),
        CardSlot(x: 0.575, y: 1.35, layer: 0),
        CardSlot(x: 1.725, y: 1.35, layer: 0),
        CardSlot(x: 2.875, y: 1.35, layer: 0),
        // Layer 1
        CardSlot(x: 0.575, y: 0.0, layer: 1),
        CardSlot(x: 1.725, y: 0.0, layer: 1),
        CardSlot(x: 2.875, y: 0.0, layer: 1),
        CardSlot(x: 1.15, y: 1.35, layer: 1),
        CardSlot(x: 2.3, y: 1.35, layer: 1),
        // Layer 2
        CardSlot(x: 1.15, y: 0.675, layer: 2),
        CardSlot(x: 2.3, y: 0.675, layer: 2),
      ],
    ),

    // Level 8: Aztec Temple (16 cards, 3 layers)
    LevelData(
      levelNumber: 8,
      targetSum: 10,
      title: 'Level 8: Aztec Temple',
      showDots: false,
      slots: [
        // Layer 0
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 2.3, y: 0.0, layer: 0),
        CardSlot(x: 3.45, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.35, layer: 0),
        CardSlot(x: 1.15, y: 1.35, layer: 0),
        CardSlot(x: 2.3, y: 1.35, layer: 0),
        CardSlot(x: 3.45, y: 1.35, layer: 0),
        // Layer 1
        CardSlot(x: 0.575, y: 0.0, layer: 1),
        CardSlot(x: 1.725, y: 0.0, layer: 1),
        CardSlot(x: 2.875, y: 0.0, layer: 1),
        CardSlot(x: 0.575, y: 1.35, layer: 1),
        CardSlot(x: 1.725, y: 1.35, layer: 1),
        CardSlot(x: 2.875, y: 1.35, layer: 1),
        // Layer 2
        CardSlot(x: 1.15, y: 0.675, layer: 2),
        CardSlot(x: 2.3, y: 0.675, layer: 2),
      ],
    ),

    // Level 9: Grand Pyramid (18 cards, 3 layers)
    LevelData(
      levelNumber: 9,
      targetSum: 10,
      title: 'Level 9: Grand Pyramid',
      showDots: false,
      slots: [
        // Layer 0 (Row 1, 2, 3)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 2.3, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.35, layer: 0),
        CardSlot(x: 1.15, y: 1.35, layer: 0),
        CardSlot(x: 2.3, y: 1.35, layer: 0),
        CardSlot(x: 0.0, y: 2.7, layer: 0),
        CardSlot(x: 1.15, y: 2.7, layer: 0),
        CardSlot(x: 2.3, y: 2.7, layer: 0),
        // Layer 1
        CardSlot(x: 0.575, y: 0.675, layer: 1),
        CardSlot(x: 1.725, y: 0.675, layer: 1),
        CardSlot(x: 0.575, y: 2.025, layer: 1),
        CardSlot(x: 1.725, y: 2.025, layer: 1),
        CardSlot(x: 0.575, y: 0.0, layer: 1),
        CardSlot(x: 1.725, y: 0.0, layer: 1),
        // Layer 2
        CardSlot(x: 1.15, y: 0.675, layer: 2),
        CardSlot(x: 1.15, y: 1.35, layer: 2),
        CardSlot(x: 1.15, y: 2.025, layer: 2),
      ],
    ),

    // Level 10: Butterfly (18 cards, 3 layers, Target 12)
    LevelData(
      levelNumber: 10,
      targetSum: 12,
      title: 'Level 10: Butterfly 12',
      showDots: false,
      slots: [
        // Left Wing (Layer 0)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.35, layer: 0),
        CardSlot(x: 0.0, y: 2.7, layer: 0),
        CardSlot(x: 1.1, y: 0.675, layer: 0),
        CardSlot(x: 1.1, y: 2.025, layer: 0),
        // Right Wing (Layer 0)
        CardSlot(x: 3.3, y: 0.0, layer: 0),
        CardSlot(x: 3.3, y: 1.35, layer: 0),
        CardSlot(x: 3.3, y: 2.7, layer: 0),
        CardSlot(x: 2.2, y: 0.675, layer: 0),
        CardSlot(x: 2.2, y: 2.025, layer: 0),
        // Center Body (Layer 1)
        CardSlot(x: 1.65, y: 0.0, layer: 1),
        CardSlot(x: 1.65, y: 1.35, layer: 1),
        CardSlot(x: 1.65, y: 2.7, layer: 1),
        // Overlay Wings (Layer 1)
        CardSlot(x: 0.55, y: 0.675, layer: 1),
        CardSlot(x: 0.55, y: 2.025, layer: 1),
        CardSlot(x: 2.75, y: 0.675, layer: 1),
        CardSlot(x: 2.75, y: 2.025, layer: 1),
        // Center Crown (Layer 2)
        CardSlot(x: 1.65, y: 0.675, layer: 2),
      ],
    ),

    // Level 11: Fortress (20 cards, 4 layers, Target 15)
    LevelData(
      levelNumber: 11,
      targetSum: 15,
      title: 'Level 11: Fortress 15',
      showDots: false,
      slots: [
        // Layer 0 (4x3 Base)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 2.3, y: 0.0, layer: 0),
        CardSlot(x: 3.45, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.35, layer: 0),
        CardSlot(x: 3.45, y: 1.35, layer: 0),
        CardSlot(x: 0.0, y: 2.7, layer: 0),
        CardSlot(x: 1.15, y: 2.7, layer: 0),
        CardSlot(x: 2.3, y: 2.7, layer: 0),
        CardSlot(x: 3.45, y: 2.7, layer: 0),
        // Layer 1
        CardSlot(x: 0.575, y: 0.0, layer: 1),
        CardSlot(x: 2.875, y: 0.0, layer: 1),
        CardSlot(x: 0.575, y: 2.7, layer: 1),
        CardSlot(x: 2.875, y: 2.7, layer: 1),
        CardSlot(x: 1.15, y: 1.35, layer: 1),
        CardSlot(x: 2.3, y: 1.35, layer: 1),
        // Layer 2
        CardSlot(x: 1.725, y: 0.675, layer: 2),
        CardSlot(x: 1.725, y: 2.025, layer: 2),
        // Layer 3 (Towers)
        CardSlot(x: 0.0, y: 0.675, layer: 3),
        CardSlot(x: 3.45, y: 0.675, layer: 3),
      ],
    ),

    // Level 12: Master Pyramid (22 cards, 4 layers, Target 20)
    LevelData(
      levelNumber: 12,
      targetSum: 20,
      title: 'Level 12: Master 20',
      showDots: false,
      slots: [
        // Layer 0 (Base 4x3)
        CardSlot(x: 0.0, y: 0.0, layer: 0),
        CardSlot(x: 1.15, y: 0.0, layer: 0),
        CardSlot(x: 2.3, y: 0.0, layer: 0),
        CardSlot(x: 3.45, y: 0.0, layer: 0),
        CardSlot(x: 0.0, y: 1.35, layer: 0),
        CardSlot(x: 1.15, y: 1.35, layer: 0),
        CardSlot(x: 2.3, y: 1.35, layer: 0),
        CardSlot(x: 3.45, y: 1.35, layer: 0),
        CardSlot(x: 0.0, y: 2.7, layer: 0),
        CardSlot(x: 1.15, y: 2.7, layer: 0),
        CardSlot(x: 2.3, y: 2.7, layer: 0),
        CardSlot(x: 3.45, y: 2.7, layer: 0),
        // Layer 1
        CardSlot(x: 0.575, y: 0.675, layer: 1),
        CardSlot(x: 1.725, y: 0.675, layer: 1),
        CardSlot(x: 2.875, y: 0.675, layer: 1),
        CardSlot(x: 0.575, y: 2.025, layer: 1),
        CardSlot(x: 1.725, y: 2.025, layer: 1),
        CardSlot(x: 2.875, y: 2.025, layer: 1),
        // Layer 2
        CardSlot(x: 1.15, y: 1.35, layer: 2),
        CardSlot(x: 2.3, y: 1.35, layer: 2),
        // Layer 3 (Peak)
        CardSlot(x: 1.725, y: 1.0, layer: 3),
        CardSlot(x: 1.725, y: 1.7, layer: 3),
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
