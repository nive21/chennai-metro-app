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

    return Scaffold(
      appBar: AppBar(title: const Text("Your Route")),
      body: route.isEmpty
          ? const Center(child: Text("No route found."))
          : Stack(
        children: [
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 2.0,
            child: MetroMap(route: route, allStations: allStations),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (context, controller) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16))),
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (start != null) _stationTile(start),
                        if (changeover != null) _stationTile(changeover!),
                        if (end != null) _stationTile(end),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Instructions:",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...instructions
                        .split('\n')
                        .map((line) => Text('• $line')),
                  ],
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
}