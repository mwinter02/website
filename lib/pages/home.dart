import 'package:google_fonts/google_fonts.dart';
import '../router.dart';
import '../theme/theme.dart';
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

  List<Project> get _featured => Projects.all.take(_featuredCount).toList();

  @override
  Widget desktopView(BuildContext context) => _buildPage(context);

  @override
  Widget mobileView(BuildContext context) => _buildPage(context);

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile card ───────────────────────────────────────────────
            const Center(child: ProfileCard()),

            // ── Accent divider ─────────────────────────────────────────────
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

            // ── Featured projects (no filter bar on home page) ─────────────
            ProjectGallery(
              projects: _featured,
              showFilters: false,
            ),

            // ── "View all projects" button ──────────────────────────────────
            _ViewAllButton(),
          ],
        ),
      ),
    );
  }
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
                    style: GoogleFonts.electrolize(
                      fontSize: 13,
                      letterSpacing: 2.5,
                      color: _hovered ? Colors.white : Colors.white60,
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
