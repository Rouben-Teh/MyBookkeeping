import 'dart:math' as math;
import 'package:flutter/material.dart';

class PlaceholderLineChart extends StatelessWidget {
  const PlaceholderLineChart({
    super.key,
    required this.data,
    required this.labels,
  });

  final List<double> data;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: CustomPaint(
            painter: _LineChartPainter(data),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: labels
              .map(
                (label) => Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter(this.data);

  final List<double> data;

  @override
  void paint(Canvas canvas, Size size) {
    final padding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    final rect = Rect.fromLTWH(
      padding.left.toDouble(),
      padding.top.toDouble(),
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );

    final paintGrid = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;

    final paintLine = Paint()
      ..color = const Color(0xFFFF5A5A)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintFill = Paint()
      ..color = const Color(0xFFFF5A5A).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final maxY = data.reduce(math.max) * 1.1;
    final minY = 0.0;
    final steps = 4;

    for (int i = 0; i <= steps; i++) {
      final y = rect.top + (rect.height / steps) * i;
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), paintGrid);
    }

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = rect.left + (rect.width / (data.length - 1)) * i;
      final valueRatio = (data[i] - minY) / (maxY - minY);
      final y = rect.bottom - valueRatio * rect.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, rect.bottom);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(rect.right, rect.bottom);
    fillPath.close();
    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);

    final pointPaint = Paint()
      ..color = const Color(0xFFFF5A5A)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final x = rect.left + (rect.width / (data.length - 1)) * i;
      final valueRatio = (data[i] - minY) / (maxY - minY);
      final y = rect.bottom - valueRatio * rect.height;
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
