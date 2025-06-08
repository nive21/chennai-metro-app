import 'package:flutter/material.dart';
import '../models/station.dart';

class MetroMap extends StatelessWidget {
  final List<MetroStation> route;
  final List<MetroStation> allStations;

  const MetroMap({super.key, required this.route, required this.allStations});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, _maxStations * 70),
      painter: MetroMapPainter(route, allStations),
    );
  }

  int get _maxStations {
    final green =
    allStations.where((s) => s.line == 'Green').toList();
    final blue = allStations.where((s) => s.line == 'Blue').toList();
    return green.length > blue.length ? green.length : blue.length;
  }
}

class MetroMapPainter extends CustomPainter {
  final List<MetroStation> route;
  final List<MetroStation> allStations;

  late final List<MetroStation> greenLine;
  late final List<MetroStation> blueLine;

  MetroMapPainter(this.route, this.allStations) {
    greenLine =
        allStations.where((s) => s.line == 'Green').toList();
    blueLine = allStations.where((s) => s.line == 'Blue').toList();
  }

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

    final Paint interchangePaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2;

    const double spacing = 60.0;
    const double radius = 6.0;
    final double greenX = size.width * 0.3;
    final double blueX = size.width * 0.7;

    // draw vertical lines for each route line
    canvas.drawLine(
        Offset(greenX, spacing),
        Offset(greenX, spacing * (greenLine.length + 1)),
        greenPaint);

    canvas.drawLine(
        Offset(blueX, spacing),
        Offset(blueX, spacing * (blueLine.length + 1)),
        bluePaint);

    // draw interchange connections
    for (final station in allStations.where((s) => s.isInterchange)) {
      final int gi = greenLine.indexWhere((s) => s.name == station.name);
      final int bi = blueLine.indexWhere((s) => s.name == station.name);
      if (gi >= 0 && bi >= 0) {
        final y1 = spacing * (gi + 1);
        final y2 = spacing * (bi + 1);
        canvas.drawLine(Offset(greenX, y1), Offset(blueX, y2), interchangePaint);
      }
    }

    final labelStyle = const TextStyle(color: Colors.black, fontSize: 12);

    void drawStations(List<MetroStation> lineStations, double x, Color color) {
      for (int i = 0; i < lineStations.length; i++) {
        final station = lineStations[i];
        final double y = spacing * (i + 1);

        final bool inRoute = route.any(
                (r) => r.name == station.name && r.line == station.line);
        final bool highlight = _isHighlight(station);

        final Paint dot = Paint()
          ..color = inRoute ? color : Colors.grey
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
            Offset(x, y), highlight ? radius + 2 : radius, dot);

        if (highlight) {
          final Paint hl = Paint()
            ..color = Colors.purple
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3;
          canvas.drawCircle(Offset(x, y), radius + 4, hl);
        }

        final tp = TextPainter(
          text: TextSpan(
              text: station.name,
              style: labelStyle.copyWith(
                  color: inRoute ? Colors.black : Colors.grey)),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(x + 10, y - 7));
      }
    }

    drawStations(greenLine, greenX, Colors.green);
    drawStations(blueLine, blueX, Colors.blue);
  }

  bool _isHighlight(MetroStation station) {
    if (route.isEmpty) return false;
    if (station.name == route.first.name && station.line == route.first.line) {
      return true;
    }
    if (station.name == route.last.name && station.line == route.last.line) {
      return true;
    }
    for (int i = 1; i < route.length; i++) {
      if (route[i - 1].name == station.name || route[i].name == station.name) {
        if (route[i - 1].line != route[i].line) return true;
      }
    }
    return false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}