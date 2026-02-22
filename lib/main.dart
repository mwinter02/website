import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'theme/theme.dart';
import 'widgets/dynamic_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  // Light status-bar icons (white) on the dark background.
  // Also colours the home-indicator area on Android to match.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF0D0D14),
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFF0D0D14),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

ValueNotifier<bool> isMobileNotifier = ValueNotifier<bool>(true); // Set to true to test mobile layout on desktop.
List<PointerDeviceKind> _desktopPointerKinds = [
  PointerDeviceKind.mouse,
  PointerDeviceKind.trackpad,
  PointerDeviceKind.invertedStylus,
  PointerDeviceKind.unknown,
];

void _handlePointerEvent(PointerEvent event) {
  isMobileNotifier.value = !_desktopPointerKinds.contains(event.kind);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _handlePointerEvent,
      onPointerDown: _handlePointerEvent,
      onPointerUp: _handlePointerEvent,
      onPointerCancel: _handlePointerEvent,
      onPointerSignal: _handlePointerEvent,
      onPointerHover: _handlePointerEvent,

      child: MaterialApp.router(
        theme: appTheme,
        routerConfig: appRouter,
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);

          // ── 1. Clamp text scaling ────────────────────────────────────────
          // Prevents browser zoom / OS font size from inflating text and
          // causing overflow. Fixed at 1.0 — adjust max if you want some
          // accessibility scaling.
          final clamped = mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler.clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.0,
            ),
          );

          // ── 2. Whole-app proportional scale-down ─────────────────────────
          // When the logical viewport is narrower than the desktop reference
          // width (i.e. the window is very narrow OR the user has zoomed in),
          // scale the *entire* UI — AppBar included — down to fit.
          // This is applied here rather than in DynamicWidget so that widgets
          // outside the page body (AppBar, dialogs, snackbars) are also
          // protected automatically.
          final viewportWidth = clamped.size.width;
          final isMobile = viewportWidth < kMobileBreakpoint;
          final referenceWidth =
              isMobile ? kMobileReferenceWidth : kDesktopReferenceWidth;
          final scale = (viewportWidth / referenceWidth).clamp(0.0, 1.0);

          Widget content = MediaQuery(data: clamped, child: child!);

          if (scale < 1.0) {
            // Give the OverflowBox the reference width so layout happens
            // at the design size; Transform.scale then shrinks it to fit the
            // real viewport without triggering overflow.
            content = SizedBox(
              width: viewportWidth,
              height: clamped.size.height,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topLeft,
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minWidth: referenceWidth,
                  maxWidth: referenceWidth,
                  minHeight: clamped.size.height / scale,
                  maxHeight: clamped.size.height / scale,
                  child: MediaQuery(data: clamped, child: child),
                ),
              ),
            );
          }

          return content;
        },
      ),
    );
  }
}
