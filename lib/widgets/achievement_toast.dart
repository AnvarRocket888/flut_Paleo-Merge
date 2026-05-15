import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/achievement.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Animated banner that slides in from the top when an achievement unlocks.
class AchievementToast extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;

  const AchievementToast({
    super.key,
    required this.achievement,
    required this.onDismiss,
  });

  @override
  State<AchievementToast> createState() => _AchievementToastState();
}

class _AchievementToastState extends State<AchievementToast> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surfaceElevated,
          border: Border.all(color: AppColors.primary.withAlpha(120), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(60),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon with glow
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(40),
                border: Border.all(
                    color: AppColors.primaryGlow.withAlpha(150), width: 1.5),
              ),
              child: Center(
                child: Text(
                  widget.achievement.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Achievement Unlocked!',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primaryGlow,
                      letterSpacing: 1.0,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.achievement.name,
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '+${widget.achievement.xpReward} XP',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentTeal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Text('✕',
                style: TextStyle(color: AppColors.textHint, fontSize: 14)),
          ],
        ),
      )
          .animate()
          .slideY(begin: -1.5, end: 0, duration: 400.ms, curve: Curves.elasticOut)
          .fadeIn(duration: 200.ms),
    );
  }
}
