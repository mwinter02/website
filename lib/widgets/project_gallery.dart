import 'package:flutter/material.dart';
import '../models/project.dart';
import '../theme/text_theme.dart';
import '../theme/theme.dart';
import 'project_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProjectGallery
//
// Self-contained gallery widget used by both HomePage (featured subset) and
// ProjectsPage (full list).  Pass [showFilters: false] and a fixed [projects]
// list to suppress the filter bar (e.g. on the home page).
// ─────────────────────────────────────────────────────────────────────────────

class ProjectGallery extends StatefulWidget {
  final List<Project> projects;

  /// Show the PROJECTS heading and tag filter chips (used on ProjectsPage).
  final bool showFilters;

  /// Show a section heading without filter chips (used on HomePage).
  /// Ignored when [showFilters] is true.
  final bool showHeader;

  const ProjectGallery({
    super.key,
    required this.projects,
    this.showFilters = true,
    this.showHeader = false,
  });

  @override
  State<ProjectGallery> createState() => _ProjectGalleryState();
}

class _ProjectGalleryState extends State<ProjectGallery> {
  String? _activeTag;

  List<String> get _allTags {
    final tags = <String>{};
    for (final p in widget.projects) {
      tags.addAll(p.tags);
    }
    return tags.toList()..sort();
  }

