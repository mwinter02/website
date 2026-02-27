import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../sources.dart';
import '../theme/custom_icons.dart';
import '../theme/text_theme.dart';
import 'dynamic_widget.dart';

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
  LanguageBadgeData(
    label: 'C++',
    fallbackIcon: CustomIcons.cPlusPlus,
    color: Color(0xFF00599C),
  ),
  LanguageBadgeData(
    label: 'Java',
    fallbackIcon: FontAwesomeIcons.java,
    color: Color(0xFFED8B00),
  ),
  LanguageBadgeData(
    label: 'Python',
    fallbackIcon: FontAwesomeIcons.python,
    color: Color(0xFFFFE873),
  ),
  LanguageBadgeData(
    label: 'Flutter',
    fallbackIcon: FontAwesomeIcons.flutter,
    color: Color(0xFF0075FF),
  ),
  LanguageBadgeData(
    label: 'Dart',
    fallbackIcon: FontAwesomeIcons.dartLang,
    color: Color(0xFF0175C2),
  ),
  LanguageBadgeData(
    label: 'JavaScript',
    fallbackIcon: FontAwesomeIcons.js,
    color: Color(0xFFFFEA00),
  ),
  LanguageBadgeData(
    label: 'React',
    fallbackIcon: FontAwesomeIcons.react,
    color: Color(0xFF00F7FF),
  ),
  LanguageBadgeData(
    label: 'HTML',
    fallbackIcon: FontAwesomeIcons.html5,
    color: Color(0xFFE44D26),
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// ProfileCard  (root widget – replace or extend as needed)
// ─────────────────────────────────────────────────────────────────────────────

class ProfileCard extends DynamicWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;
  final List<LanguageBadgeData> badges;
  final ImageProvider profileImage;

  const ProfileCard({
    super.key,
    this.name = 'Marcus Winter',
    this.title = 'Software Engineer',
    this.education = 'M.Sc. Computer Science — Brown University',
    this.interests = const [
      'Game Development',
      'Computer Graphics',
      'Full-Stack Development',
    ],
    this.badges = _defaultBadges,
    this.profileImage = const AssetImage(AssetSources.picProfile),
  });

  static const double _desktopAspectRatio = 16 / 7;

  // Shared inner card — _FlippableCard dispatches mobile/desktop internally.
  _FlippableCard _flippableCard() => _FlippableCard(
    name: name,
    title: title,
    education: education,
    interests: interests,
    badges: badges,
    profileImage: profileImage,
  );

  @override
  Widget desktopView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860, minWidth: 320),
        child: AspectRatio(
          aspectRatio: _desktopAspectRatio,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 860,
              height: 860 / _desktopAspectRatio,
              child: _flippableCard(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget mobileView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: _flippableCard(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MobileCard  –  vertical single-column layout for narrow screens
// ─────────────────────────────────────────────────────────────────────────────

class _MobileCard extends StatelessWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;
  final List<LanguageBadgeData> badges;
  final ImageProvider profileImage;

  const _MobileCard({
    required this.name,
    required this.title,
    required this.education,
    required this.interests,
    required this.badges,
    required this.profileImage,
  });

  // The card is authored for this reference width. Below it everything scales.
  static const double _referenceWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Scale factor: 1.0 at reference width, shrinks proportionally below it.
        final s = (constraints.maxWidth / _referenceWidth).clamp(0.6, 1.2);

        return Container(
          decoration: BoxDecoration(
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16 * s),
              // ── Tap hint — top right ──────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_TapToFlip()],
                ),
              ),
              SizedBox(height: 8 * s),
              // ── Avatar ────────────────────────────────────────────────────
              _ScaledProfileAvatar(image: profileImage, scale: s),
              SizedBox(height: 16 * s),
              // ── Name + title chip ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.displayName.copyWith(
                        fontSize: 20 * s,
                      ),
                    ),
                    SizedBox(height: 6 * s),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10 * s,
                        vertical: 3 * s,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.deepPurpleAccent.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        title,
                        style: AppTextTheme.displaySubtitle.copyWith(
                          fontSize: 12 * s,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14 * s),
              // ── Detail rows ───────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * s),
                child: Column(
                  children: [
                    _ScaledDetailRow(
                      icon: Icons.school_outlined,
                      text: education,
                      scale: s,
                    ),
                    SizedBox(height: 6 * s),
                    _ScaledDetailRow(
                      icon: Icons.interests_outlined,
                      text: interests.join(' · '),
                      scale: s,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16 * s),
              // ── Badge grid ────────────────────────────────────────────────
              const _CardDivider(label: 'LANGUAGES & TECHNOLOGIES'),
              _MobileBadgeGrid(badges: badges, scale: s),
              SizedBox(height: 16 * s),
            ],
          ),
        );
      },
    );
  }
}

