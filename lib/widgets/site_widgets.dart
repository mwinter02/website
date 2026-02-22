import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../links.dart';
import '../theme/theme.dart';
import '../router.dart';
import '../theme/text_theme.dart';

AppBar siteAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 80,
    flexibleSpace: _AppBarBackground(),
    // titleSpacing: 0 lets our own padding fully control the layout.
    titleSpacing: 0,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo — FittedBox shrinks the text when the bar gets narrow
          // instead of overflowing.
          Flexible(
            child: TextButton(
              onPressed: () => context.go(Routes.home.path),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'mwinter02',
                  style: AppTextTheme.display.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          // Icon buttons — fixed size, never shrink.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _linkedInButton(context),
              _emailButton(context),
            ],
          ),
        ],
      ),
    ),
    automaticallyImplyLeading: false,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// _AppBarBackground  — gradient fill + accent rule at the bottom edge.
// Pull this out into its own widget so hover / blur effects can be layered
// independently in the future.
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
        // Razor-thin accent rule
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
      onPressed: () => launchUrl(emailLaunchUri),
    );

Widget _linkedInButton(BuildContext context) => _GlowIconButton(
      icon: FontAwesomeIcons.squareLinkedin,
      iconSize: 36,
      glowColor: const Color(0xFF0E7AE3), // LinkedIn blue
      onPressed: () => launchUrl(linkedInLaunchUri),
    );

// ─────────────────────────────────────────────────────────────────────────────
// _GlowIconButton — reusable hover-glow button.
// Swap glowColor per instance to give each icon its own branded glow.
// ─────────────────────────────────────────────────────────────────────────────

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
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: const TextStyle(), // required but unused
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: _hovered ? widget.glowColor : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
