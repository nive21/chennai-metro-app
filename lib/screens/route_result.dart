import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/metro_data.dart';
import '../models/station.dart';
import '../widgets/metro_map.dart';

class RouteResultScreen extends StatelessWidget {
  final String origin;
  final String destination;

  const RouteResultScreen({
    super.key,
    required this.origin,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final route = getRoute(origin, destination);
    final instructions = generateInstructions(route);

    final start = route.isNotEmpty ? route.first : null;
    final end = route.isNotEmpty ? route.last : null;
    MetroStation? changeover;
    for (int i = 1; i < route.length; i++) {
      if (route[i - 1].line != route[i].line) {
        changeover = route[i - 1];
        break;
      }
    }

    final int maxStations = math.max(
        allStations.where((s) => s.line == 'Green').length,
        allStations.where((s) => s.line == 'Blue').length);
    const double width = 400;
    final double height = (maxStations + 2) * 80;
    final positions = computeStationOffsets(Size(width, height), allStations);
    final transformation = _initialTransformation(Size(width, height), positions, route);
    final controller = TransformationController()..value = transformation;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Route")),
      body: route.isEmpty
          ? const Center(child: Text("No route found."))
          : Stack(
        children: [
          InteractiveViewer(
            transformationController: controller,
            minScale: 0.5,
            maxScale: 2.0,
            panEnabled: true,
            constrained: false,
            alignment: Alignment.topLeft,
            boundaryMargin: const EdgeInsets.all(100),
            child: MetroMap(route: route, allStations: allStations),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (context, controller) {
              final theme = Theme.of(context);
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (start != null) _stationTile(start),
                          if (changeover != null) _stationTile(changeover),
                          if (end != null) _stationTile(end),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Instructions:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...instructions
                          .split('\n')
                          .map((line) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('\u2022 $line'),
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _stationTile(MetroStation station) {
    return Column(
      children: [
        const Icon(Icons.location_on),
        Text(station.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Platform ${station.platform}'),
      ],
    );
  }

  Matrix4 _initialTransformation(
      Size mapSize, Map<String, Offset> positions, List<MetroStation> route) {
    if (route.isEmpty) return Matrix4.identity();
    final offsets =
    route.map((s) => positions['${s.name}-${s.line}']!).toList();
    final minX = offsets.map((o) => o.dx).reduce(math.min);
    final maxX = offsets.map((o) => o.dx).reduce(math.max);
    final minY = offsets.map((o) => o.dy).reduce(math.min);
    final maxY = offsets.map((o) => o.dy).reduce(math.max);

    const double margin = 40;
    final double routeWidth = (maxX - minX) + margin * 2;
    final double routeHeight = (maxY - minY) + margin * 2;
    final double scaleX = mapSize.width / routeWidth;
    final double scaleY = mapSize.height / routeHeight;
    final double scale = math.min(scaleX, scaleY);

    final Offset center = Offset((minX + maxX) / 2, (minY + maxY) / 2);

    return Matrix4.identity()
      ..scale(scale)
      ..translate(mapSize.width / 2 / scale - center.dx,
          mapSize.height / 2 / scale - center.dy);
  }
}