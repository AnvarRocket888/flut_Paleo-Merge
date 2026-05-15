import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/trophy.dart';
import '../services/game_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../widgets/animated_background.dart';

class TrophiesScreen extends StatefulWidget {
  const TrophiesScreen({super.key});

  @override
  State<TrophiesScreen> createState() => _TrophiesScreenState();
}

class _TrophiesScreenState extends State<TrophiesScreen> {
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

  Widget _buildTrophyCard(Trophy trophy, int index) {
    final isUnlocked = trophy.isUnlocked;
    final tierColor = _tierColor(trophy.tier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CardGlowEffect(
        glowColor: isUnlocked ? tierColor : const Color(0x00000000),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.surfaceElevated,
            border: Border.all(
              color: isUnlocked
                  ? tierColor.withAlpha(180)
                  : AppColors.border,
              width: isUnlocked ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Trophy icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: isUnlocked
                      ? tierColor.withAlpha(30)
                      : AppColors.border.withAlpha(40),
                  border: Border.all(
                    color: isUnlocked
                        ? tierColor.withAlpha(150)
                        : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    isUnlocked ? trophy.tier.emoji : '🔒',
                    style: TextStyle(
                      fontSize: isUnlocked ? 36 : 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tier badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isUnlocked
                            ? tierColor.withAlpha(30)
                            : AppColors.border.withAlpha(30),
                        border: Border.all(
                          color: isUnlocked
                              ? tierColor.withAlpha(100)
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        trophy.tier.label.toUpperCase(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isUnlocked ? tierColor : AppColors.textHint,
                          fontSize: 10,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isUnlocked ? trophy.name : '???',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: isUnlocked
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trophy.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isUnlocked && trophy.unlockedAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Earned ${_formatDate(trophy.unlockedAt!)}',
                        style: AppTextStyles.caption.copyWith(
                          color: tierColor.withAlpha(180),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
            delay: Duration(milliseconds: 120 * index),
            duration: 400.ms)
        .slideY(
            begin: 0.2,
            end: 0,
            delay: Duration(milliseconds: 120 * index),
            curve: Curves.easeOut);
  }

  Color _tierColor(TrophyTier tier) {
    switch (tier) {
      case TrophyTier.bronze:
        return const Color(0xFFCD7F32);
      case TrophyTier.silver:
        return const Color(0xFFC0C0C0);
      case TrophyTier.gold:
        return AppColors.coinGold;
      case TrophyTier.platinum:
        return const Color(0xFFE5E4E2);
      case TrophyTier.diamond:
        return const Color(0xFF9AF5FF);
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final trophies = _gs.trophies;
    // Sort: unlocked first
    final sorted = [...trophies]
      ..sort((a, b) {
        if (a.isUnlocked == b.isUnlocked) return 0;
        return a.isUnlocked ? -1 : 1;
      });

    final unlockedCount = trophies.where((t) => t.isUnlocked).length;

    return AnimatedBackground(
      accentColor: AppColors.coinGold,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Text(AppStrings.trophies,
                          style: AppTextStyles.headlineLarge)
                      .animate()
                      .fadeIn(duration: 400.ms),
                  const Spacer(),
                  Text(
                    '$unlockedCount/${trophies.length}',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.coinGold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: sorted.length,
              itemBuilder: (_, i) => _buildTrophyCard(sorted[i], i),
            ),
          ),
        ],
      ),
    );
  }
}


