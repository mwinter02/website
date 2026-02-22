import 'package:flutter/material.dart';
export 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Layout constants — shared with main.dart via this export.
//
// _kDesktopReferenceWidth  the narrowest width the desktop layout is authored
//                          for. Below this the root scale in main.dart kicks
//                          in and shrinks the whole UI proportionally.
//
// _kMobileBreakpoint       viewport widths below this use mobileView().
//
// _kMobileReferenceWidth   equivalent minimum for the mobile layout.
// ─────────────────────────────────────────────────────────────────────────────

const double kDesktopReferenceWidth = 1000;
const double kMobileBreakpoint      = 600;
const double kMobileReferenceWidth  = 360;

// ─────────────────────────────────────────────────────────────────────────────
// DynamicWidget
// ─────────────────────────────────────────────────────────────────────────────

abstract class DynamicWidget extends StatelessWidget {
  const DynamicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < kMobileBreakpoint
        ? mobileView(context)
        : desktopView(context);
  }

  Widget mobileView(BuildContext context);
  Widget desktopView(BuildContext context);
}

// ─────────────────────────────────────────────────────────────────────────────
// DynamicStatefulWidget / DynamicState
// ─────────────────────────────────────────────────────────────────────────────

abstract class DynamicStatefulWidget extends StatefulWidget {
  const DynamicStatefulWidget({super.key});
  @override
  DynamicState createState();
}

abstract class DynamicState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < kMobileBreakpoint
        ? mobileView(context)
        : desktopView(context);
  }

  Widget mobileView(BuildContext context);
  Widget desktopView(BuildContext context);
}