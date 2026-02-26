import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../sources.dart';
import '../theme/text_theme.dart';
import 'dynamic_widget.dart';
import 'site_widgets.dart';

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
const String _linkedInHandle = 'linkedin.com/in/mwinter02';
const String _cvAssetPath    = 'assets/Resume - Marcus Winter.pdf';

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
                style: AppTextTheme.labelPrompt,
              ),
              Text(
                'CONTACT_DETAILS',
                style: AppTextTheme.labelSection,
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
                color: AppTextColors.danger.withValues(alpha: 0.6),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'CLASSIFIED',
              style: AppTextTheme.labelPill.copyWith(
                color: AppTextColors.danger.withValues(alpha: 0.8),
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
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left stamp column
        _SubjectStamp(),
        SizedBox(width: 32),
        // Right channels
        Expanded(child: _ChannelList()),
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
          Text('SUBJECT', style: AppTextTheme.labelField),
          const SizedBox(height: 6),
          Text('Marcus Winter', style: AppTextTheme.displayName),
          const SizedBox(height: 4),
          Text(
            'Software Engineer',
            style: AppTextTheme.displaySubtitle,
          ),
          const SizedBox(height: 16),
          // Availability stamp — rotated, semi-transparent
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTextColors.terminal.withValues(alpha: 0.7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'AVAILABLE',
              style: AppTextTheme.labelPill.copyWith(
                fontSize: 13,
                color: AppTextColors.terminal.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EmailChannel(),
        Separator(),
        _LinkedInChannel(),
        Separator(),
        _CvChannel(),
      ],
    );
  }
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
          accentColor: AppTextColors.accent,
          valueWidget: Row(
            children: [
              // Redacted ↔ revealed text
              Flexible(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Text(
                    _emailDisplay,
                    key: ValueKey(_hovered || _copied),
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.monoData.copyWith(
                      color: _hovered
                          ? AppTextColors.bright
                          : AppTextColors.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Action pill — fixed size, never shrinks
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _copied
                      ? AppTextColors.terminal.withValues(alpha: 0.15)
                      : _hovered
                          ? AppTextColors.accent.withValues(alpha: 0.15)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: _copied
                        ? AppTextColors.terminal.withValues(alpha: 0.6)
                        : _hovered
                            ? AppTextColors.accent.withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  _copied ? 'COPIED //' : 'COPY',
                  style: AppTextTheme.labelPill.copyWith(
                    color: _copied
                        ? AppTextColors.terminal
                        : _hovered
                            ? AppTextColors.accent
                            : AppTextColors.subtle,
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
        onTap: () => launchUrl(Sources.linkedInLaunchUri),
        child: _ChannelRow(
          icon: FontAwesomeIcons.linkedin,
          label: 'LINKEDIN',
          accentColor: AppTextColors.linkedIn,
          valueWidget: Row(
            children: [
              Flexible(
                child: Text(
                  _linkedInHandle,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.monoData.copyWith(
                    color: _hovered ? AppTextColors.bright : AppTextColors.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _hovered
                      ? AppTextColors.linkedIn.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: _hovered
                        ? AppTextColors.linkedIn.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  'CONNECT',
                  style: AppTextTheme.labelPill.copyWith(
                    color: _hovered ? AppTextColors.linkedIn : AppTextColors.subtle,
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
          label: 'RESUME',
          accentColor: AppTextColors.amber,
          valueWidget: Row(
            children: [
              Flexible(
                child: Text(
                  'resume_marcus_winter.pdf',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.monoData.copyWith(
                    color: _hovered ? AppTextColors.bright : AppTextColors.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _hovered
                      ? AppTextColors.amber.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: _hovered
                        ? AppTextColors.amber.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  'DOWNLOAD',
                  style: AppTextTheme.labelPill.copyWith(
                    color: _hovered ? AppTextColors.amber : AppTextColors.subtle,
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
// On wide screens: icon | label | value+pill on one line.
// On narrow screens: icon + label on line 1, value+pill on line 2.
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
    return LayoutBuilder(builder: (context, constraints) {
      final narrow = constraints.maxWidth < 480;

      final iconBox = Container(
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
      );

      final labelText = Text(label, style: AppTextTheme.labelField);

      if (narrow) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Line 1: icon + label
            Row(
              children: [
                iconBox,
                const SizedBox(width: 10),
                labelText,
              ],
            ),
            const SizedBox(height: 8),
            // Line 2: value + pill, allowed to use full width
            valueWidget,
          ],
        );
      }

      // Wide: single row
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconBox,
          const SizedBox(width: 14),
          SizedBox(width: 130, child: labelText),
          Expanded(child: valueWidget),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ClearanceFooter
// ─────────────────────────────────────────────────────────────────────────────

class _ClearanceFooter extends DynamicWidget {
  const _ClearanceFooter();

  @override
  Widget desktopView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: LayoutBuilder(builder: (context, constraints) {
        final status = Text(
          'STATUS: AVAILABLE FOR HIRE',
          style: AppTextTheme.labelMeta.copyWith(
            color: AppTextColors.terminal.withValues(alpha: 0.4),
          ),
        );
        final fileRef = Text(
          'FILE REF: MW-2026',
          style: AppTextTheme.labelMeta,
        );
        return Row(
          children: [status, const Spacer(), fileRef],
        );
      }),
    );
  }

  @override
  Widget mobileView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: LayoutBuilder(builder: (context, constraints) {
        final status = Text(
          'STATUS: AVAILABLE FOR HIRE',
          style: AppTextTheme.labelMeta.copyWith(
            color: AppTextColors.terminal.withValues(alpha: 0.4),
          ),
        );
        final fileRef = Text(
          'FILE REF: MW-2026',
          style: AppTextTheme.labelMeta,
        );
        return Column(
          children: [status, fileRef],
        );
      }),
    );
  }
}
