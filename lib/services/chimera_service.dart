import 'dart:math';
import '../models/bone.dart';
import '../models/chimera.dart';

/// Handles Chimera creation logic — determines which Chimera is generated
/// when 3 bones of the same epoch are merged.
class ChimeraService {
  ChimeraService._();
  static final ChimeraService instance = ChimeraService._();

  static final Random _rng = Random();

  /// Returns the definitions for a given epoch in ascending rarity order.
  static List<ChimeraDefinition> definitionsForEpoch(Epoch epoch) =>
      ChimeraDefinition.all.where((d) => d.epoch == epoch).toList()
        ..sort((a, b) => a.rarity.index.compareTo(b.rarity.index));

  /// Determines which Chimera rarity results from merging 3 bones.
  /// Higher average bone rarity increases chances of rarer Chimera.
  static Rarity _determineChimeraRarity(List<Bone> bones) {
    assert(bones.length == 3);
    final avgRarity = bones.map((b) => b.rarity.index).reduce((a, b) => a + b) / 3.0;

    // Base weights shifted upward by average rarity level
    // avgRarity 0 = Common avg → mostly Common result
    // avgRarity 4 = Legendary avg → good chance of Legendary
    final shift = (avgRarity * 15).round(); // 0..60 bonus spread

    final roll = _rng.nextInt(100);
    final adjusted = roll + shift;

    if (adjusted >= 170) return Rarity.legendary;
    if (adjusted >= 130) return Rarity.epic;
    if (adjusted >= 100) return Rarity.rare;
    if (adjusted >= 70) return Rarity.uncommon;
    return Rarity.common;
  }

  /// Returns the Chimera definition that should result from merging [bones].
  /// If a Chimera of the resulting rarity is already in [unlockedChimeras],
  /// returns the next rarer undiscovered definition, or the highest unlocked one.
  static ChimeraDefinition resolveChimeraForMerge({
    required List<Bone> bones,
    required List<Chimera> unlockedChimeras,
  }) {
    assert(bones.length == 3);
    assert(bones.every((b) => b.epoch == bones.first.epoch));

    final epoch = bones.first.epoch;
    final targetRarity = _determineChimeraRarity(bones);
    final defs = definitionsForEpoch(epoch);
    final unlockedTypes = unlockedChimeras.map((c) => c.type).toSet();

    // Find a definition matching target rarity that isn't unlocked yet
    final preferred = defs.where(
      (d) => d.rarity == targetRarity && !unlockedTypes.contains(d.type),
    );
    if (preferred.isNotEmpty) return preferred.first;

    // Fall back to any undiscovered definition in the epoch
    final undiscovered = defs.where((d) => !unlockedTypes.contains(d.type));
    if (undiscovered.isNotEmpty) {
      // Return the closest rarity to the target
      return undiscovered.reduce((a, b) =>
          (a.rarity.index - targetRarity.index).abs() <=
                  (b.rarity.index - targetRarity.index).abs()
              ? a
              : b);
    }

    // All Chimeras of this epoch already unlocked — return a random duplicate
    return defs[_rng.nextInt(defs.length)];
  }

  /// Passive income per minute from the collection of unlocked Chimeras.
  static int totalPassiveIncome(List<Chimera> chimeras) =>
      chimeras.fold(0, (sum, c) => sum + c.incomePerMinute);

  /// How many Chimeras of [epoch] are in [chimeras].
  static int countForEpoch(List<Chimera> chimeras, Epoch epoch) =>
      chimeras.where((c) => c.epoch == epoch).length;

  /// Returns true if all 5 Chimeras of [epoch] are in [chimeras].
  static bool isEpochComplete(List<Chimera> chimeras, Epoch epoch) =>
      countForEpoch(chimeras, epoch) >= 5;

  /// Returns true if all 15 Chimeras are unlocked.
  static bool isFullCollectionComplete(List<Chimera> chimeras) =>
      chimeras.length >= ChimeraDefinition.all.length;

  static String generateChimeraId() {
    final rng = Random();
    return 'chimera_${DateTime.now().millisecondsSinceEpoch}_${rng.nextInt(9999)}';
  }
}

extension on Rarity {
  int get index {
    switch (this) {
      case Rarity.common: return 0;
      case Rarity.uncommon: return 1;
      case Rarity.rare: return 2;
      case Rarity.epic: return 3;
      case Rarity.legendary: return 4;
    }
  }
}
