import 'dart:math';
import 'package:flutter/material.dart';

const Color circleColor = Color.fromARGB(255, 49, 145, 235);

class Circle extends StatefulWidget {
  final AnimationController? animationController;

  const Circle({Key? key, this.animationController}) : super(key: key);

  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.animationController ??
        AnimationController(
          duration: Duration(milliseconds: 300),
          vsync: this,
        );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CustomPaint(
              painter: CirclePainter(fraction: _controller.value),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.animationController == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final double fraction;

  CirclePainter({required this.fraction});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final Paint _circlePaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -pi / 2, pi * 2 * fraction, false, _circlePaint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
