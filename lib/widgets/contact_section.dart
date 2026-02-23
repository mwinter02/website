import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../links.dart';
import '../theme/theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// KnownProfilesPanel
//
// Full-width fourth panel of the dossier layout.
// Presents contact channels as "known profiles" discovered on the subject,
// consistent with the classified-document aesthetic of the About section.
//
// Channels:
//   EMAIL      — redacted by default, declassified on hover, copies on tap
//   LINKEDIN   — opens in new tab
//   CV         — download / open CV asset (labelled "REQUEST DOSSIER")
//
// Layout:
//   Left  — section label + stamp
//   Right — channel rows + clearance footer
// ─────────────────────────────────────────────────────────────────────────────

// ── Tune these to match your details ────────────────────────────────────────
const String _emailDisplay   = 'marcuswinter2002@gmail.com';
const String _emailRedacted  = 'm█████████████@gmail.com';
const String _linkedInHandle = '/in/mwinter02';
const String _cvAssetPath    = 'assets/cv.pdf'; // swap when ready

class KnownProfilesPanel extends StatelessWidget {
  const KnownProfilesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header bar ──────────────────────────────────────────────────
          _HeaderBar(),
          // ── Divider ─────────────────────────────────────────────────────
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.06),
          ),
          // ── Channel rows ─────────────────────────────────────────────────
          LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth >= 700;
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: wide
                  ? _WideChannels()
                  : _NarrowChannels(),
            );
          }),
          // ── Divider ─────────────────────────────────────────────────────
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.06),
          ),
          // ── Clearance footer ─────────────────────────────────────────────
          const _ClearanceFooter(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HeaderBar
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Terminal label
          Row(
            children: [
              Text(
                '> ',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: const Color(0xFF69FF47),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'KNOWN_PROFILES',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: ThemeColors.appBarAccent,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Faint horizontal rule
          Expanded(
            child: Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          const SizedBox(width: 16),
          // [CLASSIFIED] badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFFF3B3B).withValues(alpha: 0.6),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'CLASSIFIED',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: const Color(0xFFFF3B3B).withValues(alpha: 0.8),
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Channel layouts
// ─────────────────────────────────────────────────────────────────────────────

class _WideChannels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left stamp column
        const _SubjectStamp(),
        const SizedBox(width: 32),
        // Right channels
        const Expanded(child: _ChannelList()),
      ],
    );
  }
}

class _NarrowChannels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SubjectStamp(),
        SizedBox(height: 24),
        _ChannelList(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SubjectStamp — name + availability stamp, left side
// ─────────────────────────────────────────────────────────────────────────────

class _SubjectStamp extends StatelessWidget {
  const _SubjectStamp();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUBJECT',
            style: GoogleFonts.electrolize(
              fontSize: 9,
              color: Colors.white24,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Marcus Winter',
            style: GoogleFonts.michroma(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Software Engineer',
            style: GoogleFonts.electrolize(
              fontSize: 11,
              color: Colors.white38,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          // Availability stamp — rotated, semi-transparent
          Transform.rotate(
            angle: -0.18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF00E676).withValues(alpha: 0.7),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                'AVAILABLE',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: const Color(0xFF00E676).withValues(alpha: 0.7),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ChannelList — the three contact rows
// ─────────────────────────────────────────────────────────────────────────────

class _ChannelList extends StatelessWidget {
  const _ChannelList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _EmailChannel(),
        _Separator(),
        _LinkedInChannel(),
        _Separator(),
        _CvChannel(),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) => Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white.withValues(alpha: 0.05),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// _EmailChannel — redacted by default, hover to reveal, tap to copy
// ─────────────────────────────────────────────────────────────────────────────

class _EmailChannel extends StatefulWidget {
  const _EmailChannel();

  @override
  State<_EmailChannel> createState() => _EmailChannelState();
}

class _EmailChannelState extends State<_EmailChannel> {
  bool _hovered  = false;
  bool _copied   = false;

  Future<void> _copy() async {
    await Clipboard.setData(const ClipboardData(text: _emailDisplay));
    setState(() => _copied = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _copy,
        child: _ChannelRow(
          icon: Icons.mail_outline,
          label: 'EMAIL',
          accentColor: ThemeColors.appBarAccent,
          valueWidget: Row(
            children: [
              // Redacted ↔ revealed text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  _hovered || _copied ? _emailDisplay : _emailRedacted,
                  key: ValueKey(_hovered || _copied),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: _hovered
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.45),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Action pill
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _copied
                      ? const Color(0xFF00E676).withValues(alpha: 0.15)
                      : _hovered
                          ? ThemeColors.appBarAccent.withValues(alpha: 0.15)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: _copied
                        ? const Color(0xFF00E676).withValues(alpha: 0.6)
                        : _hovered
                            ? ThemeColors.appBarAccent.withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  _copied ? 'COPIED //' : 'DECLASSIFY',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    letterSpacing: 1.5,
                    color: _copied
                        ? const Color(0xFF00E676)
                        : _hovered
                            ? ThemeColors.appBarAccent
                            : Colors.white24,
                  ),
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
// _LinkedInChannel
// ─────────────────────────────────────────────────────────────────────────────

class _LinkedInChannel extends StatefulWidget {
  const _LinkedInChannel();

  @override
  State<_LinkedInChannel> createState() => _LinkedInChannelState();
}

class _LinkedInChannelState extends State<_LinkedInChannel> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(linkedInLaunchUri),
        child: _ChannelRow(
          icon: FontAwesomeIcons.linkedin,
          label: 'LINKEDIN',
          accentColor: const Color(0xFF0A66C2),
          valueWidget: Row(
            children: [
              Text(
                _linkedInHandle,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: _hovered ? Colors.white : Colors.white.withValues(alpha: 0.55),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _hovered
                      ? const Color(0xFF0A66C2).withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: _hovered
                        ? const Color(0xFF0A66C2).withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  'OPEN CHANNEL',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    letterSpacing: 1.5,
                    color: _hovered
                        ? const Color(0xFF0A66C2)
                        : Colors.white24,
                  ),
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
// _CvChannel — "REQUEST DOSSIER"
// ─────────────────────────────────────────────────────────────────────────────

class _CvChannel extends StatefulWidget {
  const _CvChannel();

  @override
  State<_CvChannel> createState() => _CvChannelState();
}

class _CvChannelState extends State<_CvChannel> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(_cvAssetPath)),
        child: _ChannelRow(
          icon: Icons.file_download_outlined,
          label: 'CURRICULUM VITAE',
          accentColor: const Color(0xFFFFD600),
          valueWidget: Row(
            children: [
              Text(
                'cv_marcus_winter.pdf',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: _hovered ? Colors.white : Colors.white.withValues(alpha: 0.55),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _hovered
                      ? const Color(0xFFFFD600).withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: _hovered
                        ? const Color(0xFFFFD600).withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  'REQUEST DOSSIER',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    letterSpacing: 1.5,
                    color: _hovered
                        ? const Color(0xFFFFD600)
                        : Colors.white24,
                  ),
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
// _ChannelRow — shared layout for each contact entry
// ─────────────────────────────────────────────────────────────────────────────

class _ChannelRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final Widget valueWidget;

  const _ChannelRow({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Accent icon
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Icon(icon, size: 15, color: accentColor.withValues(alpha: 0.8)),
        ),
        const SizedBox(width: 14),
        // Label column
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: GoogleFonts.electrolize(
              fontSize: 9,
              color: Colors.white30,
              letterSpacing: 2.5,
            ),
          ),
        ),
        // Value + action
        Expanded(child: valueWidget),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ClearanceFooter
// ─────────────────────────────────────────────────────────────────────────────

class _ClearanceFooter extends StatelessWidget {
  const _ClearanceFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Text(
            'CLEARANCE LEVEL: OPEN',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: Colors.white.withValues(alpha: 0.15),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 24),
          Container(width: 1, height: 10, color: Colors.white12),
          const SizedBox(width: 24),
          Text(
            'STATUS: AVAILABLE FOR HIRE',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: const Color(0xFF00E676).withValues(alpha: 0.4),
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          Text(
            'FILE REF: MW-2026',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: Colors.white12,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

