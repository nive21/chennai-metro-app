import '../models/station.dart';

final List<MetroStation> allStations = [
  MetroStation(name: "Chennai International Airport", line: "Blue", structure: "Elevated", x: 572.32, y: 2492.51),
  MetroStation(name: "Meenambakkam", line: "Blue", structure: "Elevated", x: 665.729, y: 2399.1),
  MetroStation(name: "Nanganallur Road (OTA)", line: "Blue", structure: "Elevated", x: 758.129, y: 2306.2),
  MetroStation(name: "Arignar Anna Alandur", line: "Blue", structure: "Elevated", x: 851.033, y: 2213.8, isInterchange: true),
  MetroStation(name: "Guindy", line: "Blue", structure: "Elevated", x: 989.379, y: 2075.45),
  MetroStation(name: "Little Mount", line: "Blue", structure: "Elevated", x: 1088.85, y: 1974.47),
  MetroStation(name: "Saidapet", line: "Blue", structure: "Elevated", x: 1184.28, y: 1880.05),
  MetroStation(name: "Nandanam", line: "Blue", structure: "Underground", x: 1281.22, y: 1782.6),
  MetroStation(name: "Teynampet", line: "Blue", structure: "Underground", x: 1377.15, y: 1685.66),
  MetroStation(name: "AG-DMS", line: "Blue", structure: "Underground", x: 1474.1, y: 1587.7),
  MetroStation(name: "Thousand Lights", line: "Blue", structure: "Underground", x: 1571.55, y: 1489.24),
  MetroStation(name: "LIC", line: "Blue", structure: "Underground", x: 1650.31, y: 1411.99),
  MetroStation(name: "Government Estate", line: "Blue", structure: "Underground", x: 1728.07, y: 1335.75),
  MetroStation(name: "Puratchi Thalaivar Dr. M.G. Ramachandran Central", line: "Blue", structure: "Underground", x: 1816.93, y: 1100.46, isInterchange: true),
  MetroStation(name: "High Court", line: "Blue", structure: "Underground", x: 1962.35, y: 1021.69),
  MetroStation(name: "Mannadi", line: "Blue", structure: "Underground", x: 1962.35, y: 900.616),
  MetroStation(name: "Washermenpet", line: "Blue", structure: "Underground", x: 1962.35, y: 549.63),
  MetroStation(name: "Sir Thiyagaraya College", line: "Blue", structure: "Underground", x: 1962.35, y: 686.208),
  MetroStation(name: "Tondiarpet", line: "Blue", structure: "Underground", x: 1962.35, y: 619.56),
  MetroStation(name: "New Washermenpet", line: "Blue", structure: "Elevated", x: 1962.35, y: 760.18),
  MetroStation(name: "Tollgate", line: "Blue", structure: "Elevated", x: 1962.35, y: 479.699),
  MetroStation(name: "Kaladipet", line: "Blue", structure: "Elevated", x: 1962.35, y: 411.535),
  MetroStation(name: "Thiruvottriyur Theradi", line: "Blue", structure: "Elevated", x: 1962.35, y: 344.886),
  MetroStation(name: "Thiruvotriyur", line: "Blue", structure: "Elevated", x: 1962.35, y: 268.14),
  MetroStation(name: "Wimco Nagar", line: "Blue", structure: "Elevated", x: 1962.35, y: 201.491),
  MetroStation(name: "Wimco Nagar Depot", line: "Blue", structure: "Elevated", x: 1962.35, y: 127.16),
  MetroStation(name: "Puratchi Thalaivar Dr. M.G. Ramachandran Central", line: "Green", structure: "Underground", x: 1816.93, y: 1100.46, isInterchange: true),
  MetroStation(name: "Egmore", line: "Green", structure: "Underground", x: 1684.14, y: 1099.96),
  MetroStation(name: "Nehru Park", line: "Green", structure: "Underground", x: 1540.75, y: 1099.96),
  MetroStation(name: "Kilpauk Medical College", line: "Green", structure: "Underground", x: 1408.46, y: 1099.96),
  MetroStation(name: "Pachaiyappa's College", line: "Green", structure: "Underground", x: 1267.59, y: 1099.96),
  MetroStation(name: "Shenoy Nagar", line: "Green", structure: "Underground", x: 1127.22, y: 992.409),
  MetroStation(name: "Anna Nagar East", line: "Green", structure: "Underground", x: 1036.84, y: 893.445),
  MetroStation(name: "Anna Nagar Tower", line: "Green", structure: "Underground", x: 887.387, y: 893.445),
  MetroStation(name: "Thirumangalam", line: "Green", structure: "Underground", x: 736.922, y: 893.445),
  MetroStation(name: "Koyambedu", line: "Green", structure: "Elevated", x: 638.464, y: 1101.47),
  MetroStation(name: "CMBT (Puratchi Thalaivi Dr. J. Jayalalithaa)", line: "Green", structure: "Elevated", x: 756.109, y: 1239.82),
  MetroStation(name: "Arumbakkam", line: "Green", structure: "Elevated", x: 851.033, y: 1379.68),
  MetroStation(name: "Vadapalani", line: "Green", structure: "Elevated", x: 851.033, y: 1586.19),
  MetroStation(name: "Ashok Nagar", line: "Green", structure: "Elevated", x: 851.033, y: 1797.75),
  MetroStation(name: "Ekkattuthangal", line: "Green", structure: "Elevated", x: 851.033, y: 2031.52),
  MetroStation(name: "Arignar Anna Alandur", line: "Green", structure: "Elevated", x: 851.033, y: 2213.8, isInterchange: true),
  MetroStation(name: "St. Thomas Mount", line: "Green", structure: "Elevated", x: 851.033, y: 2355.17),
];

