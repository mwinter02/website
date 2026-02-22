import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model for a language badge
// ─────────────────────────────────────────────────────────────────────────────

class LanguageBadgeData {
  final String label;
  final String? assetPath; // optional SVG/PNG icon path
  final IconData? fallbackIcon;
  final Color color;

  const LanguageBadgeData({
    required this.label,
    this.assetPath,
    this.fallbackIcon,
    this.color = Colors.deepPurple,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Default badge set – extend freely
// ─────────────────────────────────────────────────────────────────────────────

const List<LanguageBadgeData> _defaultBadges = [
  LanguageBadgeData(label: 'C++',    fallbackIcon: FontAwesomeIcons.code,            color: Color(0xFF00599C)),
  LanguageBadgeData(label: 'Java',   fallbackIcon: FontAwesomeIcons.java,            color: Color(0xFFED8B00)),
  LanguageBadgeData(label: 'Python', fallbackIcon: FontAwesomeIcons.python,              color: Color(
      0xFFFFE873)),
  LanguageBadgeData(label: 'Flutter',     fallbackIcon: FontAwesomeIcons.flutter,               color: Color(
      0xFF0075FF)),
  LanguageBadgeData(label: 'Dart',   fallbackIcon: FontAwesomeIcons.dartLang,      color: Color(0xFF0175C2)),
  LanguageBadgeData(label: 'JavaScript',   fallbackIcon: FontAwesomeIcons.js,      color: Color(
      0xFFFFEA00)),
  LanguageBadgeData(label: 'React',    fallbackIcon: FontAwesomeIcons.react,           color: Color(
      0xFF00F7FF)),
  LanguageBadgeData(label: 'HTML',   fallbackIcon: FontAwesomeIcons.html5,              color: Color(0xFFE44D26)),
];

// ─────────────────────────────────────────────────────────────────────────────
// ProfileCard  (root widget – replace or extend as needed)
// ─────────────────────────────────────────────────────────────────────────────

class ProfileCard extends StatelessWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;
  final List<LanguageBadgeData> badges;
  final ImageProvider profileImage;

  const ProfileCard({
    super.key,
    this.name       = 'Marcus Winter',
    this.title      = 'Software Engineer',
    this.education  = 'M.Sc. Computer Science — Brown University',
    this.interests  = const [
      'Game Development',
      'Computer Graphics',
      'Full-Stack Development',
    ],
    this.badges     = _defaultBadges,
    this.profileImage = const AssetImage('assets/images/profile_picture.png'),
  });

  /// The fixed width:height ratio of the card.
  /// Tweak this constant if you want the card taller or shorter.
  static const double _aspectRatio = 16 / 7;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: ConstrainedBox(
        // Never wider than the design width, never narrower than 320 px.
        constraints: const BoxConstraints(maxWidth: 860, minWidth: 320),
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            child: SizedBox(
              // Give FittedBox a concrete reference size to scale from.
              width: 860,
              height: 860 / _aspectRatio,
              child: _TrainerCard(
                name: name,
                title: title,
                education: education,
                interests: interests,
                badges: badges,
                profileImage: profileImage,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TrainerCard  (the visual card shell)
// ─────────────────────────────────────────────────────────────────────────────

class _TrainerCard extends StatelessWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;
  final List<LanguageBadgeData> badges;
  final ImageProvider profileImage;

  const _TrainerCard({
    required this.name,
    required this.title,
    required this.education,
    required this.interests,
    required this.badges,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Deep purple gradient that echoes the site's colour scheme
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0533), Color(0xFF311B92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.deepPurpleAccent.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.55),
            blurRadius: 32,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _CardHeader(
            name: name,
            title: title,
            education: education,
            interests: interests,
            profileImage: profileImage,
          ),
          const Spacer(),
          _CardDivider(label: 'LANGUAGES & TECHNOLOGIES'),
          _BadgeRow(badges: badges),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CardHeader  (name, photo, details)
// ─────────────────────────────────────────────────────────────────────────────

class _CardHeader extends StatelessWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;
  final ImageProvider profileImage;

  const _CardHeader({
    required this.name,
    required this.title,
    required this.education,
    required this.interests,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileAvatar(image: profileImage),
          const SizedBox(width: 28),
          Expanded(
            child: _ProfileDetails(
              name: name,
              title: title,
              education: education,
              interests: interests,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileAvatar
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileAvatar extends StatelessWidget {
  final ImageProvider image;

  const _ProfileAvatar({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const SweepGradient(
          colors: [Colors.deepPurpleAccent, Colors.purpleAccent, Colors.deepPurpleAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withValues(alpha: 0.6),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 54,
        backgroundImage: image,
        backgroundColor: const Color(0xFF1A0533),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileDetails
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileDetails extends StatelessWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;

  const _ProfileDetails({
    required this.name,
    required this.title,
    required this.education,
    required this.interests,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name — Michroma to match the site header font
        Text(
          name,
          style: GoogleFonts.michroma(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        // Title chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.6),
            ),
          ),
          child: Text(
            title,
            style: GoogleFonts.electrolize(
              fontSize: 13,
              color: Colors.deepPurpleAccent.shade100,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 14),
        _DetailRow(icon: Icons.school_outlined, text: education),
        const SizedBox(height: 8),
        _DetailRow(
          icon: Icons.interests_outlined,
          text: interests.join(' · '),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DetailRow  (icon + text line)
// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.deepPurpleAccent.shade100),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 13.5,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CardDivider  (labelled separator – mimics a "gym badge" section header)
// ─────────────────────────────────────────────────────────────────────────────

class _CardDivider extends StatelessWidget {
  final String label;

  const _CardDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.deepPurpleAccent.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: GoogleFonts.electrolize(
                fontSize: 11,
                letterSpacing: 2.5,
                color: Colors.deepPurpleAccent.shade100,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
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
// _BadgeRow  (scrollable row of LanguageBadge widgets)
// ─────────────────────────────────────────────────────────────────────────────

class _BadgeRow extends StatelessWidget {
  final List<LanguageBadgeData> badges;

  const _BadgeRow({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: badges
              .map((b) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LanguageBadge(data: b),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LanguageBadge  (public – easy to animate/style independently later)
// ─────────────────────────────────────────────────────────────────────────────

class LanguageBadge extends StatefulWidget {
  final LanguageBadgeData data;

  const LanguageBadge({super.key, required this.data});

  @override
  State<LanguageBadge> createState() => _LanguageBadgeState();
}

class _LanguageBadgeState extends State<LanguageBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.data.color;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _hovered
              ? color.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: _hovered
                ? color
                : Colors.white.withValues(alpha: 0.12),
            width: 1.4,
          ),
          boxShadow: _hovered
              ? [BoxShadow(
                  color: color.withValues(alpha: 0.45),
                  blurRadius: 12,
                  spreadRadius: 1,
                )]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── icon ──────────────────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: _hovered ? 0.30 : 0.15),
              ),
              child: widget.data.assetPath != null
                  ? Image.asset(widget.data.assetPath!, width: 24, height: 24)
                  : Icon(
                      widget.data.fallbackIcon ?? Icons.code,
                      size: 24,
                      color: _hovered ? color : Colors.white54,
                    ),
            ),
            const SizedBox(height: 6),
            // ── label ─────────────────────────────────────────────────────
            Text(
              widget.data.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.electrolize(
                fontSize: 11,
                color: _hovered ? Colors.white : Colors.white60,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

