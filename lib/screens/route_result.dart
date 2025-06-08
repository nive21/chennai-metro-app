import 'package:flutter/material.dart';
import '../data/metro_data.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text("Your Route")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: route.isEmpty
            ? const Center(child: Text("No route found."))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetroMap(route: route), // <- render the 2D map
              const SizedBox(height: 24),
              const Text("Instructions:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...instructions
                  .split('\n')
                  .map((line) => Text("• $line"))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
