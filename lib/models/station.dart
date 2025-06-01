class MetroStation {
  final String name;
  final String line; // "Blue" or "Green"
  final bool isInterchange;
  final String structure; // "Underground" or "Elevated"

  MetroStation({
    required this.name,
    required this.line,
    required this.structure,
    this.isInterchange = false,
  });
}
