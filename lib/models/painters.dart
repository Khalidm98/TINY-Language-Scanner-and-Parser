import 'package:flutter/material.dart';

class OpLines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()..strokeWidth = 2;
    canvas.drawLine(Offset(150, 50), Offset(50, 120), _paint);
    canvas.drawLine(Offset(150, 50), Offset(250, 120), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ReadPainter extends CustomPainter {
  final int offset;

  ReadPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    if (offset != -1) {
      Paint _paint = Paint()..strokeWidth = 2;
      canvas.drawLine(Offset(90, 50), Offset(110 + 100.0 * offset, 50), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WritePainter extends CustomPainter {
  final int offset;

  WritePainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()..strokeWidth = 2;
    canvas.drawLine(Offset(50, 80), Offset(50, 120), _paint);
    if (offset != -1) {
      canvas.drawLine(Offset(90, 50), Offset(110 + 100.0 * offset, 50), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AssignPainter extends CustomPainter {
  final int offset;

  AssignPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()..strokeWidth = 2;
    canvas.drawLine(Offset(150, 80), Offset(150, 120), _paint);
    if (offset != -1) {
      canvas.drawLine(
          Offset(190, 50), Offset(210 + 100.0 * offset, 50), _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MultiPainter extends CustomPainter {
  final int offset;
  final bool isNarrow;

  MultiPainter(this.offset, this.isNarrow);

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint()..strokeWidth = 2;
    if (isNarrow) {
      canvas.drawLine(Offset(235, 80), Offset(150, 120), _paint);
      canvas.drawLine(Offset(265, 80), Offset(350, 120), _paint);
      if (offset != -1) {
        canvas.drawLine(
          Offset(290, 50),
          Offset(410 + 100.0 * offset, 50),
          _paint,
        );
      }
    } else {
      canvas.drawLine(Offset(335, 80), Offset(150, 120), _paint);
      canvas.drawLine(Offset(365, 80), Offset(550, 120), _paint);
      if (offset != -1) {
        canvas.drawLine(
          Offset(390, 50),
          Offset(410 + 100.0 * offset, 50),
          _paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
