import 'package:flutter/material.dart';
import 'route_result.dart';
import '../data/metro_data.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? origin;
  String? destination;

  final List<String> stations =  allStations.map((s) => s.name).toSet().toList()..sort();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chennai Metro')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: origin,
            hint: const Text('Select Origin'),
            items: stations.map((station) {
              return DropdownMenuItem(value: station, child: Text(station));
            }).toList(),
            onChanged: (val) {
              setState(() {
                origin = val;
              });
            },
          ),
          DropdownButton<String>(
            value: destination,
            hint: const Text('Select Destination'),
            items: stations.map((station) {
              return DropdownMenuItem(value: station, child: Text(station));
            }).toList(),
            onChanged: (val) {
              setState(() {
                destination = val;
              });
            },
          ),
          ElevatedButton(
            onPressed: (origin != null && destination != null)
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteResultScreen(
                    origin: origin!,
                    destination: destination!,
                  ),
                ),
              );
            }
                : null,
            child: const Text('Show Route'),
          )
        ],
      ),
    );
  }
}
