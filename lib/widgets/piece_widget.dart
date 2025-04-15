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
    return IgnorePointer(
      child: Container(
        width: cellWidth,
        height: cellWidth,
        padding: EdgeInsets.all(cellWidth / 8),
        child: Container(
          decoration: BoxDecoration(
            color:
                isWhite
                    ? Colors.yellow.withValues(alpha: 0.8)
                    : Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(cellWidth / 2),
            border: Border.all(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
