import 'dart:math' as math;

import 'package:flutter/material.dart';

class QBGoogleIcon extends StatelessWidget {
  const QBGoogleIcon({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  static const Color _blue = Color(0xFF4285F4);
  static const Color _red = Color(0xFFEA4335);
  static const Color _yellow = Color(0xFFFBBC05);
  static const Color _green = Color(0xFF34A853);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.18;
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    paint.color = _red;
    canvas.drawArc(arcRect, math.pi * 0.90, math.pi * 0.58, false, paint);

    paint.color = _yellow;
    canvas.drawArc(arcRect, math.pi * 1.50, math.pi * 0.48, false, paint);

    paint.color = _green;
    canvas.drawArc(arcRect, math.pi * 0.00, math.pi * 0.36, false, paint);

    paint.color = _blue;
    canvas.drawArc(arcRect, math.pi * 0.36, math.pi * 0.56, false, paint);

    final barPaint = Paint()
      ..color = _blue
      ..style = PaintingStyle.fill;
    final barHeight = strokeWidth * 0.52;
    final barWidth = size.width * 0.34;
    final barLeft = center.dx + size.width * 0.01;
    final barTop = center.dy - barHeight / 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barLeft, barTop, barWidth, barHeight),
        Radius.circular(barHeight / 2),
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
