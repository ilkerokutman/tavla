import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final int value;
  final double size;
  final bool isDisabled;

  const DiceWidget({
    super.key,
    required this.value,
    this.size = 40,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget dot() => Container(
      width: size / 5,
      height: size / 5,
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
    );
    Widget redDot() => Container(
      width: size / 3,
      height: size / 3,
      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    );

    BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black, width: size / 35),
      borderRadius: BorderRadius.circular(size / 12),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: size / 8,
          offset: Offset(0, size / 16),
        ),
      ],
    );

    late Widget widget;

    switch (value) {
      case 1:
        widget = Container(
          width: size,
          height: size,
          decoration: boxDecoration,
          child: Center(child: redDot()),
        );
      case 2:
        widget = Container(
          width: size,
          height: size,
          decoration: boxDecoration,
          padding: EdgeInsets.all(size / 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [dot(), SizedBox()],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [SizedBox(), dot()],
              ),
            ],
          ),
        );
      case 3:
        widget = Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size / 7),
          decoration: boxDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [dot()],
              ),
              Center(child: dot()),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [dot()]),
            ],
          ),
        );
      case 4:
        widget = Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size / 7),
          decoration: boxDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [dot(), dot()],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [dot(), dot()],
              ),
            ],
          ),
        );
      case 5:
        widget = Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size / 7),
          decoration: boxDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [dot(), SizedBox(), dot()],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [SizedBox(), dot(), SizedBox()],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [dot(), SizedBox(), dot()],
              ),
            ],
          ),
        );
      case 6:
        widget = Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size / 7),
          decoration: boxDecoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [dot(), dot(), dot()],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [dot(), dot(), dot()],
              ),
            ],
          ),
        );
      default:
        widget = SizedBox();
    }
    return Opacity(opacity: isDisabled ? 0.5 : 1.0, child: widget);
  }
}
