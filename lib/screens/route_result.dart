import 'package:flutter/material.dart';
import '../data/metro_data.dart';
import '../models/station.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text("Your Route")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: route.isEmpty
            ? const Center(child: Text("No route found."))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Route from $origin to $destination",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            // Map placeholder
            Container(
              height: 200,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: const Text("🗺️ Metro Map Here"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Instructions:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...instructions
                .split('\n')
                .map((line) => Text("• $line"))
                .toList(),
          ],
        ),
      ),
    );
  }
}