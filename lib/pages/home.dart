import 'package:google_fonts/google_fonts.dart';
import '../theme/theme.dart';
import '../widgets/dynamic_widget.dart';
import '../router.dart';
import '../widgets/profile_card.dart';
import '../widgets/project_card.dart';
import '../widgets/site_widgets.dart';
import 'projects.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Project data — add new projects here, tags wire up the filter bar
// automatically.
// ─────────────────────────────────────────────────────────────────────────────



// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class MyHomePage extends DynamicStatefulWidget {
  const MyHomePage({super.key});

  @override
  DynamicState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends DynamicState<MyHomePage> {
  String? _activeTag;

  List<String> get _allTags {
    final tags = <String>{};
    for (final p in Projects.all) {
      tags.addAll(p.tags);
    }
    return tags.toList()..sort();
  }

  List<Project> get _filtered => _activeTag == null
      ? Projects.all
      : Projects.all.where((p) => p.tags.contains(_activeTag)).toList();

  @override
  Widget desktopView(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: ProfileCard()),
            // Thin accent rule — replaces the old heavy banner
            Container(
              height: 1.5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    ThemeColors.appBarAccent,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            _ProjectsSection(
              projects: _filtered,
              allTags: _allTags,
              activeTag: _activeTag,
              onTagSelected: (tag) => setState(() => _activeTag = tag),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget mobileView(BuildContext context) => desktopView(context);
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProjectsSection
// ─────────────────────────────────────────────────────────────────────────────

class _ProjectsSection extends StatelessWidget {
  final List<Project> projects;
  final List<String> allTags;
  final String? activeTag;
  final ValueChanged<String?> onTagSelected;

  const _ProjectsSection({
    required this.projects,
    required this.allTags,
    required this.activeTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            allTags: allTags,
            activeTag: activeTag,
            onTagSelected: onTagSelected,
          ),
          const SizedBox(height: 24),
          _FeaturedGrid(projects: projects),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SectionHeader — watermark title + filter bar on one line
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final List<String> allTags;
  final String? activeTag;
  final ValueChanged<String?> onTagSelected;

  const _SectionHeader({
    required this.allTags,
    required this.activeTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Oversized watermark label — low opacity so it reads as atmosphere
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Colors.white54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'PROJECTS',
            style: GoogleFonts.michroma(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white, // shader overrides this
              letterSpacing: 6,
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Vertical rule separating title from filter chips
        Container(
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
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _FilterBar(
            tags: allTags,
            activeTag: activeTag,
            onTagSelected: onTagSelected,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FilterBar
// ─────────────────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final List<String> tags;
  final String? activeTag;
  final ValueChanged<String?> onTagSelected;

  const _FilterBar({
    required this.tags,
    required this.activeTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "All" pill
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TagChip(
              label: 'ALL',
              active: activeTag == null,
              onTap: () => onTagSelected(null),
            ),
          ),
          ...tags.map(
            (t) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TagChip(
                label: t.toUpperCase(),
                active: activeTag == t,
                onTap: () => onTagSelected(activeTag == t ? null : t),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Layout breakpoints
// ─────────────────────────────────────────────────────────────────────────────

enum _GridMode { hero, twoCol, oneCol }

_GridMode _gridMode(double width) {
  if (width >= 1100) return _GridMode.hero;
  if (width >= 600)  return _GridMode.twoCol;
  return _GridMode.oneCol;
}

// Maximum width the grid is allowed to occupy.
// Prevents cards from becoming absurdly large on 4K monitors.
const double _gridMaxWidth = 1200;

// ─────────────────────────────────────────────────────────────────────────────
// _FeaturedGrid — responsive, with staggered fade+slide entrance per row
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturedGrid extends StatefulWidget {
  final List<Project> projects;
  const _FeaturedGrid({required this.projects});

  @override
  State<_FeaturedGrid> createState() => _FeaturedGridState();
}

class _FeaturedGridState extends State<_FeaturedGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;
  _GridMode? _lastMode;

  int _rowCount(_GridMode mode) {
    final perRow = mode == _GridMode.hero ? 3 : mode == _GridMode.twoCol ? 2 : 1;
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
        .map((c) => Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  void _rebuildIfModeChanged(_GridMode mode) {
    if (mode == _lastMode) return;
    _lastMode = mode;
    for (final c in _controllers) {
      c.dispose();
    }
    _buildAnimations(_rowCount(mode));
  }

  @override
  void initState() {
    super.initState();
    // Animations are seeded on first layout in build() via _rebuildIfModeChanged.
    _controllers = [];
    _fades = [];
    _slides = [];
  }

  @override
  void didUpdateWidget(_FeaturedGrid old) {
    super.didUpdateWidget(old);
    if (old.projects.length != widget.projects.length) {
      _lastMode = null; // force rebuild on next layout pass
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
            style: GoogleFonts.electrolize(
              color: Colors.white38,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final mode = _gridMode(constraints.maxWidth);
      _rebuildIfModeChanged(mode);

      // Guard: animations may not be ready on very first frame.
      if (_fades.isEmpty) return const SizedBox.shrink();

      final perRow = mode == _GridMode.hero ? 3 : mode == _GridMode.twoCol ? 2 : 1;
      final rows = <List<Project>>[];
      for (var i = 0; i < widget.projects.length; i += perRow) {
        rows.add(widget.projects
            .sublist(i, (i + perRow).clamp(0, widget.projects.length)));
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

      // Centre and cap width on wide screens.
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _gridMaxWidth),
          child: grid,
        ),
      );
    });
  }

  Widget _buildRow(List<Project> row, int rowIndex, _GridMode mode) {
    switch (mode) {
      case _GridMode.hero:
        return _HeroRow(projects: row, heroOnRight: rowIndex.isOdd);
      case _GridMode.twoCol:
        return _UniformRow(projects: row, columns: 2);
      case _GridMode.oneCol:
        return _UniformRow(projects: row, columns: 1);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HeroRow — large featured card + stacked companions (wide screens only)
// ─────────────────────────────────────────────────────────────────────────────

class _HeroRow extends StatelessWidget {
  final List<Project> projects;
  final bool heroOnRight;

  static const int _heroFlex = 3;
  static const int _restFlex = 2;

  const _HeroRow({required this.projects, required this.heroOnRight});

  @override
  Widget build(BuildContext context) {
    if (projects.length == 1) {
      return AspectRatio(
        aspectRatio: 21 / 9,
        child: _card(projects[0]),
      );
    }

    final hero = projects[0];
    final rest = projects.sublist(1);

    final heroWidget = Expanded(
      flex: _heroFlex,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _card(hero),
      ),
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
// _UniformRow — equal-width cards for medium and narrow screens
// ─────────────────────────────────────────────────────────────────────────────

class _UniformRow extends StatelessWidget {
  final List<Project> projects;
  final int columns;

  const _UniformRow({required this.projects, required this.columns});

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
          // Pad with empty Expanded slots so partial rows stay sized correctly.
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
