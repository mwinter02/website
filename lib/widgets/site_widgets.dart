import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/links.dart';
import 'package:website/theme/theme.dart';

import '../router.dart';
import '../theme/text_theme.dart';

AppBar siteAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 80,
    // Paint the gradient + accent rule as the bar's own background.
    flexibleSpace: _AppBarBackground(),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          child: Text('mwinter02', style: AppTextTheme.display.copyWith(
            color: Colors.white,
          )),
          onPressed: () => context.go(RouteNames.home),
        ),
        Row(
          children: [
            _linkedInButton(context),
            _emailButton(context),
          ],
        ),
      ],
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

Widget _emailButton(BuildContext context) {
  return IconButton(
    iconSize: 48,
    hoverColor: Colors.transparent,
    onPressed: () => launchUrl(emailLaunchUri),
    icon: const Icon(Icons.email_outlined, color: Colors.white),
  );
}

Widget _linkedInButton(BuildContext context) {
  return IconButton(
    iconSize: 40,
    hoverColor: Colors.transparent,
    onHover: (hovering) => (),
    onPressed: () => launchUrl(linkedInLaunchUri),
    icon: const Icon(FontAwesomeIcons.squareLinkedin, color: Colors.white),
  );
}
