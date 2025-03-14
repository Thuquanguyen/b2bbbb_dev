import 'package:flutter/widgets.dart';

class DashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final Color color;

  DashedLinePainter({
    this.dashWidth = 4,
    this.dashSpace = 5,
    this.strokeWidth = 1,
    this.color = const Color.fromRGBO(186, 205, 233, 1),
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    while (startX < (size.width - dashWidth)) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DashedBorderPainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final Color color;

  DashedBorderPainter({
    this.dashWidth = 4,
    this.dashSpace = 5,
    this.strokeWidth = 1,
    this.color = const Color.fromRGBO(186, 205, 233, 1),
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    double startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    while (startX < (size.width - dashWidth)) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      canvas.drawLine(Offset(startX, size.height),
          Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }

    canvas.drawLine(Offset(startX, 0), Offset(size.width, 0), paint);
    canvas.drawLine(
        Offset(startX, size.height), Offset(size.width, size.height), paint);

    while (startY < (size.height - dashWidth)) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      canvas.drawLine(Offset(size.width, startY),
          Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }

    canvas.drawLine(Offset(0, startY), Offset(0, size.height), paint);
    canvas.drawLine(
        Offset(size.width, startY), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
