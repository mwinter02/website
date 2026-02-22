// ─────────────────────────────────────────────────────────────────────────────
// Project — lightweight data model shared by the gallery and the page registry.
// Kept in its own file to avoid circular imports between projects.dart and
// project_gallery.dart.
// ─────────────────────────────────────────────────────────────────────────────

class Project {
  final String route;
  final String title;
  final String imagePath;
  final String description;
  final String markdownPath;
  final List<String> tags;

  Project({
    required this.route,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.markdownPath,
    required this.tags,
  });
}