  List<Project> get _filtered => _activeTag == null
      ? widget.projects
      : widget.projects.where((p) => p.tags.contains(_activeTag)).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showFilters) ...[
            GalleryHeader(
              allTags: _allTags,
              activeTag: _activeTag,
              onTagSelected: (tag) => setState(() => _activeTag = tag),
            ),
            const SizedBox(height: 24),
          ] else if (widget.showHeader) ...[
            const _FeaturedProjectsHeader(),
            const SizedBox(height: 24),
          ],
          ProjectGrid(projects: _filtered),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FeaturedProjectsHeader — used on the home page where filters are hidden
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturedProjectsHeader extends StatelessWidget {
  const _FeaturedProjectsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left accent rule
        Container(
          width: 3,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [ThemeColors.appBarAccent, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Colors.white54],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'FEATURED PROJECTS',
                style: AppTextTheme.displayHeadline.copyWith(
                  fontSize: 26,
                  letterSpacing: 5,
                  color: AppTextColors.bright,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'A selection of recent work',
              style: AppTextTheme.labelField.copyWith(
                fontSize: 12,
                color: AppTextColors.subtle,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GalleryHeader — responsive PROJECTS title + filter chips
// ─────────────────────────────────────────────────────────────────────────────

class GalleryHeader extends StatelessWidget {
  final List<String> allTags;
  final String? activeTag;
  final ValueChanged<String?> onTagSelected;

  const GalleryHeader({
    super.key,
    required this.allTags,
    required this.activeTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 900;
      return wide ? _wideLayout() : _narrowLayout();
    });
  }

  Widget _wideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(42),
            const SizedBox(height: 6),
            _verticalRule(),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FilterChips(
              tags: allTags,
              activeTag: activeTag,
              onTagSelected: onTagSelected,
            ),
          ),
        ),
      ],
    );
  }

  Widget _narrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(28),
        const SizedBox(height: 14),
        FilterChips(
          tags: allTags,
          activeTag: activeTag,
          onTagSelected: onTagSelected,
        ),
      ],
    );
  }

  Widget _title(double fontSize) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, Colors.white54],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        'PROJECTS',
        style: AppTextTheme.displayHeadline.copyWith(
          fontSize: fontSize,
          letterSpacing: 6,
          color: AppTextColors.bright,
        ),
      ),
    );
  }

  Widget _verticalRule() {
    return Container(
      width: 1.5,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            ThemeColors.appBarAccent.withValues(alpha: 0.8),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FilterChips — wrapping tag pills
// ─────────────────────────────────────────────────────────────────────────────

class FilterChips extends StatelessWidget {
  final List<String> tags;
  final String? activeTag;
  final ValueChanged<String?> onTagSelected;

  const FilterChips({
    super.key,
    required this.tags,
    required this.activeTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    final chips = [
      TagChip(
        label: 'ALL',
        active: activeTag == null,
        onTap: () => onTagSelected(null),
      ),
      ...tags.map(
        (t) => TagChip(
          label: t.toUpperCase(),
          active: activeTag == t,
          onTap: () => onTagSelected(activeTag == t ? null : t),
        ),
      ),
    ];
    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProjectGrid — responsive grid with hero layout and staggered animations
// ─────────────────────────────────────────────────────────────────────────────

enum GridMode { hero, twoCol, oneCol }

GridMode gridModeForWidth(double width) {
  if (width >= 1100) return GridMode.hero;
  if (width >= 600) return GridMode.twoCol;
  return GridMode.oneCol;
}

const double kGridMaxWidth = 1200;

class ProjectGrid extends StatefulWidget {
  final List<Project> projects;

  const ProjectGrid({super.key, required this.projects});

  @override
  State<ProjectGrid> createState() => _ProjectGridState();
}

class _ProjectGridState extends State<ProjectGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;
  GridMode? _lastMode;

  int _rowCount(GridMode mode) {
    final perRow =
        mode == GridMode.hero ? 3 : mode == GridMode.twoCol ? 2 : 1;
    return (widget.projects.length / perRow).ceil().clamp(0, 99);
  }

  void _buildAnimations(int rowCount) {
    _controllers = List.generate(
      rowCount,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 420),
      ),
    );
    _fades = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();
    _slides = _controllers
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)),
        )
        .toList();

    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  void _rebuildIfModeChanged(GridMode mode) {
    if (mode == _lastMode) return;
    _lastMode = mode;
    for (final c in _controllers) { c.dispose(); }
    _buildAnimations(_rowCount(mode));
  }

  @override
  void initState() {
    super.initState();
    _controllers = [];
    _fades = [];
    _slides = [];
  }

  @override
  void didUpdateWidget(ProjectGrid old) {
    super.didUpdateWidget(old);
    if (old.projects.length != widget.projects.length) {
      _lastMode = null;
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.projects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Text(
            'No projects in this category yet.',
            style: AppTextTheme.bodySmall.copyWith(
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final mode = gridModeForWidth(constraints.maxWidth);
      _rebuildIfModeChanged(mode);

      if (_fades.isEmpty) return const SizedBox.shrink();

      final perRow =
          mode == GridMode.hero ? 3 : mode == GridMode.twoCol ? 2 : 1;
      final rows = <List<Project>>[];
      for (var i = 0; i < widget.projects.length; i += perRow) {
        rows.add(
          widget.projects.sublist(
            i,
            (i + perRow).clamp(0, widget.projects.length),
          ),
        );
      }

      final grid = Column(
        children: [
          for (var r = 0; r < rows.length; r++) ...[
            if (r < _fades.length)
              FadeTransition(
                opacity: _fades[r],
                child: SlideTransition(
                  position: _slides[r],
                  child: _buildRow(rows[r], r, mode),
                ),
              )
            else
              _buildRow(rows[r], r, mode),
            if (r < rows.length - 1) const SizedBox(height: 16),
          ],
        ],
      );

      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kGridMaxWidth),
          child: grid,
        ),
      );
    });
  }

  Widget _buildRow(List<Project> row, int rowIndex, GridMode mode) {
    switch (mode) {
      case GridMode.hero:
        return HeroRow(projects: row, heroOnRight: rowIndex.isOdd);
      case GridMode.twoCol:
        return UniformRow(projects: row, columns: 2);
      case GridMode.oneCol:
        return UniformRow(projects: row, columns: 1);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HeroRow — featured card + stacked companions
// ─────────────────────────────────────────────────────────────────────────────

class HeroRow extends StatelessWidget {
  final List<Project> projects;
  final bool heroOnRight;

  static const int _heroFlex = 3;
  static const int _restFlex = 2;

  const HeroRow({super.key, required this.projects, required this.heroOnRight});

  @override
  Widget build(BuildContext context) {
    if (projects.length == 1) {
      return AspectRatio(aspectRatio: 21 / 9, child: _card(projects[0]));
    }

    final hero = projects[0];
    final rest = projects.sublist(1);

    final heroWidget = Expanded(
      flex: _heroFlex,
      child: AspectRatio(aspectRatio: 16 / 9, child: _card(hero)),
    );

    final stackWidget = Expanded(
      flex: _restFlex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < rest.length; i++) ...[
            Expanded(child: _card(rest[i])),
            if (i < rest.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: heroOnRight
            ? [stackWidget, const SizedBox(width: 16), heroWidget]
            : [heroWidget, const SizedBox(width: 16), stackWidget],
      ),
    );
  }

  Widget _card(Project p) => ProjectCard(
        route: p.route,
        imagePath: p.imagePath,
        title: p.title,
        description: p.description,
        tags: p.tags,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// UniformRow — equal-width cards for medium and narrow screens
// ─────────────────────────────────────────────────────────────────────────────

class UniformRow extends StatelessWidget {
  final List<Project> projects;
  final int columns;

  const UniformRow({
    super.key,
    required this.projects,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < projects.length; i++) ...[
          Expanded(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _card(projects[i]),
            ),
          ),
          if (i < projects.length - 1) const SizedBox(width: 16),
          if (i == projects.length - 1)
            for (var j = projects.length; j < columns; j++) ...[
              const SizedBox(width: 16),
              const Expanded(child: SizedBox.shrink()),
            ],
        ],
      ],
    );
  }

  Widget _card(Project p) => ProjectCard(
        route: p.route,
        imagePath: p.imagePath,
        title: p.title,
        description: p.description,
        tags: p.tags,
      );
}

