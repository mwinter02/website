import 'dart:ui';

import 'package:flutter/material.dart';
import '../main.dart';
import '../router.dart';
import '../theme/text_theme.dart';
import 'dynamic_widget.dart';

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
    return ValueListenableBuilder(
      valueListenable: isMobileNotifier,
      builder: (context, isTrue, child) => MouseRegion(
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
                    opacity: _isHovering || isTrue ? 1.0 : 0.0,
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
            style: AppTextTheme.displayName.copyWith(
              fontSize: 18,
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
              style: AppTextTheme.bodySmall.copyWith(fontSize: 12),
            ),
          ],
          // "View project" affordance
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'VIEW PROJECT',
                style: AppTextTheme.labelNav.copyWith(
                  fontSize: 11,
                  color: AppTextColors.accent,
                  letterSpacing: 2,
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

class _TagChip extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _TagChip({required this.label, this.active = false, this.onTap});

  @override
  State<_TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<_TagChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final hovered = _hovered && !active;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: active
                ? Colors.deepPurpleAccent.withValues(alpha: 0.35)
                : hovered
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: active
                  ? Colors.deepPurpleAccent
                  : hovered
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.35),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: AppTextTheme.labelField.copyWith(
              fontSize: 11,
              letterSpacing: 1.2,
              color: active
                  ? AppTextColors.bright
                  : _hovered
                      ? AppTextColors.primary
                      : AppTextColors.secondary,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
