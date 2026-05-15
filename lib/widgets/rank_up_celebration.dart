import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Full-screen celebration overlay shown when the player ranks up.
class RankUpCelebration extends StatefulWidget {
  final String rankName;
  final String rankEmoji;
  final int rankNumber;
  final VoidCallback onDismiss;

  const RankUpCelebration({
    super.key,
    required this.rankName,
    required this.rankEmoji,
    required this.rankNumber,
    required this.onDismiss,
  });

  @override
  State<RankUpCelebration> createState() => _RankUpCelebrationState();
}

class _RankUpCelebrationState extends State<RankUpCelebration>
    with TickerProviderStateMixin {
  late AnimationController _particleCtrl;
  late AnimationController _badgeCtrl;
  late Animation<double> _badgeScale;
  late List<_ConfettiParticle> _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = List.generate(60, (_) => _ConfettiParticle.random());

    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..forward();

    _badgeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _badgeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOut));
    _badgeCtrl.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _badgeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        color: AppColors.background.withAlpha(220),
        child: Stack(
          children: [
            // Confetti
            AnimatedBuilder(
              animation: _particleCtrl,
              builder: (_, __) => CustomPaint(
                painter: _ConfettiPainter(
                  particles: _confetti,
                  progress: _particleCtrl.value,
                ),
                child: const SizedBox.expand(),
              ),
            ),
            // Central content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🎊', style: const TextStyle(fontSize: 48))
                      .animate()
                      .fadeIn(duration: 300.ms),
                  const SizedBox(height: 16),
                  ScaleTransition(
                    scale: _badgeScale,
                    child: Container(
                      width: 140,
                      height: 140,
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
                            color: AppColors.primary.withAlpha(180),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.rankEmoji,
                                style: const TextStyle(fontSize: 48)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'RANK UP!',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.secondaryGlow,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                            color: AppColors.secondary,
                            blurRadius: 20),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.3, end: 0, delay: 300.ms),
                  const SizedBox(height: 8),
                  Text(
                    widget.rankName,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms),
                  const SizedBox(height: 4),
                  Text(
                    'Rank ${widget.rankNumber}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms),
                  const SizedBox(height: 32),
                  Text(
                    'Tap to continue',
                    style: AppTextStyles.caption,
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .fadeIn(duration: 800.ms, delay: 1.seconds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiParticle {
  final double x, startY, size, speed, phase;
  final Color color;

  const _ConfettiParticle(
      {required this.x,
      required this.startY,
      required this.size,
      required this.speed,
      required this.phase,
      required this.color});

  factory _ConfettiParticle.random() {
    final rng = Random();
    final colors = AppColors.particleColors;
    return _ConfettiParticle(
      x: rng.nextDouble(),
      startY: -0.1,
      size: rng.nextDouble() * 8 + 4,
      speed: rng.nextDouble() * 0.5 + 0.3,
      phase: rng.nextDouble() * 2 * pi,
      color: colors[rng.nextInt(colors.length)],
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  const _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (p.startY + progress * p.speed) % 1.2;
      final x = p.x * size.width + sin(progress * 4 + p.phase) * 30;
      final y = t * size.height;
      final paint = Paint()
        ..color = p.color.withAlpha((255 * (1 - t * 0.7)).round())
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * 5 + p.phase);
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size * 0.5),
          paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
