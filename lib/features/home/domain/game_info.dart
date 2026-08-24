import 'package:flutter/material.dart';

enum GameStatus {
  active,
  comingSoon,
}

class GameInfo {
  final String id;
  final String Function(BuildContext) getTitle;
  final String Function(BuildContext) getSubtitle;
  final String imagePath;
  final List<String Function(BuildContext)> getBadges;
  final Color accentColor;
  final Color shadowColor;
  final GameStatus status;

  const GameInfo({
    required this.id,
    required this.getTitle,
    required this.getSubtitle,
    required this.imagePath,
    required this.getBadges,
    required this.accentColor,
    required this.shadowColor,
    this.status = GameStatus.active,
  });
}