// Scaled avatar — radius driven by scale factor.
class _ScaledProfileAvatar extends StatelessWidget {
  final ImageProvider image;
  final double scale;

  const _ScaledProfileAvatar({required this.image, required this.scale});

  @override
  Widget build(BuildContext context) {
    final radius = 54.0 * scale;
    return Container(
      padding: EdgeInsets.all(3 * scale),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const SweepGradient(
          colors: [
            Colors.deepPurpleAccent,
            Colors.purpleAccent,
            Colors.deepPurpleAccent,
          ],
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
        radius: radius,
        backgroundImage: image,
        backgroundColor: const Color(0xFF1A0533),
      ),
    );
  }
}

// Scaled detail row — icon size and font driven by scale factor.
class _ScaledDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final double scale;

  const _ScaledDetailRow({
    required this.icon,
    required this.text,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16 * scale, color: Colors.deepPurpleAccent.shade100),
        SizedBox(width: 8 * scale),
        Expanded(
          child: Text(
            text,
            style: AppTextTheme.bodySmall.copyWith(fontSize: 13 * scale),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _MobileBadgeGrid  –  wrapping Wrap instead of a horizontal scroll row
// ─────────────────────────────────────────────────────────────────────────────

class _MobileBadgeGrid extends StatelessWidget {
  final List<LanguageBadgeData> badges;
  final double scale;

  const _MobileBadgeGrid({required this.badges, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16 * scale, 12 * scale, 16 * scale, 0),
      child: Wrap(
        spacing: 10 * scale,
        runSpacing: 10 * scale,
        alignment: WrapAlignment.center,
        children: badges
            .map((b) => LanguageBadge(data: b, scale: scale))
            .toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FlippableCard  –  owns the flip animation and dispatches mobile/desktop
//                   faces via DynamicStatefulWidget.
// ─────────────────────────────────────────────────────────────────────────────

class _FlippableCard extends DynamicStatefulWidget {
  final String name;
  final String title;
  final String education;
  final List<String> interests;
  final List<LanguageBadgeData> badges;
  final ImageProvider profileImage;

  const _FlippableCard({
    required this.name,
    required this.title,
    required this.education,
    required this.interests,
    required this.badges,
    required this.profileImage,
  });

  @override
  DynamicState<_FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends DynamicState<_FlippableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _angle;

  // Tracks the last rendered layout mode so we can react to resizes.
  bool? _wasMobile;

  bool get _showingBack => _ctrl.value >= 0.5;

  void _flip() {
    if (_showingBack) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _angle = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Called at the top of build(). If the layout mode has changed since the
  /// last frame, snap back to the front face and invalidate the mobile height
  /// measurement so it is re-taken in the new layout.
  void _handleModeChange(bool isMobile) {
    if (_wasMobile == isMobile) return;
    _wasMobile = isMobile;
    // Snap the flip to the front face immediately (no animation).
    _ctrl.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < kMobileBreakpoint;
    _handleModeChange(isMobile);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _flip,
        child: isMobile
            ? _buildMobileFlip(context)
            : _buildDesktopFlip(context),
      ),
    );
  }

  // Desktop flip — unchanged.
  Widget _buildDesktopFlip(BuildContext context) {
    return AnimatedBuilder(
      animation: _angle,
      builder: (context, _) {
        final showBack = _ctrl.value >= 0.5;
        final faceAngle = showBack ? _angle.value - pi : _angle.value;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(faceAngle),
          child: showBack ? _backFace() : desktopView(context),
        );
      },
    );
  }

  // Mobile flip — IndexedStack sizes to the tallest face and keeps both
  // laid out at all times, so the card height never changes during the flip.
  Widget _buildMobileFlip(BuildContext context) {
    final front = mobileView(context);
    final back  = _TrainerCardBack(name: widget.name, title: widget.title);

    return AnimatedBuilder(
      animation: _angle,
      builder: (context, _) {
        final showBack = _ctrl.value >= 0.5;
        final faceAngle = showBack ? _angle.value - pi : _angle.value;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(faceAngle),
          // IndexedStack keeps both children laid out (so height = max of both)
          // but only paints the active index.
          child: IndexedStack(
            index: showBack ? 1 : 0,
            children: [front, back],
          ),
        );
      },
    );
  }


  Widget _backFace() =>
      _TrainerCardBack(name: widget.name, title: widget.title);

  // ── DynamicState interface ────────────────────────────────────────────────

  @override
  Widget desktopView(BuildContext context) => _TrainerCard(
    name: widget.name,
    title: widget.title,
    education: widget.education,
    interests: widget.interests,
    badges: widget.badges,
    profileImage: widget.profileImage,
  );

  @override
  Widget mobileView(BuildContext context) => _MobileCard(
    name: widget.name,
    title: widget.title,
    education: widget.education,
    interests: widget.interests,
    badges: widget.badges,
    profileImage: widget.profileImage,
  );
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
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
            const SizedBox(height: 4),
            _TapToFlip(),
            _CardHeader(
              name: name,
              title: title,
              education: education,
              interests: interests,
              profileImage: profileImage,
            ),

            const Spacer(),
            const _CardDivider(label: 'LANGUAGES & TECHNOLOGIES'),
            _BadgeRow(badges: badges),
            // Flexible spacer absorbs any sub-pixel rounding rather than
            // reporting an overflow.
            const Flexible(child: SizedBox(height: 18)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TrainerCardBack  –  the reverse side shown after the flip
// ─────────────────────────────────────────────────────────────────────────────

class _TrainerCardBack extends StatelessWidget {
  final String name;
  final String title;

  static const String _bio =
"""
I'm a software engineer with a passion for game development, computer graphics, and full-stack development. I am finishing a Master's degree in Computer Science from Brown University this semester, where I specialized in visual computing and AI. I've created projects ranging from indie games to full-stack applications. I'm always eager to learn new technologies and take on challenging problems that push the boundaries of what's possible in software.
Seeking job opportunities that allow me to apply my skills in a collaborative environment and contribute to innovative projects. Feel free to reach out if you'd like to connect or learn more about my work!

""";
  static const List<_StatItem> _stats = [

    _StatItem(label: 'Software engineering\nexperience', value: '5+ Years'),
    _StatItem(label: 'Favorite language', value: 'C++'),

  ];

  const _TrainerCardBack({
    required this.name,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded = constraints.hasBoundedHeight;
        final height = bounded ? constraints.maxHeight : null;

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF311B92), Color(0xFF1A0533)],
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
            child: bounded ? _boundedLayout() : _unboundedLayout(),
          ),
        );
      },
    );
  }

  // ── Bounded layout (desktop + mobile-flip) ────────────────────────────────
  // Expanded + SingleChildScrollView ensures the bio fills available space
  // and scrolls if the content is taller than the locked height.

  Widget _boundedLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 10),
        const _CardDivider(label: 'BIO'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 14, 28, 8),
            child: Text(
              _bio,
              style: AppTextTheme.body.copyWith(fontSize: 12.5),
            ),
          ),
        ),
        const _CardDivider(label: 'AT A GLANCE'),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 14, 28, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _stats.map((s) => _StatBadge(item: s)).toList(),
          ),
        ),
      ],
    );
  }

  // ── Unbounded layout — fallback, content determines height ────────────────

  Widget _unboundedLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final s = (constraints.maxWidth / 360.0).clamp(0.6, 1.2);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SizedBox(height: 10 * s),
            const _CardDivider(label: 'BIO'),
            Padding(
              padding: EdgeInsets.fromLTRB(20 * s, 14 * s, 20 * s, 0),
              child: Text(
                _bio,
                style: AppTextTheme.body.copyWith(fontSize: 13 * s),
              ),
            ),
            SizedBox(height: 16 * s),
            const _CardDivider(label: 'AT A GLANCE'),
            Padding(
              padding: EdgeInsets.fromLTRB(20 * s, 16 * s, 20 * s, 20 * s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _stats.map((s) => _StatBadge(item: s)).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Shared header ─────────────────────────────────────────────────────────

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextTheme.displayName,
                ),
                const SizedBox(height: 6),
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
                    style: AppTextTheme.displaySubtitle,
                  ),
                ),
              ],
            ),
          ),
          _TapToFlip(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatItem / _StatBadge  –  small "at a glance" numbers on the back face
// ─────────────────────────────────────────────────────────────────────────────

class _TapToFlip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.touch_app_outlined, size: 13, color: Colors.white24),
        const SizedBox(width: 4),
        Text(
          'TAP TO FLIP',
          style: AppTextTheme.labelField.copyWith(color: AppTextColors.subtle),
        ),
      ],
    );
  }
}

