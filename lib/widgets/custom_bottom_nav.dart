import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';

/// Custom animated bottom navigation bar.
class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scales;
  late List<AnimationController> _glowControllers;

  final List<String> _emojis = [
    AppEmojis.navHome,
    AppEmojis.navMerge,
    AppEmojis.navChimeras,
    AppEmojis.navAchievements,
    AppEmojis.navEvents,
  ];

  final List<String> _labels = [
    AppStrings.tabHome,
    AppStrings.tabMerge,
    AppStrings.tabChimeras,
    AppStrings.tabAchievements,
    AppStrings.tabEvents,
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      5,
      (i) => AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _scales = _controllers
        .map((c) =>
            Tween<double>(begin: 1.0, end: 1.3).animate(
                CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
    _glowControllers = List.generate(
      5,
      (i) => AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1500))
        ..repeat(reverse: true),
    );

    // Animate the initially selected item
    _controllers[widget.currentIndex].forward();
  }

  @override
  void didUpdateWidget(CustomBottomNav old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _controllers[old.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final c in _glowControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.background.withAlpha(200),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(5, (i) => Expanded(child: _buildItem(i))),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final isSelected = widget.currentIndex == index;
    final selectedColor = AppColors.primaryGlow;
    final unselectedColor = AppColors.textHint;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onTap(index),
      child: AnimatedBuilder(
        animation: Listenable.merge([_scales[index], _glowControllers[index]]),
        builder: (_, __) {
          final glowOpacity = isSelected
              ? (_glowControllers[index].value * 0.4 + 0.2)
              : 0.0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scales[index],
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow halo
                    if (isSelected)
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: selectedColor
                                  .withAlpha((glowOpacity * 180).round()),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    // Indicator pill
                    if (isSelected)
                      Container(
                        width: 36,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.primary.withAlpha(40),
                        ),
                      ),
                    Text(
                      _emojis[index],
                      style: TextStyle(
                        fontSize: isSelected ? 22 : 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _labels[index],
                style: AppTextStyles.tabLabel.copyWith(
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
