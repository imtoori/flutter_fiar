import 'package:flutter/material.dart';

class HolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.blue;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(RRect.fromLTRBR(
            -1,
            -1,
            size.width,
            size.height,
            Radius.zero,
          )),
        Path()
          ..addOval(Rect.fromCircle(
            center: Offset(size.width / 2, size.width / 2),
            radius: 20,
          ))
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
