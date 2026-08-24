import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/card_node.dart';
import 'wooden_card_widget.dart';

class BoardView extends StatelessWidget {
  final List<CardNode> cards;
  final bool showDots;
  final Function(String cardId) onCardTapped;

  const BoardView({
    super.key,
    required this.cards,
    this.showDots = true,
    required this.onCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate board bounding box
        double minX = double.infinity;
        double maxX = -double.infinity;
        double minY = double.infinity;
        double maxY = -double.infinity;

        for (final card in cards) {
          minX = min(minX, card.x);
          maxX = max(maxX, card.x + card.width);
          minY = min(minY, card.y);
          maxY = max(maxY, card.y + card.height);
        }

        final boardUnitsWidth = max(maxX - minX, 1.0);
        final boardUnitsHeight = max(maxY - minY, 1.0);

        // Calculate available canvas size with safe margin
        final availableW = constraints.maxWidth - 32;
        final availableH = constraints.maxHeight - 32;

        final scaleX = availableW / (boardUnitsWidth * 80.0);
        final scaleY = availableH / (boardUnitsHeight * 95.0);
        final scale = min(scaleX, scaleY).clamp(0.6, 1.4);

        final unitW = 80.0 * scale;
        final unitH = 95.0 * scale;

        final renderedW = boardUnitsWidth * unitW;
        final renderedH = boardUnitsHeight * unitH;

        final offsetX = (constraints.maxWidth - renderedW) / 2 - (minX * unitW);
        final offsetY = (constraints.maxHeight - renderedH) / 2 - (minY * unitH);

        // Sort cards by layer so higher layers paint on top
        final sortedCards = List<CardNode>.from(cards)
          ..sort((a, b) => a.layer.compareTo(b.layer));

        return Stack(
          clipBehavior: Clip.none,
          children: sortedCards.map((card) {
            final cardPixelW = card.width * unitW;
            final cardPixelH = card.height * unitH;
            final cardLeft = offsetX + (card.x * unitW);
            final cardTop = offsetY + (card.y * unitH);

            return Positioned(
              left: cardLeft,
              top: cardTop,
              width: cardPixelW,
              height: cardPixelH,
              child: WoodenCardWidget(
                card: card,
                showDots: showDots,
                onTap: () => onCardTapped(card.id),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
