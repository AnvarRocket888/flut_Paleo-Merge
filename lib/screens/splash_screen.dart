import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../widgets/animated_background.dart';

/// Shown every time the app launches. Auto-dismisses after 5 seconds.
/// Tapping anywhere triggers the same fade-out animation.
class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeOutCtrl;
  late Animation<double> _fadeOut;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();

    _fadeOutCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _fadeOutCtrl, curve: Curves.easeIn));

    _fadeOutCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    // Auto-dismiss after 5 seconds
    Future.delayed(
      Duration(seconds: AppNumerics.splashAutoCloseSeconds),
      _dismiss,
    );
  }

  @override
  void dispose() {
    _fadeOutCtrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (_dismissing) return;
    _dismissing = true;
    _fadeOutCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _dismiss,
      child: FadeTransition(
        opacity: _fadeOut,
        child: AnimatedBackground(
          accentColor: AppColors.primary,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / icon
                _buildLogo(),
                const SizedBox(height: 32),
                // App name
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.displayLarge.copyWith(
                    shadows: [
                      Shadow(
                        color: AppColors.primary.withAlpha(200),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, delay: 400.ms),
                const SizedBox(height: 12),
                // Tagline
                Text(
                  AppStrings.appTagline,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 600.ms),
                const SizedBox(height: 60),
                // Epoch icons row
                _buildEpochRow(),
                const SizedBox(height: 40),
                // Tap hint
                Text(
                  'Tap anywhere to begin',
                  style: AppTextStyles.caption,
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fadeIn(delay: 1500.ms, duration: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            AppColors.primaryGlow,
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(150),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: const Center(
        child: Text('🦴', style: TextStyle(fontSize: 56)),
      ),
    )
        .animate()
        .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            duration: 700.ms,
            curve: Curves.elasticOut)
        .fadeIn(duration: 400.ms);
  }

  Widget _buildEpochRow() {
    final epochs = [
      (AppEmojis.mesozoic, AppStrings.epochMesozoic, AppColors.mesozoic),
      (AppEmojis.iceAge, AppStrings.epochIceAge, AppColors.iceAge),
      (AppEmojis.stoneAge, AppStrings.epochStoneAge, AppColors.stoneAge),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: epochs.asMap().entries.map((entry) {
        final i = entry.key;
        final (emoji, label, color) = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withAlpha(30),
                  border:
                      Border.all(color: color.withAlpha(150), width: 1.5),
                ),
                child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(height: 6),
              Text(label,
                  style: AppTextStyles.labelSmall.copyWith(color: color)),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: 800 + i * 150), duration: 500.ms)
            .slideY(
                begin: 0.4,
                end: 0,
                delay: Duration(milliseconds: 800 + i * 150));
      }).toList(),
    );
  }
}
