import '../models/station.dart';

final List<MetroStation> allStations = [
  // Blue Line
  MetroStation(name: "Chennai International Airport", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Meenambakkam", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Nanganallur Road (OTA)", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Arignar Anna Alandur", line: "Blue", structure: "Elevated", isInterchange: true),
  MetroStation(name: "Guindy", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Little Mount", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Saidapet", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Nandanam", line: "Blue", structure: "Underground"),
  MetroStation(name: "Teynampet", line: "Blue", structure: "Underground"),
  MetroStation(name: "AG-DMS", line: "Blue", structure: "Underground"),
  MetroStation(name: "Thousand Lights", line: "Blue", structure: "Underground"),
  MetroStation(name: "LIC", line: "Blue", structure: "Underground"),
  MetroStation(name: "Government Estate", line: "Blue", structure: "Underground"),
  MetroStation(name: "Puratchi Thalaivar Dr. M.G. Ramachandran Central", line: "Blue", structure: "Underground", isInterchange: true),
  MetroStation(name: "High Court", line: "Blue", structure: "Underground"),
  MetroStation(name: "Mannadi", line: "Blue", structure: "Underground"),
  MetroStation(name: "Washermenpet", line: "Blue", structure: "Underground"),
  MetroStation(name: "Sir Thiyagaraya College", line: "Blue", structure: "Underground"),
  MetroStation(name: "Tondiarpet", line: "Blue", structure: "Underground"),
  MetroStation(name: "New Washermanpet", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Tollgate", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Kaladipet", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Thiruvottriyur Theradi", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Thiruvotriyur", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Wimco Nagar", line: "Blue", structure: "Elevated"),
  MetroStation(name: "Wimco Nagar Depot", line: "Blue", structure: "Elevated"),

  // Green Line
  MetroStation(name: "Puratchi Thalaivar Dr. M.G. Ramachandran Central", line: "Green", structure: "Underground", isInterchange: true),
  MetroStation(name: "Egmore", line: "Green", structure: "Underground"),
  MetroStation(name: "Nehru Park", line: "Green", structure: "Underground"),
  MetroStation(name: "Kilpauk Medical College", line: "Green", structure: "Underground"),
  MetroStation(name: "Pachaiyappa's College", line: "Green", structure: "Underground"),
  MetroStation(name: "Shenoy Nagar", line: "Green", structure: "Underground"),
  MetroStation(name: "Anna Nagar East", line: "Green", structure: "Underground"),
  MetroStation(name: "Anna Nagar Tower", line: "Green", structure: "Underground"),
  MetroStation(name: "Thirumangalam", line: "Green", structure: "Underground"),
  MetroStation(name: "Koyambedu", line: "Green", structure: "Elevated"),
  MetroStation(name: "CMBT (Puratchi Thalaivi Dr. J. Jayalalithaa)", line: "Green", structure: "Elevated"),
  MetroStation(name: "Arumbakkam", line: "Green", structure: "Elevated"),
  MetroStation(name: "Vadapalani", line: "Green", structure: "Elevated"),
  MetroStation(name: "Ashok Nagar", line: "Green", structure: "Elevated"),
  MetroStation(name: "Ekkattuthangal", line: "Green", structure: "Elevated"),
  MetroStation(name: "Arignar Anna Alandur", line: "Green", structure: "Elevated", isInterchange: true),
  MetroStation(name: "St. Thomas Mount", line: "Green", structure: "Elevated"),
];

List<MetroStation> getRoute(String originName, String destinationName) {
  final originStations = allStations.where((s) => s.name == originName).toList();
  final destinationStations = allStations.where((s) => s.name == destinationName).toList();

  if (originStations.isEmpty || destinationStations.isEmpty) return [];

  // Try same line first
  for (var origin in originStations) {
    for (var dest in destinationStations) {
      if (origin.line == dest.line) {
        final sameLineStations = allStations
            .where((s) => s.line == origin.line)
            .toList();
        final start = sameLineStations.indexWhere((s) => s.name == origin.name);
        final end = sameLineStations.indexWhere((s) => s.name == dest.name);
        if (start != -1 && end != -1) {
          final range = start < end
              ? sameLineStations.sublist(start, end + 1)
              : sameLineStations.sublist(end, start + 1).reversed.toList();
          return range;
        }
      }
    }
  }

  // Fallback: use interchange station (simple logic)
  const interchanges = ["Arignar Anna Alandur", "Puratchi Thalaivar Dr. M.G. Ramachandran Central"];
  for (final inter in interchanges) {
    final from = getRoute(originName, inter);
    final to = getRoute(inter, destinationName);
    if (from.isNotEmpty && to.isNotEmpty) {
      return [...from, ...to.skip(1)]; // avoid repeating interchange twice
    }
  }

  return []; // no route found
}

String generateInstructions(List<MetroStation> route) {
  if (route.isEmpty) return "No route available.";
  final buffer = StringBuffer();
  for (int i = 0; i < route.length; i++) {
    final station = route[i];
    if (i == 0) {
      buffer.writeln("1. Enter at ${station.name} — ${station.line} Line (${station.structure})");
    } else if (station.isInterchange && route[i - 1].line != station.line) {
      buffer.writeln("${i + 1}. Change at ${station.name} to ${station.line} Line");
    } else if (i == route.length - 1) {
      buffer.writeln("${i + 1}. Exit at ${station.name} — ${station.line} Line (${station.structure})");
    }
  }
  return buffer.toString();
}
