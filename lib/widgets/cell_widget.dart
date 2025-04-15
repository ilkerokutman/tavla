import 'package:flutter/material.dart';
import 'package:tavla/triangle.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({
    super.key,
    required this.cellIndex,
    required this.cellWidth,
    required this.isUp,
    this.onTap,
  });

  final int cellIndex;
  final double cellWidth;
  final bool isUp;
  final GestureTapCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RotatedBox(
        quarterTurns: !isUp ? 0 : 2,
        child: CustomPaint(
          size: Size(cellWidth, cellWidth * 3),
          painter:
              cellIndex % 2 == 0 ? LightTrianglePainter() : TrianglePainter(),
        ),
      ),
    );
  }
}
