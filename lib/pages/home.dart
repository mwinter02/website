import 'package:flutter/material.dart';
import '../router.dart';
import '../theme/text_theme.dart';
import '../theme/theme.dart';
import '../widgets/about_section.dart';
import '../widgets/dynamic_widget.dart';
import '../widgets/profile_card.dart';
import '../widgets/project_gallery.dart';
import '../widgets/site_widgets.dart';
import 'projects.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomePage
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends DynamicStatefulWidget {
  const HomePage({super.key});

  @override
  DynamicState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends DynamicState<HomePage> {
  // Show only the first 6 projects on the home page.
  static const int _featuredCount = 6;

  // One ScrollController drives the page scroll.
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Project> get _featured => Projects.all.take(_featuredCount).toList();

  @override
  Widget desktopView(BuildContext context) => _buildPage(context);

  @override
  Widget mobileView(BuildContext context) => _buildPage(context);

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kGridMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Scroll-to-top anchor ─────────────────────────────────
                SizedBox(key: HomeScrollKeys.top, height: 0),

                // ── Profile card ─────────────────────────────────────────
                const Center(child: ProfileCard()),

                // ── Accent divider ───────────────────────────────────────
                _accentDivider(),

                // ── Featured projects ────────────────────────────────────
                ProjectGallery(
                  projects: _featured,
                  showFilters: false,
                  showHeader: true,
                ),

                // ── View all button ──────────────────────────────────────
                _ViewAllButton(),

                // ── Accent divider ───────────────────────────────────────
                _accentDivider(),

                // ── About + Contact (dossier) ────────────────────────────
                SizedBox(key: HomeScrollKeys.about, height: 0),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: AboutSection(),
                ),

                SizedBox(key: HomeScrollKeys.contact, height: 0),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _accentDivider() => Container(
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
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// _ViewAllButton
// ─────────────────────────────────────────────────────────────────────────────

class _ViewAllButton extends StatefulWidget {
  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit:  (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () => context.go(Routes.projectsPath),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _hovered
                      ? Colors.deepPurpleAccent
                      : Colors.white.withValues(alpha: 0.25),
                  width: 1.2,
                ),
                color: _hovered
                    ? Colors.deepPurpleAccent.withValues(alpha: 0.15)
                    : Colors.transparent,
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
                          blurRadius: 16,
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VIEW ALL PROJECTS',
                    style: AppTextTheme.labelNav.copyWith(
                      fontSize: 13,
                      letterSpacing: 2.5,
                      color: _hovered ? AppTextColors.bright : AppTextColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedSlide(
                    offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: _hovered ? Colors.deepPurpleAccent : Colors.white38,
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
