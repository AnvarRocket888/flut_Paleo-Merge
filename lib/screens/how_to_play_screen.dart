import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// How to Play screen — animated expandable sections explaining all game mechanics.
class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            '✕',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
            ),
          ),
        ),
        middle: Text(
          'How to Play',
          style: AppTextStyles.headlineSmall,
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          children: [
            // Hero intro
            _HeroIntro()
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: -0.15, end: 0, duration: 500.ms, curve: Curves.easeOut),

            const SizedBox(height: 24),

            // Sections
            ..._sections.asMap().entries.map((entry) {
              final i = entry.key;
              final s = entry.value;
              return _ExpandableSection(
                section: s,
                delay: Duration(milliseconds: 120 + i * 80),
              );
            }),
          ],
        ),
      ),
    );
  }

  static final List<_SectionData> _sections = [
    _SectionData(
      emoji: '🦴',
      title: 'Collecting Bones',
      accentColor: AppColors.mesozoic,
      steps: [
        _StepData('⏱', 'A new fossil bone spawns every 30 seconds.'),
        _StepData('📦', 'Your inventory holds up to 50 bones. Collect them before it fills up!'),
        _StepData('❄️', 'During Bone Frenzy, bones spawn 2× faster — watch for the frenzy badge.'),
        _StepData('💤', 'While you\'re offline, up to 2 hours of bones accumulate waiting for you.'),
      ],
    ),
    _SectionData(
      emoji: '👆',
      title: 'Selecting Bones',
      accentColor: AppColors.iceAge,
      steps: [
        _StepData('👆', 'Tap a bone card to select it. Up to 3 bones can be selected at once.'),
        _StepData('✅', 'Selected bones are highlighted with a glow and a checkmark.'),
        _StepData('🔨', 'Long-press a bone to open actions: disassemble it into ✨ Dust.'),
        _StepData('🔁', 'Tap a selected bone again to deselect it.'),
      ],
    ),
    _SectionData(
      emoji: '⚗️',
      title: 'Dust & Crafting',
      accentColor: AppColors.dust,
      steps: [
        _StepData('🔨', 'Long-press any bone → Disassemble to turn it into ✨ Dust.'),
        _StepData('💎', 'Rarer bones give more dust: Common = 1, Uncommon = 2, Rare = 5, Epic = 15, Legendary = 50.'),
        _StepData('⚗️', 'Tap the "Craft from Dust" button at the bottom of the home screen.'),
        _StepData('🎯', 'Choose a Bone Type, Epoch, and Rarity — then spend dust to craft exactly the bone you need.'),
      ],
    ),
    _SectionData(
      emoji: '🔮',
      title: 'Merging into Chimeras',
      accentColor: AppColors.primary,
      steps: [
        _StepData('🗂', 'Go to the Forge tab (bottom navigation, alchemy symbol).'),
        _StepData('🦴', 'Pick 3 bones from your inventory — they must all be from the same Epoch.'),
        _StepData('✨', 'Tap "Forge" — the bones combine into a legendary Chimera!'),
        _StepData('💰', 'Each Chimera passively earns coins every minute. The rarer the bones, the more income.'),
        _StepData('🏆', 'Collect all 5 Chimeras of an Epoch to trigger a special Event with big bonuses.'),
      ],
    ),
    _SectionData(
      emoji: '💰',
      title: 'Passive Income',
      accentColor: AppColors.coinGold,
      steps: [
        _StepData('⏰', 'Every minute, your Chimeras automatically earn coins for you.'),
        _StepData('🦎', 'The more Chimeras you own, the more coins per minute.'),
        _StepData('📊', 'See your total income rate on the Chimeras screen.'),
        _StepData('💸', 'Coins are earned even while the app is closed (up to 24 hours offline).'),
      ],
    ),
    _SectionData(
      emoji: '🌍',
      title: 'Epochs & Rarity',
      accentColor: AppColors.stoneAge,
      steps: [
        _StepData('🌿', 'Mesozoic — age of dinosaurs. Green bones, jungle chimeras.'),
        _StepData('❄️', 'Ice Age — the frozen era. Blue bones, mammoth chimeras.'),
        _StepData('🪨', 'Stone Age — dawn of mankind. Orange bones, cave chimeras.'),
        _StepData('⬜', 'Common → 🟢 Uncommon → 🔵 Rare → 🟣 Epic → 🟡 Legendary'),
        _StepData('⭐', 'Rarity affects dust value, craft cost, and chimera income rate.'),
      ],
    ),
    _SectionData(
      emoji: '🏅',
      title: 'Achievements & Trophies',
      accentColor: AppColors.secondary,
      steps: [
        _StepData('🎯', 'Complete milestones (e.g. collect 10 bones, forge 5 chimeras) to earn XP.'),
        _StepData('⬆️', 'XP fills your rank bar. Rank up to unlock new titles and celebrate!'),
        _StepData('🏆', 'Trophies are permanent badges earned for big accomplishments.'),
        _StepData('🔔', 'You\'ll see a toast notification when an achievement is unlocked.'),
      ],
    ),
    _SectionData(
      emoji: '⚡',
      title: 'Events',
      accentColor: AppColors.accentTeal,
      steps: [
        _StepData('🎉', 'Collect all 5 Chimeras of one Epoch to trigger its special Event.'),
        _StepData('⏳', 'Events last 24 hours and boost your income or spawn rate.'),
        _StepData('📅', 'Check the Events tab to see active and upcoming events.'),
        _StepData('🔁', 'Events can repeat — keep building your collection!'),
      ],
    ),
  ];
}

