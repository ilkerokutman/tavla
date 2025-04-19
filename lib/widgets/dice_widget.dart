import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  const DiceWidget({super.key, required this.value, this.size = 40});

  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget dot = Container(
      width: size * 0.18,
      height: size * 0.18,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
    );

    Widget child;

    switch (value) {
      case 1:
        child = Center(
          child: Container(
            width: size * 0.32,
            height: size * 0.32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        );
        break;
      case 2:
        child = Stack(
          children: [
            Align(alignment: Alignment.topLeft, child: dot),
            Align(alignment: Alignment.bottomRight, child: dot),
          ],
        );
        break;
      case 3:
        child = Stack(
          children: [
            Align(alignment: Alignment.topLeft, child: dot),
            Align(alignment: Alignment.bottomRight, child: dot),
            Center(child: dot),
          ],
        );
        break;
      case 4:
        child = Stack(
          children: [
            Align(alignment: Alignment.topLeft, child: dot),
            Align(alignment: Alignment.topRight, child: dot),
            Align(alignment: Alignment.bottomLeft, child: dot),
            Align(alignment: Alignment.bottomRight, child: dot),
          ],
        );
        break;
      case 5:
        child = Stack(
          children: [
            Align(alignment: Alignment.topLeft, child: dot),
            Align(alignment: Alignment.topRight, child: dot),
            Align(alignment: Alignment.bottomLeft, child: dot),
            Align(alignment: Alignment.bottomRight, child: dot),
            Center(child: dot),
          ],
        );
        break;
      case 6:
        child = Stack(
          children: [
            Align(alignment: Alignment.topLeft, child: dot),
            Align(alignment: Alignment.topRight, child: dot),
            Align(alignment: Alignment.bottomLeft, child: dot),
            Align(alignment: Alignment.bottomRight, child: dot),
            Align(alignment: Alignment.centerLeft, child: dot),
            Align(alignment: Alignment.centerRight, child: dot),
          ],
        );
        break;
      default:
        child = Center(child: Text(value.toString()));
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.2),
      child: child,
    );
  }
}
