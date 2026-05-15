import '../models/achievement.dart';
import '../models/chimera.dart';
import '../models/player_data.dart';
import '../models/event_model.dart';
import '../models/bone.dart';

/// Checks game state and unlocks achievements.
class AchievementService {
  AchievementService._();
  static final AchievementService instance = AchievementService._();

  /// Evaluates all achievements against the current game state.
  /// Returns list of newly unlocked achievements.
  List<Achievement> evaluateAll({
    required List<Achievement> achievements,
    required PlayerData playerData,
    required List<Chimera> chimeras,
    required List<GameEvent> events,
    required List<Bone> bones,
    required int totalBonesCollected,
    required int totalChimerasCreated,
    required int totalBonesDisassembled,
    required int totalDustAccumulated,
    required int totalPassiveCoinsEarned,
  }) {
    final newlyUnlocked = <Achievement>[];

    for (final ach in achievements) {
      if (ach.isUnlocked) continue;

      final previousProgress = ach.currentProgress;
      _updateProgress(
        ach: ach,
        playerData: playerData,
        chimeras: chimeras,
        events: events,
        bones: bones,
        totalBonesCollected: totalBonesCollected,
        totalChimerasCreated: totalChimerasCreated,
        totalBonesDisassembled: totalBonesDisassembled,
        totalDustAccumulated: totalDustAccumulated,
        totalPassiveCoinsEarned: totalPassiveCoinsEarned,
      );

      if (!ach.isUnlocked && ach.progressTarget != null &&
          ach.currentProgress >= ach.progressTarget!) {
        ach.isUnlocked = true;
        ach.unlockedAt = DateTime.now();
        newlyUnlocked.add(ach);
      } else if (!ach.isUnlocked && ach.progressTarget == null && ach.currentProgress > previousProgress) {
        // one-shot
      }
    }

    return newlyUnlocked;
  }

  void _updateProgress({
    required Achievement ach,
    required PlayerData playerData,
    required List<Chimera> chimeras,
    required List<GameEvent> events,
    required List<Bone> bones,
    required int totalBonesCollected,
    required int totalChimerasCreated,
    required int totalBonesDisassembled,
    required int totalDustAccumulated,
    required int totalPassiveCoinsEarned,
  }) {
    switch (ach.type) {
      case AchievementType.collectBones:
        ach.currentProgress = totalBonesCollected;
      case AchievementType.createChimeras:
        ach.currentProgress = totalChimerasCreated;
      case AchievementType.disassembleBones:
        ach.currentProgress = totalBonesDisassembled;
      case AchievementType.mesozoicComplete:
        ach.currentProgress =
            chimeras.where((c) => c.epoch == Epoch.mesozoic).length;
      case AchievementType.iceAgeComplete:
        ach.currentProgress =
            chimeras.where((c) => c.epoch == Epoch.iceAge).length;
      case AchievementType.stoneAgeComplete:
        ach.currentProgress =
            chimeras.where((c) => c.epoch == Epoch.stoneAge).length;
      case AchievementType.triggerEvent:
        ach.currentProgress =
            events.where((e) => e.isActive || e.isCompleted).length;
      case AchievementType.legendaryBone:
        ach.currentProgress = totalBonesCollected > 0
            ? (bones.any((b) => b.rarity == Rarity.legendary) ||
                    ach.currentProgress > 0
                ? 1
                : 0)
            : 0;
      case AchievementType.reachRank:
        ach.currentProgress = playerData.rank;
      case AchievementType.streakDays:
        ach.currentProgress = playerData.streakDays;
      case AchievementType.epicChimera:
        ach.currentProgress =
            chimeras.any((c) => c.rarity == Rarity.epic || c.rarity == Rarity.legendary)
                ? 1
                : 0;
      case AchievementType.legendaryChimera:
        ach.currentProgress =
            chimeras.any((c) => c.rarity == Rarity.legendary) ? 1 : 0;
      case AchievementType.dustAccumulated:
        ach.currentProgress = totalDustAccumulated;
      case AchievementType.passiveIncome:
        ach.currentProgress = totalPassiveCoinsEarned;
      case AchievementType.allChimeras:
        ach.currentProgress = chimeras.length;
      case AchievementType.allEvents:
        ach.currentProgress = events.where((e) => e.isCompleted).length;
    }
  }
}