class _StatItem {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});
}

class _StatBadge extends StatelessWidget {
  final _StatItem item;

  const _StatBadge({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.value,
          style: AppTextTheme.displayName.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 3),
        Text(
          item.label,
          style: AppTextTheme.labelField,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TrainerCard  (name, photo, details)
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
          Expanded(
            child: _ProfileDetails(
              name: name,
              title: title,
              education: education,
              interests: interests,
            ),
          ),
          const SizedBox(width: 28),
          // Right column: tap hint above the avatar
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // _TapToFlip(),
              // const SizedBox(height: 10),
              _ProfileAvatar(image: profileImage),
            ],
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
          colors: [
            Colors.deepPurpleAccent,
            Colors.purpleAccent,
            Colors.deepPurpleAccent,
          ],
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
        radius: 80,
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
        // Name
        Text(
          name,
          style: AppTextTheme.displayName.copyWith(fontSize: 26),
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
            style: AppTextTheme.displaySubtitle.copyWith(fontSize: 13),
          ),
        ),
        const SizedBox(height: 14),
        _DetailRow(icon: Icons.school_outlined, text: education),
        const SizedBox(height: 8),
        _DetailRow(icon: Icons.interests_outlined, text: interests.join(' · ')),
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
            style: AppTextTheme.bodySmall.copyWith(fontSize: 13.5),
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
              style: AppTextTheme.labelField.copyWith(
                fontSize: 11,
                color: AppTextColors.accent,
                letterSpacing: 2.5,
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
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: badges.map((b) => LanguageBadge(data: b)).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LanguageBadge  (public – easy to animate/style independently later)
// ─────────────────────────────────────────────────────────────────────────────

class LanguageBadge extends StatefulWidget {
  final LanguageBadgeData data;
  final double scale;

  const LanguageBadge({super.key, required this.data, this.scale = 1.0});

  @override
  State<LanguageBadge> createState() => _LanguageBadgeState();
}

class _LanguageBadgeState extends State<LanguageBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.data.color;
    final s = widget.scale;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        // Max width set by scale; never forced wider than available space.
        constraints: BoxConstraints(maxWidth: 72 * s),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10 * s),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _hovered
              ? color.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: _hovered ? color : Colors.white.withValues(alpha: 0.12),
            width: 1.4,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.all(10 * s),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: _hovered ? 0.30 : 0.15),
              ),
              child: widget.data.assetPath != null
                  ? SvgPicture.asset(
                      widget.data.assetPath!,
                      colorFilter: ColorFilter.mode(
                        _hovered ? color : Colors.white54,
                        BlendMode.srcIn,
                      ),
                      width: 24 * s,
                      height: 24 * s,
                    )
                  : Icon(
                      widget.data.fallbackIcon ?? Icons.code,
                      size: 24 * s,
                      color: _hovered ? color : Colors.white54,
                    ),
            ),
            SizedBox(height: 6 * s),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.data.label,
                textAlign: TextAlign.center,
                style: AppTextTheme.labelField.copyWith(
                  fontSize: 11 * s,
                  color: _hovered ? AppTextColors.bright : AppTextColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
