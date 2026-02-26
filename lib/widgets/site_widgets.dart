import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../sources.dart';
import '../router.dart';
import '../theme/theme.dart';
import '../theme/text_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomeScrollKeys
//
// Singleton that holds the GlobalKeys for the home page scroll anchors.
// Any page's app bar can call HomeScrollKeys.scrollTo(key) after navigating
// to home, without needing a direct reference to the HomePage widget tree.
// ─────────────────────────────────────────────────────────────────────────────

class HomeScrollKeys {
  HomeScrollKeys._();

  static final GlobalKey top     = GlobalKey();
  static final GlobalKey about   = GlobalKey();
  static final GlobalKey contact = GlobalKey();

  /// Scroll to [key] after the current frame — use after context.go('/') so
  /// the home page has had a chance to build before we try to find the key.
  static void scrollAfterFrame(GlobalKey key) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.0,
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NavConfig — kept for API compatibility but collapsed to NoNav only.
// All navigation is now handled by the unified _SiteNavLinks widget.
// ─────────────────────────────────────────────────────────────────────────────

sealed class NavConfig { const NavConfig(); }
class HomeNav extends NavConfig {
  // Kept so home.dart compiles unchanged; fields are unused — nav is global.
  final ScrollController scrollController;
  final GlobalKey aboutKey;
  final GlobalKey contactKey;
  const HomeNav({
    required this.scrollController,
    required this.aboutKey,
    required this.contactKey,
  });
}
class BreadcrumbNav extends NavConfig {
  final String label;
  final String route;
  const BreadcrumbNav({required this.label, required this.route});
}
class NoNav extends NavConfig { const NoNav(); }

// ─────────────────────────────────────────────────────────────────────────────
// siteAppBar
// ─────────────────────────────────────────────────────────────────────────────

AppBar siteAppBar(BuildContext context, {NavConfig nav = const NoNav()}) {
  return AppBar(
    toolbarHeight: 80,
    flexibleSpace: _AppBarBackground(),
    titleSpacing: 0,
    automaticallyImplyLeading: false,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(builder: (context, constraints) {
        final narrow = constraints.maxWidth < 580;
        return Row(
          children: [
            // ── Logo — capped width on narrow screens so it never crowds ───
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: narrow ? constraints.maxWidth/2 : double.infinity),
              child: TextButton(
                onPressed: () => context.go(Routes.home.path),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'mwinter02',
                    style: AppTextTheme.display,
                  ),
                ),
              ),
            ),
            // ── Centre nav — horizontal links, hidden on narrow screens ───
            Expanded(child: _SiteNavLinks()),
            // ── Social icons — always present ─────────────────────────────
            _linkedInButton(context),
            _emailButton(context),
            // ── Hamburger — right of email, only on narrow screens ────────
            if (narrow) _HamburgerMenu(),
          ],
        );
      }),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// _SiteNavLinks — horizontal on wide screens, hamburger on narrow
// ─────────────────────────────────────────────────────────────────────────────

// The four nav items, defined once and shared between both layouts.
List<({String label, VoidCallback onTap})> _navItems(BuildContext context) => [
  (
    label: 'HOME',
    onTap: () {
      if (GoRouterState.of(context).uri.toString() == Routes.home.path) {
        HomeScrollKeys.scrollAfterFrame(HomeScrollKeys.top);
      } else {
        context.go(Routes.home.path);
      }
    },
  ),
  (
    label: 'PROJECTS',
    onTap: () => context.go(Routes.projects.path),
  ),
  (
    label: 'ABOUT',
    onTap: () {
      if (GoRouterState.of(context).uri.toString() != Routes.home.path) {
        context.go(Routes.home.path);
      }
      HomeScrollKeys.scrollAfterFrame(HomeScrollKeys.about);
    },
  ),
  (
    label: 'CONTACT',
    onTap: () {
      if (GoRouterState.of(context).uri.toString() != Routes.home.path) {
        context.go(Routes.home.path);
      }
      HomeScrollKeys.scrollAfterFrame(HomeScrollKeys.contact);
    },
  ),
];

class _SiteNavLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Hidden on narrow screens — hamburger takes over.
      if (constraints.maxWidth < 580) return const SizedBox.shrink();
      final items = _navItems(context);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) _NavDot(),
            _NavLink(label: items[i].label, onTap: items[i].onTap),
          ],
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HamburgerMenu — animated ☰ / ✕ toggle with overlay dropdown
// ─────────────────────────────────────────────────────────────────────────────

