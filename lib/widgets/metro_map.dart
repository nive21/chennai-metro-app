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
    const double crossGap = 25.0;

    final positions = computeStationOffsets(size, allStations);
    final List<MetroStation> blueStations = blueLine.reversed.toList();
    final double centerX = size.width * 0.5;

    Path buildPath(List<MetroStation> stations) {
      final Path path = Path();
      for (int i = 0; i < stations.length; i++) {
        final Offset pos =
        positions['${stations[i].name}-${stations[i].line}']!;
        final double x = pos.dx;
        final double y = pos.dy;
        if (i == 0) {
          path.moveTo(x, y);
          continue;
        }
        final Offset prevPos =
        positions['${stations[i - 1].name}-${stations[i - 1].line}']!;
        final double prevX = prevPos.dx;
        final double prevY = prevPos.dy;
        final MetroStation stationPrev = stations[i - 1];
        if (stationPrev.isInterchange && prevX != x) {
          path.lineTo(prevX, prevY - crossGap);
          path.lineTo(centerX, prevY);
          path.lineTo(x, prevY + crossGap);
          path.lineTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    final Path bluePath = buildPath(blueStations);
    final Path greenPath = buildPath(greenLine);
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
    for (int i = 0; i < blueStations.length; i++) {
      final station = blueStations[i];
      if (station.isInterchange) continue;
      final Offset pos =
      positions['${station.name}-${station.line}']!;
      drawStation(
          station, pos.dx, pos.dy, Colors.blue, _isHighlight(station));
    }

    for (int i = 0; i < greenLine.length; i++) {
      final station = greenLine[i];
      if (station.isInterchange) continue;
      final Offset pos =
      positions['${station.name}-${station.line}']!;
      drawStation(
          station, pos.dx, pos.dy, Colors.green, _isHighlight(station));
    }

    // draw interchanges once in the middle
    final List<MetroStation> interchanges = [
      blueStations.firstWhere((s) => s.name.contains('Puratchi Thalaivar')),
      blueStations.firstWhere((s) => s.name.contains('Arignar Anna Alandur')),
    ];

    for (final station in interchanges) {
      final double yBlue =
          positions['${station.name}-Blue']?.dy ?? 0;
      final double yGreen =
          positions['${station.name}-Green']?.dy ?? 0;
      final double y = math.max(yBlue, yGreen);
      drawStation(station, centerX, y, Colors.purple, _isHighlight(station));
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
  const double spacing = 80.0;
  final double leftX = size.width * 0.25;
  final double rightX = size.width * 0.75;

  final List<MetroStation> greenLine =
  allStations.where((s) => s.line == 'Green').toList();
  final List<MetroStation> blueLine =
  allStations.where((s) => s.line == 'Blue').toList();
  final List<MetroStation> blueStations = blueLine.reversed.toList();

  final int blueCentral =
  blueStations.indexWhere((s) => s.name.contains('Puratchi Thalaivar'));
  final int blueAlandur =
  blueStations.indexWhere((s) => s.name.contains('Arignar Anna Alandur'));
  final int greenCentral =
  greenLine.indexWhere((s) => s.name.contains('Puratchi Thalaivar'));
  final int greenAlandur =
  greenLine.indexWhere((s) => s.name.contains('Arignar Anna Alandur'));

  final int topBlue = blueCentral;
  final int topGreen = greenCentral;
  final int betweenBlue = blueAlandur - blueCentral;
  final int betweenGreen = greenAlandur - greenCentral;
  final int bottomBlue = blueStations.length - blueAlandur - 1;
  final int bottomGreen = greenLine.length - greenAlandur - 1;

  final int topCount = math.max(topBlue, topGreen);
  final int middleCount = math.max(betweenBlue, betweenGreen);
  final int bottomCount = math.max(bottomBlue, bottomGreen);

  final double centralY = spacing * (topCount + 1);
  final double alandurY = centralY + spacing * middleCount;
  final double endY = alandurY + spacing * bottomCount;

  double stepTopBlue = topBlue == 0 ? 0 : centralY / topBlue;
  double stepTopGreen = topGreen == 0 ? 0 : centralY / topGreen;
  double stepMiddleBlue =
  betweenBlue == 0 ? 0 : (alandurY - centralY) / betweenBlue;
  double stepMiddleGreen =
  betweenGreen == 0 ? 0 : (alandurY - centralY) / betweenGreen;
  double stepBottomBlue =
  bottomBlue == 0 ? 0 : (endY - alandurY) / bottomBlue;
  double stepBottomGreen =
  bottomGreen == 0 ? 0 : (endY - alandurY) / bottomGreen;

  double yForBlue(int i) {
    if (i < blueCentral) {
      return centralY - stepTopBlue * (blueCentral - i);
    }
    if (i == blueCentral) return centralY;
    if (i <= blueAlandur) {
      return centralY + stepMiddleBlue * (i - blueCentral);
    }
    return alandurY + stepBottomBlue * (i - blueAlandur);
  }

  double yForGreen(int i) {
    if (i < greenCentral) {
      return centralY - stepTopGreen * (greenCentral - i);
    }
    if (i == greenCentral) return centralY;
    if (i <= greenAlandur) {
      return centralY + stepMiddleGreen * (i - greenCentral);
    }
    return alandurY + stepBottomGreen * (i - greenAlandur);
  }

  double xForBlue(int i) {
    if (i <= blueCentral) return leftX;
    if (i <= blueAlandur) return rightX;
    return leftX;
  }

  double xForGreen(int i) {
    if (i <= greenCentral) return rightX;
    if (i <= greenAlandur) return leftX;
    return rightX;
  }

  final Map<String, Offset> pos = {};
  for (int i = 0; i < blueStations.length; i++) {
    final s = blueStations[i];
    pos['${s.name}-${s.line}'] = Offset(xForBlue(i), yForBlue(i));
  }
  for (int i = 0; i < greenLine.length; i++) {
    final s = greenLine[i];
    pos['${s.name}-${s.line}'] = Offset(xForGreen(i), yForGreen(i));
  }

  return pos;
}