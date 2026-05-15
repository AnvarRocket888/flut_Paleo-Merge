import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/achievement.dart';
import '../models/bone.dart';
import '../services/game_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/extensions.dart';

/// Player profile screen — stats, achievements, recent activity.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GameService _gs = GameService.instance;

  @override
  void initState() {
    super.initState();
    _gs.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _gs.removeListener(_onChanged);
    super.dispose();
  }

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
            style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
          ),
        ),
        middle: Text('Profile', style: AppTextStyles.headlineSmall),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          children: [
            _HeroCard(gs: _gs)
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: -0.1, end: 0, duration: 450.ms, curve: Curves.easeOut),

            const SizedBox(height: 16),

            _buildSection(
              emoji: '📊',
              title: 'Statistics',
              accent: AppColors.primary,
              delay: 100.ms,
              child: _StatsGrid(gs: _gs),
            ),

            const SizedBox(height: 12),

            _buildSection(
              emoji: '🏅',
              title: 'Achievements Unlocked',
              accent: AppColors.secondary,
              delay: 180.ms,
              child: _AchievementsRow(gs: _gs),
            ),

            const SizedBox(height: 12),

            _buildSection(
              emoji: '🕓',
              title: 'Recently Acquired',
              accent: AppColors.mesozoic,
              delay: 260.ms,
              child: _RecentBonesRow(
                bones: _recentlyAcquired,
                emptyText: 'No bones in inventory yet',
              ),
            ),

            const SizedBox(height: 12),

            _buildSection(
              emoji: '⚗️',
              title: 'Recently Crafted',
              accent: AppColors.accentTeal,
              delay: 340.ms,
              child: _RecentBonesRow(
                bones: _recentlyCrafted,
                emptyText: 'No crafted bones yet',
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Bone> get _recentlyAcquired {
    final sorted = [..._gs.bones]
      ..sort((a, b) => b.collectedAt.compareTo(a.collectedAt));
    return sorted.take(10).toList();
  }

  List<Bone> get _recentlyCrafted {
    final crafted = _gs.bones
        .where((b) => b.id.endsWith('_crafted'))
        .toList()
      ..sort((a, b) => b.collectedAt.compareTo(a.collectedAt));
    return crafted.take(10).toList();
  }

  Widget _buildSection({
    required String emoji,
    required String title,
    required Color accent,
    required Duration delay,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.card,
        border: Border.all(color: accent.withAlpha(80), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: accent,
                  ),
                ),
                const SizedBox(width: 10),
                Text(emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: accent,
                      fontSize: 15,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 14),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: delay)
        .slideY(begin: 0.15, end: 0, duration: 400.ms, delay: delay, curve: Curves.easeOut);
  }
}