class _HamburgerMenu extends StatefulWidget {
  @override
  State<_HamburgerMenu> createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<_HamburgerMenu>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  OverlayEntry? _overlay;
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _removeOverlay();
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_open) {
      _close();
    } else {
      _showOverlay();
    }
  }

  void _close() {
    _ctrl.reverse().then((_) {
      _removeOverlay();
      if (mounted) setState(() => _open = false);
    });
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _showOverlay() {
    setState(() => _open = true);
    _ctrl.forward(from: 0);

    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final appBarBottom = offset.dy + box.size.height;

    _overlay = OverlayEntry(
      builder: (ctx) => _DropdownOverlay(
        top: appBarBottom,
        fade: _fade,
        slide: _slide,
        items: _navItems(context),
        onClose: _close,
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Icon(
              _open ? Icons.close_rounded : Icons.menu_rounded,
              key: ValueKey(_open),
              color: Colors.white,
              size: 42,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DropdownOverlay — the actual dropdown panel rendered in the Overlay
// ─────────────────────────────────────────────────────────────────────────────

class _DropdownOverlay extends StatelessWidget {
  final double top;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final List<({String label, VoidCallback onTap})> items;
  final VoidCallback onClose;

  const _DropdownOverlay({
    required this.top,
    required this.fade,
    required this.slide,
    required this.items,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tap outside to close
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onClose,
            child: const SizedBox.expand(),
          ),
        ),
        // Dropdown panel — right-aligned, under the app bar
        Positioned(
          top: top,
          right: 0,
          child: FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              // Material resets DefaultTextStyle so the Overlay context
              // doesn't inherit the browser's default yellow underline.
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(top: 4, right: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E0E1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ThemeColors.appBarAccent.withValues(alpha: 0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.55),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: ThemeColors.appBarAccent.withValues(alpha: 0.08),
                        blurRadius: 32,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        _DropdownItem(
                          label: items[i].label,
                          onTap: () {
                            onClose();
                            items[i].onTap();
                          },
                          isFirst: i == 0,
                          isLast: i == items.length - 1,
                        ),
                        if (i < items.length - 1)
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DropdownItem — a single row inside the dropdown
// ─────────────────────────────────────────────────────────────────────────────

class _DropdownItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _DropdownItem({
    required this.label,
    required this.onTap,
    required this.isFirst,
    required this.isLast,
  });

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _hovered
                ? ThemeColors.appBarAccent.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.vertical(
              top:    widget.isFirst ? const Radius.circular(10) : Radius.zero,
              bottom: widget.isLast  ? const Radius.circular(10) : Radius.zero,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Text(
                widget.label,
                style: AppTextTheme.labelMenuItem.copyWith(
                  color: _hovered ? AppTextColors.bright : AppTextColors.secondary,
                  fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: ThemeColors.appBarAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _NavLink
// ─────────────────────────────────────────────────────────────────────────────

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextTheme.labelNav.copyWith(
                  color: _hovered ? AppTextColors.bright : AppTextColors.secondary,
                  fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 1.5,
                width: _hovered ? 32.0 : 0.0,
                decoration: BoxDecoration(
                  color: ThemeColors.appBarAccent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Text(
        '·',
        style: TextStyle(color: Colors.white24, fontSize: 14),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// _AppBarBackground
// ─────────────────────────────────────────────────────────────────────────────

class _AppBarBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.appBarStart, ThemeColors.appBarEnd],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
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
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Icon buttons
// ─────────────────────────────────────────────────────────────────────────────

Widget _emailButton(BuildContext context) => _GlowIconButton(
      icon: Icons.email_outlined,
      iconSize: 40,
      glowColor: const Color(0xFFFF39F5),
      onPressed: () => launchUrl(Sources.emailLaunchUri),
    );

Widget _linkedInButton(BuildContext context) => _GlowIconButton(
      icon: FontAwesomeIcons.squareLinkedin,
      iconSize: 36,
      glowColor: const Color(0xFF0E7AE3),
      onPressed: () => launchUrl(Sources.linkedInLaunchUri),
    );

class _GlowIconButton extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final Color glowColor;
  final VoidCallback onPressed;

  const _GlowIconButton({
    required this.icon,
    required this.iconSize,
    required this.glowColor,
    required this.onPressed,
  });

  @override
  State<_GlowIconButton> createState() => _GlowIconButtonState();
}

class _GlowIconButtonState extends State<_GlowIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.glowColor.withValues(alpha: 0.65),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: _hovered ? widget.glowColor : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) =>
      Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white.withValues(alpha: 0.05),
      );
}
