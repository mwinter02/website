import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppTextColors
//
// Every text colour used across the site in one place.
// Reference these instead of inline Colors.whiteXX or hardcoded hex values.
// ─────────────────────────────────────────────────────────────────────────────

class AppTextColors {
  AppTextColors._();

  // ── Base whites ────────────────────────────────────────────────────────────
  /// Primary text — slightly blue-tinted white, softer than pure white
  /// against the purple background.
  static const Color primary    = Color(0xFFE0E0FF);

  /// Secondary text — muted lavender-grey for supporting copy.
  static const Color secondary  = Color(0xFFB0B0C8);

  /// Disabled / decorative text — very faint, used for metadata and rules.
  static const Color subtle     = Color(0xFF6B6B8A);

  /// Pure white — reserved for highlighted / active states only.
  static const Color bright     = Color(0xFFFFFFFF);

  // ── Accent colours ─────────────────────────────────────────────────────────
  /// Purple — primary interactive accent, matches appBarAccent.
  static const Color accent     = Color(0xFF7C4DFF);

  /// Terminal green — online indicators, success states, availability stamp.
  static const Color terminal   = Color(0xFF00E676);

  /// Prompt green — the `>` character in terminal labels (brighter than terminal).
  static const Color prompt     = Color(0xFF69FF47);

  /// Classified red — [CLASSIFIED] badge, warning indicators.
  static const Color danger     = Color(0xFFFF3B3B);

  /// Amber — resume / download channel accent.
  static const Color amber      = Color(0xFFFFD600);

  /// LinkedIn blue.
  static const Color linkedIn   = Color(0xFF0A66C2);
}

// ─────────────────────────────────────────────────────────────────────────────
// AppTextTheme
//
// Three-font system:
//   Display  → Oxanium        (logo, name, large section headers)
//   Mono     → JetBrains Mono (nav links, labels, pills, terminal copy, code)
//   Body     → Inter          (bio paragraphs, project descriptions, stat values)
//
// Naming convention:
//   display*   — Oxanium,        large decorative use
//   label*     — JetBrains Mono, small ALL-CAPS UI text
//   mono*      — JetBrains Mono, data / code / terminal body
//   body*      — Inter,          readable paragraph text
// ─────────────────────────────────────────────────────────────────────────────

class AppTextTheme {
  AppTextTheme._();

  // ── Display — Oxanium ──────────────────────────────────────────────────────

  /// Site logo / hero name — largest display use.
  static final TextStyle display = GoogleFonts.oxanium(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppTextColors.bright,
    letterSpacing: 1.5,
  );

  /// Section header — e.g. "ABOUT", "PROJECTS".
  static final TextStyle displayHeadline = GoogleFonts.oxanium(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppTextColors.primary,
    letterSpacing: 1.2,
  );

  /// Card name — your name on the profile card.
  static final TextStyle displayName = GoogleFonts.oxanium(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppTextColors.bright,
    letterSpacing: 1.0,
  );

  /// Card subtitle — role / title beneath the name.
  static final TextStyle displaySubtitle = GoogleFonts.oxanium(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppTextColors.secondary,
    letterSpacing: 1.5,
  );

  // ── Labels — JetBrains Mono (ALL CAPS UI) ─────────────────────────────────

  /// Navigation links — HOME · PROJECTS · ABOUT · CONTACT.
  static final TextStyle labelNav = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppTextColors.secondary,
    letterSpacing: 2.0,
  );

  /// Section category label — e.g. "> KNOWN_PROFILES", "> WHO_AM_I".
  static final TextStyle labelSection = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppTextColors.accent,
    letterSpacing: 2.0,
  );

  /// Terminal prompt character — the `>` prefix.
  static final TextStyle labelPrompt = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppTextColors.prompt,
    letterSpacing: 0,
  );

  /// Small ALL-CAPS field label — e.g. "EMAIL", "LINKEDIN", "SUBJECT".
  static final TextStyle labelField = GoogleFonts.jetBrainsMono(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: AppTextColors.subtle,
    letterSpacing: 2.5,
  );

  /// Badge / pill text — e.g. "DECLASSIFY", "COPIED //", "OPEN CHANNEL".
  static final TextStyle labelPill = GoogleFonts.jetBrainsMono(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: AppTextColors.subtle,
    letterSpacing: 1.5,
  );

  /// Dropdown menu item text.
  static final TextStyle labelMenuItem = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppTextColors.secondary,
    letterSpacing: 2.5,
    decoration: TextDecoration.none,
  );

  /// Footer / metadata — e.g. "CLEARANCE LEVEL: OPEN", "FILE REF: MW-2026".
  static final TextStyle labelMeta = GoogleFonts.jetBrainsMono(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: AppTextColors.subtle,
    letterSpacing: 2.0,
  );

  // ── Mono — JetBrains Mono (data / terminal body) ─────────────────────────

  /// Data value — email address, LinkedIn handle, file name.
  static final TextStyle monoData = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppTextColors.secondary,
    letterSpacing: 0.5,
  );

  /// Inline code / code blocks in markdown.
  static final TextStyle monoCode = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppTextColors.primary,
    letterSpacing: 0,
  );

  // ── Body — Inter ───────────────────────────────────────────────────────────

  /// Primary paragraph text — bio, project descriptions.
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppTextColors.primary,
    height: 1.65,
  );

  /// Smaller supporting body — stat values, card details.
  static final TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppTextColors.secondary,
    height: 1.5,
  );

  /// Emphasised body — bold inline text.
  static final TextStyle bodyBold = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppTextColors.primary,
    height: 1.65,
  );

  // ── Material TextTheme mapping ─────────────────────────────────────────────
  // Maps semantic Flutter TextTheme slots to the above styles so that
  // widgets using Theme.of(context).textTheme.* pick up the right font.

  static final TextTheme theme = TextTheme(
    // Display → Oxanium
    displayLarge:   display.copyWith(fontSize: 56),
    displayMedium:  display.copyWith(fontSize: 48),
    displaySmall:   display.copyWith(fontSize: 42),

    // Headline → Oxanium
    headlineLarge:  displayHeadline.copyWith(fontSize: 40),
    headlineMedium: displayHeadline.copyWith(fontSize: 36),
    headlineSmall:  displayHeadline.copyWith(fontSize: 32),

    // Title → JetBrains Mono (UI labels)
    titleLarge:     labelSection.copyWith(fontSize: 30),
    titleMedium:    labelSection.copyWith(fontSize: 26),
    titleSmall:     labelField.copyWith(fontSize: 22),

    // Body → Inter
    bodyLarge:      body.copyWith(fontSize: 17),
    bodyMedium:     body,
    bodySmall:      bodySmall,

    // Label → JetBrains Mono
    labelLarge:     labelNav.copyWith(fontSize: 13),
    labelMedium:    labelNav,
    labelSmall:     labelMeta,
  );
}