// ─────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────

class _SectionData {
  final String emoji;
  final String title;
  final Color accentColor;
  final List<_StepData> steps;
  const _SectionData({
    required this.emoji,
    required this.title,
    required this.accentColor,
    required this.steps,
  });
}

class _StepData {
  final String icon;
  final String text;
  const _StepData(this.icon, this.text);
}

// ─────────────────────────────────────────────────────────────
// Hero intro widget
// ─────────────────────────────────────────────────────────────

class _HeroIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1040),
            Color(0xFF0D1F3C),
          ],
        ),
        border: Border.all(
          color: AppColors.primary.withAlpha(80),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(40),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('🦕🦴🔮', style: TextStyle(fontSize: 36))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 1.0, end: 1.06, duration: 2000.ms, curve: Curves.easeInOut),
          const SizedBox(height: 12),
          Text(
            'Paleo Merge',
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.primaryGlow,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Collect fossil bones, forge legendary Chimeras,\nand build a prehistoric empire.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Expandable section
// ─────────────────────────────────────────────────────────────

class _ExpandableSection extends StatefulWidget {
  final _SectionData section;
  final Duration delay;

  const _ExpandableSection({required this.section, required this.delay});

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _expand;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.section;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedBuilder(
        animation: _expand,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.card,
              border: Border.all(
                color: _isOpen
                    ? s.accentColor.withAlpha(160)
                    : AppColors.border,
                width: _isOpen ? 1.5 : 1.0,
              ),
              boxShadow: _isOpen
                  ? [
                      BoxShadow(
                        color: s.accentColor.withAlpha(30),
                        blurRadius: 14,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: Column(
              children: [
                // Header row — always visible
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  onPressed: _toggle,
                  child: Row(
                    children: [
                      // Accent dot
                      Container(
                        width: 4,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: s.accentColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(s.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          s.title,
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: _isOpen ? s.accentColor : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      // Chevron
                      AnimatedRotation(
                        turns: _isOpen ? 0.25 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Icon(
                          CupertinoIcons.chevron_right,
                          size: 16,
                          color: _isOpen ? s.accentColor : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                // Expandable steps
                SizeTransition(
                  sizeFactor: _expand,
                  axisAlignment: -1,
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: s.accentColor.withAlpha(60),
                      ),
                      ...s.steps.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final step = entry.value;
                        return _StepRow(
                          step: step,
                          accentColor: s.accentColor,
                          isLast: idx == s.steps.length - 1,
                          animDelay: Duration(milliseconds: idx * 60),
                          isVisible: _isOpen,
                        );
                      }),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: widget.delay)
        .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: widget.delay, curve: Curves.easeOut);
  }
}

// ─────────────────────────────────────────────────────────────
// Step row
// ─────────────────────────────────────────────────────────────

class _StepRow extends StatelessWidget {
  final _StepData step;
  final Color accentColor;
  final bool isLast;
  final Duration animDelay;
  final bool isVisible;

  const _StepRow({
    required this.step,
    required this.accentColor,
    required this.isLast,
    required this.animDelay,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 10, 16, isLast ? 10 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withAlpha(20),
              border: Border.all(color: accentColor.withAlpha(80), width: 0.5),
            ),
            alignment: Alignment.center,
            child: Text(
              step.icon,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                step.text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate(target: isVisible ? 1 : 0)
        .fadeIn(duration: 300.ms, delay: animDelay)
        .slideX(begin: -0.08, end: 0, duration: 300.ms, delay: animDelay, curve: Curves.easeOut);
  }
}
