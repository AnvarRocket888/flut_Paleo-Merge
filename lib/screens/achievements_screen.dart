import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/achievement.dart';
import '../services/game_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../widgets/animated_background.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final GameService _gs = GameService.instance;

  @override
  void initState() {
    super.initState();
    _gs.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _gs.removeListener(_onStateChanged);
    super.dispose();
  }

  Widget _buildSummaryHeader() {
    final total = _gs.achievements.length;
    final done = _gs.achievements.where((a) => a.isUnlocked).length;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceElevated,
        border: Border.all(
            color: AppColors.primary.withAlpha(80)),
      ),
      child: Row(
        children: [
          const Text('🏅', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.achievements,
                  style: AppTextStyles.headlineSmall),
              const SizedBox(height: 2),
              Text(
                '$done of $total unlocked',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Container(height: 6, color: AppColors.border),
                      FractionallySizedBox(
                        widthFactor: total > 0 ? done / total : 0,
                        child: Container(
                            height: 6, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$done/$total',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementTile(Achievement a, int index) {
    final hasProgress = a.progressTarget != null && !a.isUnlocked;
    final progressRatio = a.progressRatio;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceElevated,
        border: Border.all(
          color: a.isUnlocked
              ? AppColors.primary.withAlpha(150)
              : AppColors.border,
          width: a.isUnlocked ? 1.5 : 1,
        ),
        boxShadow: a.isUnlocked
            ? [
                BoxShadow(
                  color: AppColors.primary.withAlpha(30),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Emoji badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: a.isUnlocked
                  ? AppColors.primary.withAlpha(40)
                  : AppColors.border.withAlpha(60),
              border: Border.all(
                color: a.isUnlocked
                    ? AppColors.primaryGlow.withAlpha(150)
                    : AppColors.border,
              ),
            ),
            child: Center(
              child: Text(
                a.isUnlocked ? a.emoji : '🔒',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: a.isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  a.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (hasProgress) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Stack(
                      children: [
                        Container(height: 4, color: AppColors.border),
                        FractionallySizedBox(
                          widthFactor: progressRatio.clamp(0.0, 1.0),
                          child: Container(
                              height: 4, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${a.currentProgress} / ${a.progressTarget}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textHint,
                      fontSize: 10,
                    ),
                  ),
                ],
                if (a.isUnlocked && a.unlockedAt != null)
                  Text(
                    'Unlocked ${_formatDate(a.unlockedAt!)}',
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // XP reward
          Column(
            children: [
              Text(
                '+${a.xpReward}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: a.isUnlocked
                      ? AppColors.accentTeal
                      : AppColors.textHint,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'XP',
                style: AppTextStyles.caption.copyWith(
                  color: a.isUnlocked
                      ? AppColors.accentTeal.withAlpha(180)
                      : AppColors.textHint,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
            delay: Duration(milliseconds: 60 * index),
            duration: 300.ms)
        .slideX(begin: 0.1, end: 0,
            delay: Duration(milliseconds: 60 * index));
  }

  String _formatDate(DateTime d) =>
      '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final achievements = _gs.achievements;
    // Sort: unlocked first, then by name
    final sorted = [...achievements]
      ..sort((a, b) {
        if (a.isUnlocked == b.isUnlocked) {
          return a.name.compareTo(b.name);
        }
        return a.isUnlocked ? -1 : 1;
      });

    return AnimatedBackground(
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(AppStrings.achievements,
                      style: AppTextStyles.headlineLarge)
                  .animate()
                  .fadeIn(duration: 400.ms),
            ),
          ),
          _buildSummaryHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: sorted.length,
              itemBuilder: (_, i) =>
                  _buildAchievementTile(sorted[i], i),
            ),
          ),
        ],
      ),
    );
  }
}
