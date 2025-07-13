class MetroStation {
  final String name;
  final String line; // "Blue" or "Green"
  final bool isInterchange;
  final String structure; // "Underground" or "Elevated"
  final int platform;
  final double x;
  final double y;

  MetroStation({
    required this.name,
    required this.line,
    required this.structure,
    this.isInterchange = false,
    this.platform = 1,
    required this.x,
    required this.y,
  });
}