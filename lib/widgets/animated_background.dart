import 'dart:math';
import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';

/// Full-screen animated particle background used across all screens.
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color? accentColor;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.accentColor,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _gradientController;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(40, (_) => _Particle.random());

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _particleController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        AnimatedBuilder(
          animation: _gradientController,
          builder: (_, __) {
            final t = _gradientController.value;
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(AppColors.background,
                        (widget.accentColor ?? AppColors.primary).withAlpha(30), t)!,
                    AppColors.background,
                    Color.lerp(AppColors.surface,
                        (widget.accentColor ?? AppColors.secondary).withAlpha(20), 1 - t)!,
                  ],
                ),
              ),
            );
          },
        ),
        // Particle layer
        AnimatedBuilder(
          animation: _particleController,
          builder: (_, __) {
            return CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                progress: _particleController.value,
                accentColor: widget.accentColor,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class _Particle {
  final double x;      // 0..1 normalized
  final double y;      // 0..1 normalized
  final double size;
  final double speed;
  final double opacity;
  final Color color;
  final double phase;  // phase offset for independent motion

  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
    required this.phase,
  });

  factory _Particle.random() {
    final rng = Random();
    final colors = AppColors.particleColors;
    return _Particle(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      size: rng.nextDouble() * 3 + 1,
      speed: rng.nextDouble() * 0.3 + 0.05,
      opacity: rng.nextDouble() * 0.5 + 0.1,
      color: colors[rng.nextInt(colors.length)],
      phase: rng.nextDouble(),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color? accentColor;

  const _ParticlePainter({
    required this.particles,
    required this.progress,
    this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final x = p.x * size.width;
      // Drift upward with sinusoidal horizontal wobble
      final y = ((p.y - t) % 1.0) * size.height;
      final wobble = sin((t + p.phase) * 2 * pi) * 20;

      final paint = Paint()
        ..color = p.color.withAlpha((p.opacity * 255).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(x + wobble, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

/// Compact shimmer/glow overlay — used inside cards.
class CardGlowEffect extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final BorderRadius borderRadius;

  const CardGlowEffect({
    super.key,
    required this.child,
    this.glowColor = AppColors.primary,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<CardGlowEffect> createState() => _CardGlowEffectState();
}

class _CardGlowEffectState extends State<CardGlowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.8).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withAlpha((_anim.value * 80).round()),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}
