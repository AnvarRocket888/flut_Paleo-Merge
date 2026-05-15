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

class _BoneCardState extends State<BoneCard> {
  bool _pressed = false;

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
        child: _buildCard(),
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
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Bone emoji
                  Text(
                    widget.bone.type.emoji,
                    style: const TextStyle(fontSize: 42),
                    textAlign: TextAlign.center,
                  ),
                  // Bone type label
                  Text(
                    widget.bone.type.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Epoch badge
                  _EpochDot(epoch: widget.bone.epoch),
                  // Rarity emoji
                  Text(
                    widget.bone.rarity.emoji,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: epoch.color.withAlpha(30),
        border: Border.all(color: epoch.color.withAlpha(120), width: 0.5),
      ),
      child: Text(
        epoch.emoji,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
