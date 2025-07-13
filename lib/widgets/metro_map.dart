import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/station.dart';

class MetroMap extends StatelessWidget {
  final List<MetroStation> route;
  final List<MetroStation> allStations;

  static const Map<String, String> layoutImages = {
    'Saidapet': 'lib/data/station_layouts/saidapet.png',
    'AG-DMS': 'lib/data/station_layouts/agdms.png',
    'Anna Nagar East': 'lib/data/station_layouts/annanagar_east.png',
    'Anna Nagar Tower': 'lib/data/station_layouts/annanagar_tower.png',
  };

  const MetroMap({super.key, required this.route, required this.allStations});

  @override
  Widget build(BuildContext context) {
    const double width = 400;
    final double height = (_maxStations + 2) * 80;

    final positions = computeStationOffsets(
        Size(width, height), allStations);
    final start = route.isNotEmpty ? route.first : null;
    final end = route.isNotEmpty ? route.last : null;
    final startOffset = start != null
        ? positions['${start.name}-${start.line}']
        : null;
    final endOffset = end != null
        ? positions['${end.name}-${end.line}']
        : null;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: MetroMapPainter(route, allStations),
          ),
          if (startOffset != null && layoutImages[start!.name] != null)
            Positioned(
              left: startOffset.dx - 25,
              top: startOffset.dy - 25,
              child: Image.asset(
                layoutImages[start.name]!,
                width: 50,
                height: 50,
              ),
            ),
          if (endOffset != null && layoutImages[end!.name] != null)
            Positioned(
              left: endOffset.dx - 25,
              top: endOffset.dy - 25,
              child: Image.asset(
                layoutImages[end.name]!,
                width: 50,
                height: 50,
              ),
            ),
        ],
      ),
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

    const double radius = 6.0;

    final positions = computeStationOffsets(size, allStations);
    final _MapTransform transform = _computeTransform(size, allStations);

    final List<MetroStation> blueStations = blueLine;
    final List<MetroStation> greenStations = greenLine;

    Path bluePath = _buildBluePath(transform);
    Path greenPath = _buildGreenPath(transform);
    canvas.drawPath(bluePath, bluePaint);
    canvas.drawPath(greenPath, greenPaint);

    final labelStyle = const TextStyle(color: Colors.black, fontSize: 12);

    void drawStation(
        MetroStation station, double x, double y, Color color, bool highlight) {
      final bool inRoute =
      route.any((r) => r.name == station.name && r.line == station.line);
      final Paint dot = Paint()
        ..color = inRoute ? color : Colors.grey
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), highlight ? radius + 2 : radius, dot);
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
            style:
            labelStyle.copyWith(color: inRoute ? Colors.black : Colors.grey)),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x + 10, y - 7));
    }

    // draw regular stations
    for (final station in blueStations) {
      final Offset pos = positions['${station.name}-${station.line}']!;
      final Color color =
      station.isInterchange ? Colors.purple : Colors.blue;
      drawStation(station, pos.dx, pos.dy, color, _isHighlight(station));
    }

    for (final station in greenStations) {
      final Offset pos = positions['${station.name}-${station.line}']!;
      final Color color =
      station.isInterchange ? Colors.purple : Colors.green;
      drawStation(station, pos.dx, pos.dy, color, _isHighlight(station));
    }
  }

  bool _isHighlight(MetroStation station) {
    if (route.isEmpty) return false;
    if (station.name == route.first.name) {
      return true;
    }
    if (station.name == route.last.name) {
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

Map<String, Offset> computeStationOffsets(
    Size size, List<MetroStation> allStations) {
  final xs = allStations.map((s) => s.x).toList();
  final ys = allStations.map((s) => s.y).toList();

  final double minX = xs.reduce(math.min);
  final double maxX = xs.reduce(math.max);
  final double minY = ys.reduce(math.min);
  final double maxY = ys.reduce(math.max);

  final double scaleX = size.width / (maxX - minX);
  final double scaleY = size.height / (maxY - minY);
  final double scale = math.min(scaleX, scaleY);

  final double offsetX = (size.width - (maxX - minX) * scale) / 2 - minX * scale;
  final double offsetY = (size.height - (maxY - minY) * scale) / 2 - minY * scale;

  final Map<String, Offset> pos = {};
  for (final s in allStations) {
    pos['${s.name}-${s.line}'] =
        Offset(s.x * scale + offsetX, s.y * scale + offsetY);
  }

  return pos;
}

class _MapTransform {
  final double scale;
  final double offsetX;
  final double offsetY;
  _MapTransform(this.scale, this.offsetX, this.offsetY);
}

_MapTransform _computeTransform(Size size, List<MetroStation> allStations) {
  final xs = allStations.map((s) => s.x).toList();
  final ys = allStations.map((s) => s.y).toList();
  final double minX = xs.reduce(math.min);
  final double maxX = xs.reduce(math.max);
  final double minY = ys.reduce(math.min);
  final double maxY = ys.reduce(math.max);

  final double scaleX = size.width / (maxX - minX);
  final double scaleY = size.height / (maxY - minY);
  final double scale = math.min(scaleX, scaleY);

  final double offsetX = (size.width - (maxX - minX) * scale) / 2 - minX * scale;
  final double offsetY = (size.height - (maxY - minY) * scale) / 2 - minY * scale;

  return _MapTransform(scale, offsetX, offsetY);
}

Path _buildBluePath(_MapTransform t) {
  final s = t.scale;
  final dx = t.offsetX;
  final dy = t.offsetY;
  return Path()
    ..moveTo(dx + 1962.35 * s, dy + 128.248 * s)
    ..lineTo(dx + 1962.35 * s, dy + 1061.33 * s)
    ..cubicTo(dx + 1962.35 * s, dy + 1083.08 * s, dx + 1944.72 * s,
        dy + 1100.71 * s, dx + 1922.97 * s, dy + 1100.71 * s)
    ..lineTo(dx + 1792.45 * s, dy + 1100.71 * s)
    ..cubicTo(dx + 1770.69 * s, dy + 1100.71 * s, dx + 1753.06 * s,
        dy + 1118.35 * s, dx + 1753.06 * s, dy + 1140.1 * s)
    ..lineTo(dx + 1753.06 * s, dy + 1293.19 * s)
    ..cubicTo(dx + 1753.06 * s, dy + 1303.63 * s, dx + 1748.92 * s,
        dy + 1313.64 * s, dx + 1741.53 * s, dy + 1321.03 * s)
    ..lineTo(dx + 572.068 * s, dy + 2490.99 * s);
}

Path _buildGreenPath(_MapTransform t) {
  final s = t.scale;
  final dx = t.offsetX;
  final dy = t.offsetY;
  return Path()
    ..moveTo(dx + 850.276 * s, dy + 2346.59 * s)
    ..lineTo(dx + 850.276 * s, dy + 1279.45 * s)
    ..cubicTo(dx + 850.276 * s, dy + 1257.7 * s, dx + 832.643 * s,
        dy + 1240.07 * s, dx + 810.892 * s, dy + 1240.07 * s)
    ..lineTo(dx + 678.857 * s, dy + 1240.07 * s)
    ..cubicTo(dx + 657.107 * s, dy + 1240.07 * s, dx + 639.474 * s,
        dy + 1222.44 * s, dx + 639.474 * s, dy + 1200.69 * s)
    ..lineTo(dx + 639.474 * s, dy + 933.082 * s)
    ..cubicTo(dx + 639.474 * s, dy + 911.331 * s, dx + 657.107 * s,
        dy + 893.698 * s, dx + 678.857 * s, dy + 893.698 * s)
    ..lineTo(dx + 1089.35 * s, dy + 893.698 * s)
    ..cubicTo(dx + 1111.1 * s, dy + 893.698 * s, dx + 1128.74 * s,
        dy + 911.331 * s, dx + 1128.74 * s, dy + 933.082 * s)
    ..lineTo(dx + 1128.74 * s, dy + 1061.33 * s)
    ..cubicTo(dx + 1128.74 * s, dy + 1083.08 * s, dx + 1146.37 * s,
        dy + 1100.71 * s, dx + 1168.12 * s, dy + 1100.71 * s)
    ..lineTo(dx + 1818.7 * s, dy + 1100.71 * s);
}