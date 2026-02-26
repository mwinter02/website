import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../sources.dart';
import '../theme/text_theme.dart';
import '../theme/theme.dart';
import 'contact_section.dart';
import 'dynamic_widget.dart';
import 'site_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AboutSection
//
// Three-panel "dossier" layout:
//   1. Photo panel   — profile photo with scanline overlay and glow border
//   2. Bio panel     — personal paragraphs with terminal-style labels
//   3. Stats panel   — character-sheet style personal stats
//
// Each panel animates in from its edge when the widget is first built.
// Desktop: three columns. Mobile: stacked vertically.
// ─────────────────────────────────────────────────────────────────────────────

class AboutSection extends DynamicWidget {
  const AboutSection({super.key});

  @override
  Widget desktopView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AboutHeader(),
        const SizedBox(height: 32),
        _DesktopLayout(),
      ],
    );
  }

  @override
  Widget mobileView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AboutHeader(),
        const SizedBox(height: 32),
        _MobileLayout(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section heading — matches the FeaturedProjects heading style
// ─────────────────────────────────────────────────────────────────────────────

class _AboutHeader extends StatelessWidget {
  const _AboutHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Colors.white54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'ABOUT',
            style: AppTextTheme.displayHeadline.copyWith(
              fontSize: 26,
              letterSpacing: 5,
              color: AppTextColors.bright,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'The person behind the keyboard',
          style: AppTextTheme.labelField.copyWith(
            fontSize: 12,
            color: AppTextColors.subtle,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop — three columns with staggered entrance animations
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Two-column row: bio (2/3) | photo+stats (1/3) ─────────────────
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left — bio panel, 2/3 width
              Expanded(
                flex: 2,
                child: _EntranceAnimation(
                  direction: _EntranceDirection.left,
                  delay: Duration.zero,
                  child: _BioPanel(),
                ),
              ),
              SizedBox(width: 20),
              // Right — photo above stats, 1/3 width
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _EntranceAnimation(
                      direction: _EntranceDirection.right,
                      delay: Duration(milliseconds: 100),
                      child: _PhotoPanel(),
                    ),
                    SizedBox(height: 20),
                    _EntranceAnimation(
                      direction: _EntranceDirection.right,
                      delay: Duration(milliseconds: 200),
                      child: _StatsPanel(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // ── Fourth panel — full width ──────────────────────────────────────
        SizedBox(height: 20),
        _EntranceAnimation(
          direction: _EntranceDirection.up,
          delay: Duration(milliseconds: 300),
          child: KnownProfilesPanel(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile — stacked vertically
// ─────────────────────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _EntranceAnimation(
          direction: _EntranceDirection.up,
          delay: Duration.zero,
          child: _PhotoPanel(),
        ),
        SizedBox(height: 20),
        _EntranceAnimation(
          direction: _EntranceDirection.up,
          delay: Duration(milliseconds: 80),
          child: _BioPanel(),
        ),
        SizedBox(height: 20),
        _EntranceAnimation(
          direction: _EntranceDirection.up,
          delay: Duration(milliseconds: 160),
          child: _StatsPanel(),
        ),
        SizedBox(height: 20),
        _EntranceAnimation(
          direction: _EntranceDirection.up,
          delay: Duration(milliseconds: 240),
          child: KnownProfilesPanel(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _EntranceAnimation — fade + slide in from a given direction
// ─────────────────────────────────────────────────────────────────────────────

enum _EntranceDirection { left, right, up }

class _EntranceAnimation extends StatefulWidget {
  final Widget child;
  final _EntranceDirection direction;
  final Duration delay;

  const _EntranceAnimation({
    required this.child,
    required this.direction,
    required this.delay,
  });

  @override
  State<_EntranceAnimation> createState() => _EntranceAnimationState();
}

class _EntranceAnimationState extends State<_EntranceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  Offset get _beginOffset {
    switch (widget.direction) {
      case _EntranceDirection.left:
        return const Offset(-0.08, 0);
      case _EntranceDirection.right:
        return const Offset(0.08, 0);
      case _EntranceDirection.up:
        return const Offset(0, 0.06);
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: _beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fade,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared panel container
// ─────────────────────────────────────────────────────────────────────────────

class _PanelContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _PanelContainer({
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF111120),
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
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Photo data
// ─────────────────────────────────────────────────────────────────────────────

class _PhotoEntry {
  final String assetPath;
  final String caption;
  final String sub;

  const _PhotoEntry({
    required this.assetPath,
    required this.caption,
    required this.sub,
  });
}

// ── Add / remove photos here. Rotations are assigned automatically. ──────────
const _photos = [
  _PhotoEntry(
    assetPath: AssetSources.picRow,
    caption: 'Race day',
    sub: 'Rhode Island',
  ),
  _PhotoEntry(
    assetPath: AssetSources.picFish,
    caption: 'Spearfishing',
    sub: 'New Zealand',
  ),
  _PhotoEntry(
    assetPath: AssetSources.picPink,
    caption: 'Training camp',
    sub: 'Florida',
  ),
  _PhotoEntry(
    assetPath: AssetSources.picTahoe,
    caption: 'Lake Tahoe',
    sub: 'California',
  ),
  _PhotoEntry(assetPath: AssetSources.picGrad,
      caption: 'Graduation',
      sub: 'Rhode Island')

];

// ─────────────────────────────────────────────────────────────────────────────
// _PhotoPanel — stacked polaroid-style cards that cycle on tap
// ─────────────────────────────────────────────────────────────────────────────

class _PhotoPanel extends StatefulWidget {
  const _PhotoPanel();

  @override
  State<_PhotoPanel> createState() => _PhotoPanelState();
}

class _PhotoPanelState extends State<_PhotoPanel>
    with SingleTickerProviderStateMixin {
  final List<_PhotoEntry> _deck = List.of(_photos);
  late final List<double> _rotations;

  int _topIndex = 0;
  bool _animating = false;

  // Single controller drives both phases sequentially via an Interval.
  // 0.0 → 0.5  : phase 1 — top card slides out to the right
  // 0.5 → 1.0  : phase 2 — card slides back in from the right, behind stack
  late final AnimationController _ctrl;

  // Fractional horizontal offset of the outgoing card, in units of its own
  // width.  Built in _cycle() so it always targets the correct card.
  late Animation<double> _slideAnim;

  int get _nextIndex => (_topIndex + 1) % _deck.length;

  // Paint order: cards further from _topIndex paint first (deepest in stack).
  List<int> _paintOrder({required bool outgoingBehind}) {
    final indices = List.generate(_deck.length, (i) => i);
    if (outgoingBehind) {
      // Outgoing card goes behind everything — paint it first.
      return [
        _topIndex,
        ...indices.where((i) => i != _topIndex).toList()..sort((a, b) {
          final da = (a - _topIndex + _deck.length) % _deck.length;
          final db = (b - _topIndex + _deck.length) % _deck.length;
          return db.compareTo(da);
        }),
      ];
    }
    // Normal: deepest slot paints first, top card paints last.
    return indices..sort((a, b) {
      final da = (a - _topIndex + _deck.length) % _deck.length;
      final db = (b - _topIndex + _deck.length) % _deck.length;
      return db.compareTo(da);
    });
  }

  @override
  void initState() {
    super.initState();

    _rotations = List.generate(_deck.length, (i) {
      final sign = i.isEven ? 1.0 : -1.0;
      final magnitude = 0.03 + (i % 3) * 0.02;
      return sign * magnitude;
    });

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Placeholder — rebuilt in _cycle() before forward() is called.
    _slideAnim = const AlwaysStoppedAnimation(0.0);

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _topIndex = _nextIndex;
          _animating = false;
        });
        _ctrl.reset();
      }
    });
  }

  void _cycle() {
    if (_animating || _deck.length < 2) return;

    // Phase 1: 0 → 1.4  (slide far enough right to clear the stack visually)
    // Phase 2: 1.4 → 0  (return from the same side, ending at rest position)
    // We animate a single offset value:
    //   phase 1 (t 0.0→0.5): offset goes 0 → +1.5
    //   phase 2 (t 0.5→1.0): offset comes +1.5 → 0
    // The card is painted behind everything in phase 2, so it slides
    // in underneath the stack.
    _slideAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.5,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50,
      ),
    ]).animate(_ctrl);

    setState(() => _animating = true);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Tap-hint ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.touch_app_outlined,
                  size: 12,
                  color: Colors.white24,
                ),
                const SizedBox(width: 5),
                Text(
                  'TAP TO CYCLE',
                  style: AppTextTheme.labelField.copyWith(
                    color: AppTextColors.subtle,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          // ── Stack ────────────────────────────────────────────────────────
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _cycle,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (context, _) {
                    final isReturning = _animating && _ctrl.value >= 0.5;
                    final paintOrder = _paintOrder(outgoingBehind: isReturning);
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: paintOrder.map(_buildCard).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
          // ── Caption ──────────────────────────────────────────────────────
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              final isReturning = _animating && _ctrl.value >= 0.5;
              return _Caption(
                entry: _deck[isReturning ? _nextIndex : _topIndex],
                opacity: const AlwaysStoppedAnimation(1.0),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int photoIndex) {
    final isOutgoing = _animating && photoIndex == _topIndex;
    final rotation = _rotations[photoIndex];

    Widget card = Transform.rotate(
      angle: rotation,
      child: _PhotoCard(entry: _deck[photoIndex]),
    );

    if (isOutgoing) {
      card = FractionalTranslation(
        translation: Offset(_slideAnim.value, 0),
        child: card,
      );
    }

    return card;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PhotoCard — a single polaroid-style card
// ─────────────────────────────────────────────────────────────────────────────

class _PhotoCard extends StatelessWidget {
  final _PhotoEntry entry;

  const _PhotoCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: ThemeColors.appBarAccent.withValues(alpha: 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // Polaroid: white/dark border on sides and bottom, thinner on top.
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(entry.assetPath, fit: BoxFit.cover),
            ),
            Positioned.fill(child: CustomPaint(painter: _ScanlinePainter())),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Caption — animatable name + status line beneath the stack
// ─────────────────────────────────────────────────────────────────────────────

class _Caption extends StatelessWidget {
  final _PhotoEntry entry;
  final Animation<double> opacity;

  const _Caption({required this.entry, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: Column(
        children: [
          Text(
            entry.caption,
            style: AppTextTheme.displayName.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTextColors.terminal,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                entry.sub,
                style: AppTextTheme.bodySmall.copyWith(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.10)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// _BioPanel
// ─────────────────────────────────────────────────────────────────────────────

class _BioPanel extends StatelessWidget {
  const _BioPanel();

  @override
  Widget build(BuildContext context) {
    return const _PanelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TerminalLabel('WHO_AM_I'),
          Separator(),
          SizedBox(height: 14),
          _BioText("""
I'm a Master's student in Computer Science at Brown University in my final semester. Since I was a kid, understanding how things work at a fundamental level has always fascinated me. 
I began my programming journey in Freshman year of University, and after my first course in object-oriented programming where we built a number of simple games, I was hooked.
Since then, I've truly found my passion creating through code — whether it's a game engine, a full stack application, or a graphics renderer. I love the way programming combines creativity, problem-solving, and technical skill, and I'm always excited to take on new challenges that push me to grow as a developer.
Most importantly, I love making things pretty AND functional. I have spent countless hours refining algorithms or tweaking visuals to get it just the way I want. I find the process deeply cathartic, and I think it shows in the final product when you genuinely care about every detail.
            """),
          SizedBox(height: 20),
          _TerminalLabel('KNOWN_ACTIVITIES'),
          SizedBox(height: 14),
          _BioText("""
Outside of coding I spend most of my time wishing I was in the water. Growing up in coastal New Zealand, I was swimming before I could walk. Before I was 12, I already was a certified scuba diver and had speared my first dozen fish. Every summer I look forward to getting back in the water, whether it's diving for lobster, spearfishing for dinner, or just snorkeling and admiring what the ocean has to offer. 
Going above the surface, I also spent the last 10 years rowing competitively. Most recently, I rowed Division 1 for Brown's Heavyweight Crew team. The combination of physical endurance, technical skill, discipline, and teamwork in rowing is truly unique. It's been an incredible way to push myself to my limit and have made lifelong friends in the process.
In the fleeting moments when I have free time, I maintain my other life-long passion for gaming. From nostalgic childhood favorites like Pokemon Emerald and Minecraft, to deeply compelling titles like The Witcher 3 and the Red Dead Redemption 2, I love immersing myself in rich game worlds and engaging gameplay. Video games provide unparallel experiences, and have given me both deeply emotional and engaging stories and a creative outlet in more open ended titles.
            """),
          SizedBox(height: 20),
          _TerminalLabel('CURRENT_STATUS'),
          SizedBox(height: 14),
          _BioText('''
Finishing my M.Sc. at Brown University, diving deeper into computer graphics, computer vision and AI. 
Currently looking for roles where performance and creativity intersect.,
            '''),
          SizedBox(height: 24),
          _BlinkingCursor(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatsPanel — character-sheet style personal facts
// ─────────────────────────────────────────────────────────────────────────────

class _StatsPanel extends StatelessWidget {
  const _StatsPanel();

  static const _stats = [
    _StatEntry(
      icon: Icons.location_on_outlined,
      label: 'LOCATION',
      value: 'Providence, RI',
    ),
    _StatEntry(
      icon: FontAwesomeIcons.earthOceania,
      label: 'ORIGIN',
      value: 'Auckland, New Zealand',
    ),
    _StatEntry(
        icon: Icons.language,
        label: 'LANGUAGES', value: 'English, Swedish'
    ),
    _StatEntry(icon: Icons.rowing, label: 'SPORT', value: 'Rowing'),
    _StatEntry(
      icon: Icons.videogame_asset_outlined,
      label: 'CURRENTLY PLAYING',
      value: 'Pokemon Emerald',
    ),
    _StatEntry(
      icon: Icons.videogame_asset,
      label: 'TOP GAMES',
      value: 'Binding of Isaac\nTerraria\nWitcher 3\nSkyrim\nMinecraft',
    ),
    _StatEntry(
      icon: Icons.scuba_diving,
      label: 'OBSESSION',
      value: 'Spearfishing',
    ),
    _StatEntry(
      icon: Icons.music_note_outlined,
      label: 'SOUNDTRACK',
      value: 'Of Monster\'s and Men',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _PanelContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TerminalLabel('CHARACTER_INFO'),
          const SizedBox(height: 16),
          ..._stats.map((s) => _StatRow(entry: s)),
        ],
      ),
    );
  }
}

class _StatEntry {
  final IconData icon;
  final String label;
  final String value;

  const _StatEntry({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _StatRow extends StatelessWidget {
  final _StatEntry entry;

  const _StatRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(entry.icon, size: 15, color: ThemeColors.appBarAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.label, style: AppTextTheme.labelField),
                const SizedBox(height: 1),
                Text(entry.value, style: AppTextTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared text widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TerminalLabel extends StatelessWidget {
  final String text;

  const _TerminalLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('> ', style: AppTextTheme.labelPrompt),
        Text(text,  style: AppTextTheme.labelSection),
      ],
    );
  }
}

class _BioText extends StatelessWidget {
  final String text;

  const _BioText(this.text);

  @override
  Widget build(BuildContext context) => Text(text, style: AppTextTheme.body);
}

// ─────────────────────────────────────────────────────────────────────────────
// _BlinkingCursor
// ─────────────────────────────────────────────────────────────────────────────

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _ctrl,
    child: Text('▋', style: AppTextTheme.labelPrompt.copyWith(fontSize: 14)),
  );
}
