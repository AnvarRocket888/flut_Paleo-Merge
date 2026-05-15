import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/chimera.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/extensions.dart';

/// Animated card for a single Chimera in the collection grid.
class ChimeraCard extends StatefulWidget {
  final ChimeraDefinition definition;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const ChimeraCard({
    super.key,
    required this.definition,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  State<ChimeraCard> createState() => _ChimeraCardState();
}

class _ChimeraCardState extends State<ChimeraCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  Color get _rarityColor => widget.definition.rarity.color;
  Color get _epochColor => widget.definition.epoch.color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedBuilder(
          animation: _glowCtrl,
          builder: (_, child) {
            final glowOpacity = widget.isUnlocked
                ? (_glowCtrl.value * 0.4 + 0.2)
                : 0.0;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.card,
                border: Border.all(
                  color: widget.isUnlocked
                      ? _rarityColor.withAlpha(150)
                      : AppColors.border,
                  width: widget.isUnlocked ? 1.5 : 1.0,
                ),
                boxShadow: widget.isUnlocked
                    ? [
                        BoxShadow(
                          color: _rarityColor
                              .withAlpha((glowOpacity * 120).round()),
                          blurRadius: 16,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: child,
            );
          },
          child: _buildContent(),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji / silhouette
          widget.isUnlocked
              ? _buildUnlockedEmoji()
              : _buildLockedSilhouette(),
          const SizedBox(height: 8),
          // Name
          Text(
            widget.isUnlocked ? widget.definition.name : '???',
            style: AppTextStyles.labelMedium.copyWith(
              color: widget.isUnlocked
                  ? AppColors.textPrimary
                  : AppColors.textHint,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Epoch badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.definition.epoch.emoji,
                  style: const TextStyle(fontSize: 10)),
              const SizedBox(width: 3),
              if (widget.isUnlocked) ...[
                Text(
                  '${widget.definition.incomePerMinute}/min',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.coin,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockedEmoji() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _rarityColor.withAlpha(60),
            _epochColor.withAlpha(30),
            const Color(0x00000000),
          ],
        ),
      ),
      child: Center(
        child: Text(
          widget.definition.emoji,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  Widget _buildLockedSilhouette() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.border.withAlpha(80),
      ),
      child: const Center(
        child: Text('🔒', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
