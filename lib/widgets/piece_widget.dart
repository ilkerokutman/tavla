import 'package:flutter/material.dart';

class PieceWidget extends StatelessWidget {
  const PieceWidget({
    super.key,
    required this.cellWidth,
    required this.isWhite,
  });

  final double cellWidth;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    double pieceWidth = cellWidth * 0.8;
    return IgnorePointer(
      child: SizedBox(
        width: cellWidth,
        height: cellWidth,
        child: Center(
          child: Container(
            width: pieceWidth,
            height: pieceWidth,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: pieceWidth / 8,
                  offset: Offset(0, pieceWidth / 16),
                ),
              ],
              border: Border.all(
                color: isWhite ? Colors.amber.shade700 : Colors.grey.shade400,
                width: 2,
              ),
              gradient: RadialGradient(
                center: Alignment(-0.3, -0.3),
                radius: 0.8,
                colors:
                    isWhite
                        ? [
                          Colors.white,
                          Colors.amber.shade100,
                          Colors.amber.shade400,
                        ]
                        : [Colors.brown.shade800, Colors.black87],
                stops: isWhite ? [0.6, 0.85, 1.0] : [0.6, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Glossy highlight
                Positioned(
                  top: pieceWidth * 0.11,
                  left: pieceWidth * 0.18,
                  child: Container(
                    width: pieceWidth * 0.65,
                    height: pieceWidth * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(pieceWidth * 0.14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: isWhite ? 0.45 : 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
