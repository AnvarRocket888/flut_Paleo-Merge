import 'package:flutter/cupertino.dart';
import '../models/bone.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';

extension IntExtensions on int {
  /// Format large numbers with K/M suffix.
  String get compact {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }

  /// Pad with leading zeros to ensure minimum [width] digits.
  String padded(int width) => toString().padLeft(width, '0');
}

extension DoubleExtensions on double {
  double clamp01() => clamp(0.0, 1.0).toDouble();
}

extension DurationExtensions on int {
  /// Convert seconds to MM:SS string.
  String get asTimer {
    final m = (this ~/ 60).padded(2);
    final s = (this % 60).padded(2);
    return '$m:$s';
  }

  /// Convert seconds to human-readable e.g. "2h 30m".
  String get asHumanTime {
    if (this < 60) return '${this}s';
    if (this < 3600) return '${this ~/ 60}m ${this % 60}s';
    final h = this ~/ 3600;
    final m = (this % 3600) ~/ 60;
    return '${h}h ${m}m';
  }
}

extension EpochExtensions on Epoch {
  String get label {
    switch (this) {
      case Epoch.mesozoic:
        return AppStrings.epochMesozoic;
      case Epoch.iceAge:
        return AppStrings.epochIceAge;
      case Epoch.stoneAge:
        return AppStrings.epochStoneAge;
    }
  }

  String get emoji {
    switch (this) {
      case Epoch.mesozoic:
        return AppEmojis.mesozoic;
      case Epoch.iceAge:
        return AppEmojis.iceAge;
      case Epoch.stoneAge:
        return AppEmojis.stoneAge;
    }
  }

  Color get color {
    switch (this) {
      case Epoch.mesozoic:
        return AppColors.mesozoic;
      case Epoch.iceAge:
        return AppColors.iceAge;
      case Epoch.stoneAge:
        return AppColors.stoneAge;
    }
  }

  Color get glowColor {
    switch (this) {
      case Epoch.mesozoic:
        return AppColors.mesozoicGlow;
      case Epoch.iceAge:
        return AppColors.iceAgeGlow;
      case Epoch.stoneAge:
        return AppColors.stoneAgeGlow;
    }
  }

  LinearGradient get gradient {
    switch (this) {
      case Epoch.mesozoic:
        return AppColors.mesozoicGradient;
      case Epoch.iceAge:
        return AppColors.iceAgeGradient;
      case Epoch.stoneAge:
        return AppColors.stoneAgeGradient;
    }
  }
}

extension RarityExtensions on Rarity {
  String get label {
    switch (this) {
      case Rarity.common:
        return AppStrings.rarityCommon;
      case Rarity.uncommon:
        return AppStrings.rarityUncommon;
      case Rarity.rare:
        return AppStrings.rarityRare;
      case Rarity.epic:
        return AppStrings.rarityEpic;
      case Rarity.legendary:
        return AppStrings.rarityLegendary;
    }
  }

  String get emoji {
    switch (this) {
      case Rarity.common:
        return AppEmojis.rarityCommon;
      case Rarity.uncommon:
        return AppEmojis.rarityUncommon;
      case Rarity.rare:
        return AppEmojis.rarityRare;
      case Rarity.epic:
        return AppEmojis.rarityEpic;
      case Rarity.legendary:
        return AppEmojis.rarityLegendary;
    }
  }

  Color get color {
    switch (this) {
      case Rarity.common:
        return AppColors.rarityCommon;
      case Rarity.uncommon:
        return AppColors.rarityUncommon;
      case Rarity.rare:
        return AppColors.rarityRare;
      case Rarity.epic:
        return AppColors.rarityEpic;
      case Rarity.legendary:
        return AppColors.rarityLegendary;
    }
  }

  int get index2 {
    switch (this) {
      case Rarity.common:
        return 0;
      case Rarity.uncommon:
        return 1;
      case Rarity.rare:
        return 2;
      case Rarity.epic:
        return 3;
      case Rarity.legendary:
        return 4;
    }
  }
}

extension BoneTypeExtensions on BoneType {
  String get label {
    switch (this) {
      case BoneType.jaw:
        return AppStrings.boneTypeJaw;
      case BoneType.vertebra:
        return AppStrings.boneTypeVertebra;
      case BoneType.rib:
        return AppStrings.boneTypeRib;
      case BoneType.claw:
        return AppStrings.boneTypeClaw;
    }
  }

  String get emoji {
    switch (this) {
      case BoneType.jaw:
        return AppEmojis.jaw;
      case BoneType.vertebra:
        return AppEmojis.vertebra;
      case BoneType.rib:
        return AppEmojis.rib;
      case BoneType.claw:
        return AppEmojis.claw;
    }
  }
}

extension ColorExtensions on Color {
  Color withGlow(double opacity) => withAlpha((opacity * 255).round());

  BoxShadow toGlow({double blurRadius = 12, double spreadRadius = 2}) {
    return BoxShadow(
      color: withAlpha(150),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );
  }
}

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  bool get isIPad => screenWidth >= 768;
}
