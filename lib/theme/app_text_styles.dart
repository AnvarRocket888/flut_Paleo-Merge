import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

/// All text styles used across Paleo Merge.
/// Never define TextStyle inline — always use this class.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    decoration: TextDecoration.none,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    decoration: TextDecoration.none,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
    decoration: TextDecoration.none,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    letterSpacing: 0.8,
    decoration: TextDecoration.none,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    decoration: TextDecoration.none,
  );

  static const TextStyle rankTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryGlow,
    letterSpacing: 1.0,
    decoration: TextDecoration.none,
    shadows: [Shadow(color: AppColors.primary, blurRadius: 8)],
  );

  static const TextStyle coinText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.secondaryGlow,
    decoration: TextDecoration.none,
    shadows: [Shadow(color: AppColors.secondary, blurRadius: 6)],
  );

  static const TextStyle glowText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryGlow,
    decoration: TextDecoration.none,
    shadows: [Shadow(color: AppColors.primary, blurRadius: 12)],
  );

  static const TextStyle legendaryText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.rarityLegendary,
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
    shadows: [Shadow(color: AppColors.rarityLegendary, blurRadius: 10)],
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.3,
    decoration: TextDecoration.none,
  );

  static const TextStyle tabLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    decoration: TextDecoration.none,
  );

  static const TextStyle timerText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.accentTeal,
    letterSpacing: 2.0,
    decoration: TextDecoration.none,
    shadows: [Shadow(color: AppColors.accentTeal, blurRadius: 10)],
  );

  static const TextStyle streakText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.streak,
    decoration: TextDecoration.none,
    shadows: [Shadow(color: AppColors.streak, blurRadius: 8)],
  );
}
