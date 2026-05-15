import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/bone.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/extensions.dart';

/// Animated card representing a single fossil bone in the inventory.
class BoneCard extends StatefulWidget {
  final Bone bone;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const BoneCard({
    super.key,
    required this.bone,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<BoneCard> createState() => _BoneCardState();
}

class _BoneCardState extends State<BoneCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _idleCtrl;
  late Animation<double> _floatAnim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _idleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -3.0, end: 3.0).animate(
        CurvedAnimation(parent: _idleCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _idleCtrl.dispose();
    super.dispose();
  }

  Color get _epochColor => widget.bone.epoch.color;
  Color get _rarityColor => widget.bone.rarity.color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: _floatAnim,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _floatAnim.value),
            child: child,
          ),
          child: _buildCard(),
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: widget.isSelected
            ? _epochColor.withAlpha(40)
            : AppColors.card,
        border: Border.all(
          color: widget.isSelected ? _epochColor : _rarityColor.withAlpha(80),
          width: widget.isSelected ? 2.0 : 1.0,
        ),
        boxShadow: widget.isSelected
            ? [
                BoxShadow(
                  color: _epochColor.withAlpha(80),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : [
                BoxShadow(
                  color: AppColors.background.withAlpha(180),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
      ),
      child: Stack(
        children: [
          // Rarity glow overlay
          if (widget.bone.rarity == Rarity.legendary ||
              widget.bone.rarity == Rarity.epic)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      _rarityColor.withAlpha(30),
                      const Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bone emoji
                Text(
                  widget.bone.type.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 6),
                // Bone type label
                Text(
                  widget.bone.type.label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Epoch badge
                _EpochDot(epoch: widget.bone.epoch),
                const SizedBox(height: 4),
                // Rarity label
                Text(
                  widget.bone.rarity.emoji,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          // Selection checkmark
          if (widget.isSelected)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: _epochColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.checkmark,
                  size: 10,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EpochDot extends StatelessWidget {
  final Epoch epoch;
  const _EpochDot({required this.epoch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: epoch.color.withAlpha(30),
        border: Border.all(color: epoch.color.withAlpha(120), width: 0.5),
      ),
      child: Text(
        epoch.emoji,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}
