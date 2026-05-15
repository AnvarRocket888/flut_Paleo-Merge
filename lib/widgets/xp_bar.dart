import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Animated XP progress bar with label.
class XpBar extends StatefulWidget {
  final double progress; // 0.0 – 1.0
  final int currentXp;
  final int nextRankXp;
  final String rankName;
  final String rankEmoji;
  final int rank;

  const XpBar({
    super.key,
    required this.progress,
    required this.currentXp,
    required this.nextRankXp,
    required this.rankName,
    required this.rankEmoji,
    required this.rank,
  });

  @override
  State<XpBar> createState() => _XpBarState();
}

class _XpBarState extends State<XpBar> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progressAnim;
  double _previousProgress = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _progressAnim = Tween<double>(begin: 0, end: widget.progress)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _previousProgress = widget.progress;
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(XpBar old) {
    super.didUpdateWidget(old);
    if (old.progress != widget.progress) {
      _progressAnim = Tween<double>(
        begin: _previousProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
      _previousProgress = widget.progress;
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(widget.rankEmoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              'Rank ${widget.rank}',
              style: AppTextStyles.labelSmall,
            ),
            const SizedBox(width: 6),
            Text(
              widget.rankName,
              style: AppTextStyles.rankTitle.copyWith(fontSize: 13),
            ),
            const Spacer(),
            Text(
              '${widget.currentXp} / ${widget.nextRankXp} XP',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 8,
            child: AnimatedBuilder(
              animation: _progressAnim,
              builder: (_, __) {
                return Stack(
                  children: [
                    // Background track
                    Container(
                      color: AppColors.border,
                      width: double.infinity,
                    ),
                    // Filled portion
                    FractionallySizedBox(
                      widthFactor: _progressAnim.value.clamp(0.0, 1.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryGlow,
                              AppColors.primary,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary,
                              blurRadius: 6,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