List<MetroStation> getRoute(String originName, String destinationName) {
  final originStations = allStations.where((s) => s.name == originName).toList();
  final destinationStations = allStations.where((s) => s.name == destinationName).toList();

  if (originStations.isEmpty || destinationStations.isEmpty) return [];

  // Try direct same-line route
  for (var origin in originStations) {
    for (var dest in destinationStations) {
      if (origin.line == dest.line) {
        final sameLineStations = allStations.where((s) => s.line == origin.line).toList();
        final start = sameLineStations.indexWhere((s) => s.name == origin.name);
        final end = sameLineStations.indexWhere((s) => s.name == dest.name);
        if (start != -1 && end != -1) {
          return start <= end
              ? sameLineStations.sublist(start, end + 1)
              : sameLineStations.sublist(end, start + 1).reversed.toList();
        }
      }
    }
  }

  // Handle interchanges
  const interchanges = [
    "Arignar Anna Alandur",
    "Puratchi Thalaivar Dr. M.G. Ramachandran Central"
  ];

  for (final interName in interchanges) {
    final greenInterCandidates =
    allStations.where((s) => s.name == interName && s.line == "Green");
    final MetroStation? greenInter =
    greenInterCandidates.isNotEmpty ? greenInterCandidates.first : null;
    final blueInterCandidates =
    allStations.where((s) => s.name == interName && s.line == "Blue");
    final MetroStation? blueInter =
    blueInterCandidates.isNotEmpty ? blueInterCandidates.first : null;

    if (greenInter == null || blueInter == null) continue;

    final toInter = getRoute(originName, interName);
    final fromInter = getRoute(interName, destinationName);

    if (toInter.isNotEmpty &&
        fromInter.isNotEmpty &&
        toInter.last.line != fromInter.first.line) {
      return [...toInter, ...fromInter.skip(1)];
    }
  }

  return [];
}

String generateInstructions(List<MetroStation> route) {
  if (route.isEmpty) return "No route available.";

  final buffer = StringBuffer();
  int step = 1;

  for (int i = 0; i < route.length; i++) {
    final station = route[i];
    final prev = i > 0 ? route[i - 1] : null;

    if (i == 0) {
      buffer.writeln("$step. Enter at ${station.name} — ${station.line} Line (${station.structure})");
      step++;
    } else if (prev != null && station.line != prev.line) {
      buffer.writeln("$step. Change at ${prev.name} to ${station.line} Line");
      step++;
    }

    if (i == route.length - 1) {
      buffer.writeln("$step. Exit at ${station.name} — ${station.line} Line (${station.structure})");
    }
  }

  return buffer.toString();
}
