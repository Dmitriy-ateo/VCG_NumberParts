import 'package:flutter/material.dart';

enum GameStatus {
  active,
  comingSoon,
}

class GameBadge {
  final String icon;
  final String Function(BuildContext) getLabel;
  final Color bgColor;
  final Color borderColor;

  const GameBadge({
    required this.icon,
    required this.getLabel,
    required this.bgColor,
    required this.borderColor,
  });
}

class GameInfo {
  final String id;
  final String Function(BuildContext) getTitle;
  final String Function(BuildContext) getSubtitle;
  final String imagePath;
  final List<GameBadge> badges;
  final Color accentColor;
  final Color shadowColor;
  final GameStatus status;

  const GameInfo({
    required this.id,
    required this.getTitle,
    required this.getSubtitle,
    required this.imagePath,
    required this.badges,
    required this.accentColor,
    required this.shadowColor,
    this.status = GameStatus.active,
  });
}