// ─────────────────────────────────────────────────────────────
// Hero card — rank, streak, progress
// ─────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final GameService gs;
  const _HeroCard({required this.gs});

  @override
  Widget build(BuildContext context) {
    final p = gs.playerData;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1040), Color(0xFF0D1F3C)],
        ),
        border: Border.all(color: AppColors.primary.withAlpha(100), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(35),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar + rank
          Row(
            children: [
              // Avatar circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceElevated,
                  border: Border.all(
                      color: AppColors.primaryGlow.withAlpha(160), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(60),
                      blurRadius: 12,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  p.rankEmoji,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.rankName,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.primaryGlow,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rank ${p.rank}  •  ${p.xp.compact} XP',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Streak badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.stoneAge.withAlpha(30),
                        border: Border.all(
                            color: AppColors.stoneAgeGlow.withAlpha(100),
                            width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥',
                              style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 5),
                          Text(
                            '${p.streakDays} day streak',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.stoneAgeGlow,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Rank progress bar
          if (!p.isMaxRank) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progress to next rank',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textHint)),
                Text(
                  '${((p.rankProgress) * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.primaryGlow),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 6,
                color: AppColors.surfaceElevated,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: p.rankProgress.clamp01(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryGlow],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ] else
            Center(
              child: Text(
                '👑 MAX RANK',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.coinGold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Stats grid
// ─────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final GameService gs;
  const _StatsGrid({required this.gs});

  @override
  Widget build(BuildContext context) {
    final p = gs.playerData;
    final stats = [
      _StatItem('🦴', 'Bones Collected', p.totalBonesCollected.compact),
      _StatItem('🐉', 'Chimeras Forged', p.totalChimerasCreated.compact),
      _StatItem('💔', 'Bones Disassembled', p.totalBonesDisassembled.compact),
      _StatItem('✨', 'Dust Accumulated', p.totalDustEverAccumulated.compact),
      _StatItem('💰', 'Passive Coins', p.totalPassiveCoinsEarned.compact),
      _StatItem('🏦', 'Current Coins', p.coins.compact),
      _StatItem('⚗️', 'Current Dust', p.dust.compact),
      _StatItem('📦', 'Bones in Inventory', gs.bones.length.toString()),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.6,
        ),
        itemCount: stats.length,
        itemBuilder: (_, i) => _StatTile(
          item: stats[i],
          delay: Duration(milliseconds: i * 50),
        ),
      ),
    );
  }
}

class _StatItem {
  final String emoji;
  final String label;
  final String value;
  const _StatItem(this.emoji, this.label, this.value);
}

class _StatTile extends StatelessWidget {
  final _StatItem item;
  final Duration delay;
  const _StatTile({required this.item, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surfaceElevated,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.value,
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
                ),
                Text(
                  item.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textHint,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: delay)
        .scaleXY(begin: 0.9, end: 1.0, duration: 300.ms, delay: delay, curve: Curves.easeOut);
  }
}

// ─────────────────────────────────────────────────────────────
// Achievements row
// ─────────────────────────────────────────────────────────────

class _AchievementsRow extends StatelessWidget {
  final GameService gs;
  const _AchievementsRow({required this.gs});

  @override
  Widget build(BuildContext context) {
    final unlocked = gs.achievements
        .where((a) => a.isUnlocked)
        .toList()
      ..sort((a, b) {
        if (a.unlockedAt != null && b.unlockedAt != null) {
          return b.unlockedAt!.compareTo(a.unlockedAt!);
        }
        return b.xpReward.compareTo(a.xpReward);
      });

    if (unlocked.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text(
          'No achievements unlocked yet — start collecting!',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
        ),
      );
    }

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: unlocked.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => _AchievementChip(
          achievement: unlocked[i],
          delay: Duration(milliseconds: i * 60),
        ),
      ),
    );
  }
}

class _AchievementChip extends StatelessWidget {
  final Achievement achievement;
  final Duration delay;
  const _AchievementChip({required this.achievement, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surfaceElevated,
        border: Border.all(
          color: AppColors.secondary.withAlpha(120),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withAlpha(25),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(achievement.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          Text(
            achievement.name,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: delay)
        .slideX(begin: 0.2, end: 0, duration: 300.ms, delay: delay, curve: Curves.easeOut);
  }
}

// ─────────────────────────────────────────────────────────────
// Recent bones horizontal row
// ─────────────────────────────────────────────────────────────

class _RecentBonesRow extends StatelessWidget {
  final List<Bone> bones;
  final String emptyText;
  const _RecentBonesRow({required this.bones, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    if (bones.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text(
          emptyText,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
        ),
      );
    }

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: bones.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => _MiniBoneCard(
          bone: bones[i],
          delay: Duration(milliseconds: i * 55),
        ),
      ),
    );
  }
}

class _MiniBoneCard extends StatelessWidget {
  final Bone bone;
  final Duration delay;
  const _MiniBoneCard({required this.bone, required this.delay});

  @override
  Widget build(BuildContext context) {
    final epochColor = bone.epoch.color;
    final rarityColor = bone.rarity.color;
    return Container(
      width: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surfaceElevated,
        border: Border.all(
          color: rarityColor.withAlpha(100),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(bone.type.emoji, style: const TextStyle(fontSize: 24)),
          Text(
            bone.type.label,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: epochColor.withAlpha(30),
              border: Border.all(
                  color: epochColor.withAlpha(100), width: 0.5),
            ),
            child: Text(bone.epoch.emoji,
                style: const TextStyle(fontSize: 10)),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: delay)
        .slideX(begin: 0.15, end: 0, duration: 300.ms, delay: delay, curve: Curves.easeOut);
  }
}
