import 'dart:math';

import 'package:flutter/material.dart';

class HolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;

    final center = Offset(size.height / 2, size.width / 2);

    final circleBounds = Rect.fromCircle(center: center, radius: 20);

    final topPath = Path()
      ..moveTo(-1, -1)
      ..lineTo(-1, (size.height / 2) + 1)
      ..arcTo(circleBounds, -pi, pi, false)
      ..lineTo(size.width + 1, (size.height / 2) + 1)
      ..lineTo(size.width + 1, -1)
      ..close();
    final bottomPath = Path()
      ..moveTo(-1, size.height)
      ..lineTo(-1, (size.height / 2) - 1)
      ..arcTo(circleBounds, pi, -pi, false)
      ..lineTo(size.width + 1, (size.height / 2) - 1)
      ..lineTo(size.width + 1, size.height + 1)
      ..close();

    canvas.drawPath(topPath, paint);
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
