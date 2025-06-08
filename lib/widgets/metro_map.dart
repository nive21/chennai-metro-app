import 'package:flutter/material.dart';
import '../models/station.dart';

class MetroMap extends StatelessWidget {
  final List<MetroStation> route;

  const MetroMap({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, route.length * 70),
      painter: MetroMapPainter(route),
    );
  }
}

class MetroMapPainter extends CustomPainter {
  final List<MetroStation> route;

  MetroMapPainter(this.route);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint greenPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final Paint bluePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double greenX = size.width * 0.3;
    final double blueX = size.width * 0.7;
    final double spacing = 60.0;
    final double radius = 6.0;

    // draw vertical lines first
    canvas.drawLine(
        Offset(greenX, spacing),
        Offset(greenX, spacing * (route.length + 1)),
        greenPaint);

    canvas.drawLine(
        Offset(blueX, spacing),
        Offset(blueX, spacing * (route.length + 1)),
        bluePaint);

    final labelStyle = TextStyle(color: Colors.black, fontSize: 12);

    for (int i = 0; i < route.length; i++) {
      final station = route[i];
      final double y = spacing * (i + 1);
      final double x = station.line == "Green" ? greenX : blueX;

      final isInterchange = i > 0 && route[i - 1].line != station.line;

      // draw station dot
      final Paint stationDot = Paint()
        ..color = station.line == "Green" ? Colors.green : Colors.blue
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), radius, stationDot);

      // highlight entry, exit, and interchange
      if (i == 0 || i == route.length - 1 || isInterchange) {
        final Paint highlight = Paint()
          ..color = Colors.purple
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawCircle(Offset(x, y), radius + 4, highlight);
      }

      // draw station name
      final tp = TextPainter(
        text: TextSpan(text: station.name, style: labelStyle),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x + 10, y - 7));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
