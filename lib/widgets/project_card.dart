import 'package:flutter/material.dart';
import '../router.dart';

class ProjectCard extends StatefulWidget {
  final String route;
  final String imagePath;
  final String title;

  const ProjectCard({super.key, required this.route, required this.imagePath, required this.title});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(8));
    return ElevatedButton(
      onPressed: () => context.go(widget.route),
      onHover: (hovering) => setState(() => _isHovering = hovering),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        elevation: 2,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: borderRadius,
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          AnimatedOpacity(
            opacity: _isHovering ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: Colors.black26,
              ),
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
