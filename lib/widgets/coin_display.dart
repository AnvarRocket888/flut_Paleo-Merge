import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

/// Animated coin counter widget.
class CoinDisplay extends StatefulWidget {
  final int coins;

  const CoinDisplay({super.key, required this.coins});

  @override
  State<CoinDisplay> createState() => _CoinDisplayState();
}

class _CoinDisplayState extends State<CoinDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _popCtrl;
  int _displayedCoins = 0;

  @override
  void initState() {
    super.initState();
    _displayedCoins = widget.coins;
    _popCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void didUpdateWidget(CoinDisplay old) {
    super.didUpdateWidget(old);
    if (old.coins != widget.coins) {
      setState(() => _displayedCoins = widget.coins);
      _popCtrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.15).animate(
          CurvedAnimation(parent: _popCtrl, curve: Curves.elasticOut)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(AppEmojis.coin, style: TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            _displayedCoins.compact,
            style: AppTextStyles.coinText,
          ),
        ],
      ),
    );
  }
}

/// Animated dust counter widget.
class DustDisplay extends StatefulWidget {
  final int dust;

  const DustDisplay({super.key, required this.dust});

  @override
  State<DustDisplay> createState() => _DustDisplayState();
}

class _DustDisplayState extends State<DustDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _popCtrl;
  int _displayedDust = 0;

  @override
  void initState() {
    super.initState();
    _displayedDust = widget.dust;
    _popCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void didUpdateWidget(DustDisplay old) {
    super.didUpdateWidget(old);
    if (old.dust != widget.dust) {
      setState(() => _displayedDust = widget.dust);
      _popCtrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.15).animate(
          CurvedAnimation(parent: _popCtrl, curve: Curves.elasticOut)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(AppEmojis.dust, style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            _displayedDust.compact,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.dust,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Streak flame display.
class StreakDisplay extends StatelessWidget {
  final int streakDays;
  const StreakDisplay({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(AppEmojis.streak, style: TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        Text(
          '$streakDays',
          style: AppTextStyles.streakText.copyWith(fontSize: 15),
        ),
        const SizedBox(width: 2),
        Text(
          AppStrings.days,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.streak.withAlpha(180),
          ),
        ),
      ],
    )
        .animate(onPlay: (c) => c.repeat(period: 2.seconds))
        .shimmer(
            duration: 1.seconds,
            color: AppColors.streak.withAlpha(100),
            delay: 500.ms);
  }
}
