import 'package:flutter/cupertino.dart';

/// Central color palette for Paleo Merge.
/// All colors must be sourced from this class — never hardcode colors inline.
class AppColors {
  AppColors._();

  // ── Backgrounds ─────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0A0A14);
  static const Color surface = Color(0xFF141428);
  static const Color surfaceElevated = Color(0xFF1E1E3A);
  static const Color card = Color(0xFF1A1A30);
  static const Color border = Color(0xFF2A2A4A);

  // ── Primary — deep alchemical purple ────────────────────────────────────────
  static const Color primary = Color(0xFF8B4FE8);
  static const Color primaryGlow = Color(0xFFA56BFF);
  static const Color primaryDark = Color(0xFF5C2FA8);

  // ── Secondary — fossil amber/gold ───────────────────────────────────────────
  static const Color secondary = Color(0xFFD4920E);
  static const Color secondaryGlow = Color(0xFFFFB830);

  // ── Accents ──────────────────────────────────────────────────────────────────
  static const Color accentTeal = Color(0xFF2EC9A8);
  static const Color accentRed = Color(0xFFE85050);
  static const Color accentPink = Color(0xFFE84FA0);

  // ── Text ─────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFEDE8F5);
  static const Color textSecondary = Color(0xFF9B96B0);
  static const Color textHint = Color(0xFF605A78);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Epoch colors ─────────────────────────────────────────────────────────────
  static const Color mesozoic = Color(0xFF4CAF6A);
  static const Color mesozoicGlow = Color(0xFF6FFF90);
  static const Color mesozoicDark = Color(0xFF2A6B3E);

  static const Color iceAge = Color(0xFF4A9EDE);
  static const Color iceAgeGlow = Color(0xFF7DC6FF);
  static const Color iceAgeDark = Color(0xFF2A5E8B);

  static const Color stoneAge = Color(0xFFC87D3A);
  static const Color stoneAgeGlow = Color(0xFFFFAA5A);
  static const Color stoneAgeDark = Color(0xFF7A4A20);

  // ── Rarity colors ────────────────────────────────────────────────────────────
  static const Color rarityCommon = Color(0xFF9BA8B5);
  static const Color rarityUncommon = Color(0xFF4CAF6A);
  static const Color rarityRare = Color(0xFF4A9EDE);
  static const Color rarityEpic = Color(0xFF8B4FE8);
  static const Color rarityLegendary = Color(0xFFD4920E);

  // ── UI functional ────────────────────────────────────────────────────────────
  static const Color xpBar = Color(0xFF8B4FE8);
  static const Color coin = Color(0xFFD4920E);
  static const Color coinGold = Color(0xFFFFB830);
  static const Color dust = Color(0xFFC4B8E0);
  static const Color success = Color(0xFF4CAF6A);
  static const Color warning = Color(0xFFD4920E);
  static const Color error = Color(0xFFE85050);
  static const Color streak = Color(0xFFFF6B35);

  // ── Particle accent pool ─────────────────────────────────────────────────────
  static const List<Color> particleColors = [
    Color(0xFF8B4FE8),
    Color(0xFFD4920E),
    Color(0xFF2EC9A8),
    Color(0xFFE84FA0),
    Color(0xFF4A9EDE),
    Color(0xFFA56BFF),
    Color(0xFFFFB830),
  ];

  // ── Gradients ────────────────────────────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0A14), Color(0xFF0E0E20), Color(0xFF12121E)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B4FE8), Color(0xFF5C2FA8)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFB830), Color(0xFFD4920E), Color(0xFF9A5E00)],
  );

  static const LinearGradient mesozoicGradient = LinearGradient(
    colors: [Color(0xFF4CAF6A), Color(0xFF2A6B3E)],
  );

  static const LinearGradient iceAgeGradient = LinearGradient(
    colors: [Color(0xFF4A9EDE), Color(0xFF2A5E8B)],
  );

  static const LinearGradient stoneAgeGradient = LinearGradient(
    colors: [Color(0xFFC87D3A), Color(0xFF7A4A20)],
  );
}
