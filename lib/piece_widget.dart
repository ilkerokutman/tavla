import 'package:flutter/material.dart';
import 'package:tavla/models/piece.dart';

class PieceWidget extends StatelessWidget {
  const PieceWidget({super.key, required this.size, required this.piece});
  final double size;
  final Piece piece;
  @override
  Widget build(BuildContext context) {
    // Base colors
    final baseColor =
        piece.isWhite ? Colors.brown.shade100 : Colors.brown.shade800;
    final edgeColor =
        piece.isWhite ? Colors.brown.shade300 : Colors.brown.shade900;
    final highlightColor =
        piece.isWhite ? Colors.white.withOpacity(0.9) : Colors.grey.shade300;
    final shadowColor = piece.isWhite ? Colors.black26 : Colors.black54;

    // Gloss effect
    final glossColor = Colors.white.withOpacity(0.3);

    final radialGradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: size / 62.5,
      colors: [highlightColor, baseColor],
    );

    final shadow = BoxShadow(
      color: shadowColor,
      blurRadius: size / 10,
      offset: Offset(size / 25, size / 25),
    );

    final pieceDecoration = BoxDecoration(
      shape: BoxShape.circle,
      gradient: radialGradient,
      border: Border.all(color: edgeColor, width: size / 30),
      boxShadow: [shadow],
    );

    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size / 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: pieceDecoration,
            ),
            if (piece.isHighlighted)
              Positioned(
                top: size / 6.25,
                left: size / 4.166,
                child: Container(
                  width: size * 2 / 5,
                  height: size / 5,
                  decoration: BoxDecoration(
                    color: glossColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
