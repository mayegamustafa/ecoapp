import 'package:flutter/material.dart';

class DiagonalCutContainer extends StatelessWidget {
  final double width;
  final double height;
  final Gradient gradient;
  final double cutSize;
  final Widget child;

  const DiagonalCutContainer({
    super.key,
    required this.width,
    required this.height,
    required this.gradient,
    required this.cutSize,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(width, height),
          painter: DiagonalCutPainter(gradient: gradient, cutSize: cutSize),
        ),
        SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      ],
    );
  }
}

class DiagonalCutPainter extends CustomPainter {
  final Gradient gradient;
  final double cutSize;

  DiagonalCutPainter({required this.gradient, required this.cutSize});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = gradient.createShader(rect);

    final path = Path()
      ..moveTo(size.width - cutSize, 0)
      ..lineTo(size.width, cutSize)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
