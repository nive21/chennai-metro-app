import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Your Route")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text("Route from $origin to $destination",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          // Placeholder for map
          Container(
            height: 300,
            color: Colors.black12,
            alignment: Alignment.center,
            child: const Text("🗺️ Custom Metro Map Goes Here"),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("1. Enter Central Metro — Platform 2",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("• A1: Near Location A"),
                Text("• A2: Near Location B (Lift, Escalator)"),
                Text("• A3: Near Location C"),
                SizedBox(height: 12),
                Text("2. Exit Alandur — Platform 2",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("• Use Gate C1 or C2"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
