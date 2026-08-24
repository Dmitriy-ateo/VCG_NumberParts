import 'package:flutter/foundation.dart';

@immutable
class CardNode {
  final String id;
  final int value;
  final double x;
  final double y;
  final double width;
  final double height;
  final int layer;
  final bool isBlocked;
  final bool isSelected;
  final bool isMatched;
  final bool isHinted;
  final bool isClearing;
  final bool isMismatched;

  const CardNode({
    required this.id,
    required this.value,
    required this.x,
    required this.y,
    this.width = 1.0,
    this.height = 1.2,
    required this.layer,
    this.isBlocked = false,
    this.isSelected = false,
    this.isMatched = false,
    this.isHinted = false,
    this.isClearing = false,
    this.isMismatched = false,
  });

  CardNode copyWith({
    String? id,
    int? value,
    double? x,
    double? y,
    double? width,
    double? height,
    int? layer,
    bool? isBlocked,
    bool? isSelected,
    bool? isMatched,
    bool? isHinted,
    bool? isClearing,
    bool? isMismatched,
  }) {
    return CardNode(
      id: id ?? this.id,
      value: value ?? this.value,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      layer: layer ?? this.layer,
      isBlocked: isBlocked ?? this.isBlocked,
      isSelected: isSelected ?? this.isSelected,
      isMatched: isMatched ?? this.isMatched,
      isHinted: isHinted ?? this.isHinted,
      isClearing: isClearing ?? this.isClearing,
      isMismatched: isMismatched ?? this.isMismatched,
    );
  }
}
