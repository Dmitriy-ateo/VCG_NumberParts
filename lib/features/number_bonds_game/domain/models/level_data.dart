import 'package:flutter/foundation.dart';

enum LevelCategory {
  classic,
  advanced,
}

@immutable
class CardSlot {
  final double x;
  final double y;
  final int layer;
  final double width;
  final double height;

  const CardSlot({
    required this.x,
    required this.y,
    required this.layer,
    this.width = 1.0,
    this.height = 1.0,
  });
}

@immutable
class LevelData {
  final int levelNumber;
  final int targetSum;
  final String? targetEquation;
  final LevelCategory category;
  final String title;
  final bool showDots;
  final List<CardSlot> slots;
  final List<int>? predefinedValues;

  const LevelData({
    required this.levelNumber,
    required this.targetSum,
    this.targetEquation,
    this.category = LevelCategory.classic,
    required this.title,
    this.showDots = true,
    required this.slots,
    this.predefinedValues,
  });

  int get totalCards => slots.length;
}
