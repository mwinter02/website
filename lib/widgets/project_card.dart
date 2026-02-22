import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProjectCard
// ─────────────────────────────────────────────────────────────────────────────

class ProjectCard extends StatefulWidget {
  final String route;
  final String imagePath;
  final String title;

  /// Short blurb shown on the hover overlay. Optional but recommended.
  final String description;

  /// Tags used by the filter bar (e.g. 'Games', 'Graphics').
  /// Pass an empty list to show the card under every filter.
  final List<String> tags;

  const ProjectCard({
    super.key,
    required this.route,
    required this.imagePath,
    required this.title,
    this.description = '',
    this.tags = const [],
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(10));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit:  (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: _isHovering
                    ? Colors.deepPurpleAccent.withValues(alpha: 0.45)
                    : Colors.black.withValues(alpha: 0.35),
                blurRadius: _isHovering ? 20 : 8,
                spreadRadius: _isHovering ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // Slight lift on hover via transform
          transform: _isHovering
              ? (Matrix4.identity()..translateByDouble(0.0, -4.0, 0.0, 1.0))
              : Matrix4.identity(),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Banner image ──────────────────────────────────────────
                Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                ),
                // ── Hover overlay ─────────────────────────────────────────
                AnimatedOpacity(
                  opacity: _isHovering ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  child: _HoverOverlay(
                    title: widget.title,
                    description: widget.description,
                    tags: widget.tags,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HoverOverlay — isolated so it can be styled/animated independently later.
// ─────────────────────────────────────────────────────────────────────────────

class _HoverOverlay extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tags;

  const _HoverOverlay({
    required this.title,
    required this.description,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.0),
            Colors.black.withValues(alpha: 0.75),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tags row
          if (tags.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: tags
                  .map((t) => _TagChip(label: t))
                  .toList(),
            ),
          if (tags.isNotEmpty) const SizedBox(height: 6),
          // Title
          Text(
            title,
            style: GoogleFonts.michroma(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
          // Description
          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
          // "View project" affordance
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'VIEW PROJECT',
                style: GoogleFonts.electrolize(
                  fontSize: 11,
                  color: Colors.deepPurpleAccent.shade100,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward,
                  size: 13, color: Colors.deepPurpleAccent.shade100),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TagChip — public so it can be reused on the filter bar.
// ─────────────────────────────────────────────────────────────────────────────

class TagChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const TagChip({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => _TagChip(
        label: label,
        active: active,
        onTap: onTap,
      );
}

class _TagChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _TagChip({required this.label, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active
              ? Colors.deepPurpleAccent.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: active
                ? Colors.deepPurpleAccent
                : Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.electrolize(
            fontSize: 11,
            letterSpacing: 1.2,
            color: active ? Colors.white : Colors.white60,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
