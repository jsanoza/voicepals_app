import 'dart:math';

import 'package:flutter/material.dart';

class DottedCircleAvatar extends StatelessWidget {
  final double radius;
  final ImageProvider backgroundImage;

  const DottedCircleAvatar({
    Key? key,
    required this.radius,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedCirclePainter(),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: backgroundImage,
      ),
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final double dotRadius = 2;
    final double dotSpacing = 10;
    final double totalDots = (2 * pi * radius) / dotSpacing;

    for (int i = 0; i < totalDots; i++) {
      final double angle = (i / totalDots) * 2 * pi;
      final double x = centerX + (radius - dotRadius) * cos(angle);
      final double y = centerY + (radius - dotRadius) * sin(angle);
      final Offset dotOffset = Offset(x, y);
      canvas.drawCircle(dotOffset, dotRadius, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
