class Achievement {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int xpReward;
  final AchievementType type;
  final int? progressTarget; // null for one-shot achievements
  bool isUnlocked;
  int currentProgress;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.xpReward,
    required this.type,
    this.progressTarget,
    this.isUnlocked = false,
    this.currentProgress = 0,
    this.unlockedAt,
  });

  bool get hasProgress => progressTarget != null;
  double get progressRatio =>
      progressTarget == null ? (isUnlocked ? 1.0 : 0.0) : (currentProgress / progressTarget!).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
        'id': id,
        'isUnlocked': isUnlocked,
        'currentProgress': currentProgress,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  void applyJson(Map<String, dynamic> json) {
    isUnlocked = json['isUnlocked'] as bool? ?? false;
    currentProgress = json['currentProgress'] as int? ?? 0;
    final raw = json['unlockedAt'];
    unlockedAt = raw != null ? DateTime.parse(raw as String) : null;
  }

  static List<Achievement> defaultList() => [
        Achievement(
          id: 'first_fossil',
          name: 'First Fossil',
          description: 'Collect your very first bone.',
          emoji: '🦴',
          xpReward: 10,
          type: AchievementType.collectBones,
          progressTarget: 1,
        ),
        Achievement(
          id: 'first_chimera',
          name: 'First Chimera',
          description: 'Create your first Chimera in the Alchemical Forge.',
          emoji: '🐉',
          xpReward: 25,
          type: AchievementType.createChimeras,
          progressTarget: 1,
        ),
        Achievement(
          id: 'bone_hoarder',
          name: 'Bone Hoarder',
          description: 'Collect 10 fossil bones.',
          emoji: '🦷',
          xpReward: 20,
          type: AchievementType.collectBones,
          progressTarget: 10,
        ),
        Achievement(
          id: 'chimera_collector',
          name: 'Chimera Collector',
          description: 'Create 5 Chimeras.',
          emoji: '🔮',
          xpReward: 40,
          type: AchievementType.createChimeras,
          progressTarget: 5,
        ),
        Achievement(
          id: 'dust_to_dust',
          name: 'Dust to Dust',
          description: 'Disassemble your first bone into dust.',
          emoji: '✨',
          xpReward: 15,
          type: AchievementType.disassembleBones,
          progressTarget: 1,
        ),
        Achievement(
          id: 'mesozoic_master',
          name: 'Mesozoic Master',
          description: 'Unlock all 5 Mesozoic Chimeras.',
          emoji: '🌿',
          xpReward: 75,
          type: AchievementType.mesozoicComplete,
          progressTarget: 5,
        ),
        Achievement(
          id: 'ice_age_survivor',
          name: 'Ice Age Survivor',
          description: 'Unlock all 5 Ice Age Chimeras.',
          emoji: '❄️',
          xpReward: 75,
          type: AchievementType.iceAgeComplete,
          progressTarget: 5,
        ),
        Achievement(
          id: 'stone_age_scholar',
          name: 'Stone Age Scholar',
          description: 'Unlock all 5 Stone Age Chimeras.',
          emoji: '🔥',
          xpReward: 75,
          type: AchievementType.stoneAgeComplete,
          progressTarget: 5,
        ),
        Achievement(
          id: 'event_trigger',
          name: 'Event Trigger',
          description: 'Activate your first special event.',
          emoji: '⚡',
          xpReward: 50,
          type: AchievementType.triggerEvent,
          progressTarget: 1,
        ),
        Achievement(
          id: 'legendary_find',
          name: 'Legendary Find',
          description: 'Obtain a Legendary-rarity fossil bone.',
          emoji: '🌟',
          xpReward: 60,
          type: AchievementType.legendaryBone,
          progressTarget: 1,
        ),
        Achievement(
          id: 'level_5',
          name: 'Chimera Crafter',
          description: 'Reach rank 5 — Chimera Crafter.',
          emoji: '⭐',
          xpReward: 50,
          type: AchievementType.reachRank,
          progressTarget: 5,
        ),
        Achievement(
          id: 'streak_week',
          name: 'Streak Week',
          description: 'Maintain a 7-day activity streak.',
          emoji: '🔥',
          xpReward: 70,
          type: AchievementType.streakDays,
          progressTarget: 7,
        ),
        Achievement(
          id: 'chimera_king',
          name: 'Chimera King',
          description: 'Unlock 15 Chimeras.',
          emoji: '👑',
          xpReward: 100,
          type: AchievementType.createChimeras,
          progressTarget: 15,
        ),
        Achievement(
          id: 'epic_forger',
          name: 'Epic Forger',
          description: 'Create an Epic-rarity Chimera.',
          emoji: '🟣',
          xpReward: 80,
          type: AchievementType.epicChimera,
          progressTarget: 1,
        ),
        Achievement(
          id: 'legendary_forger',
          name: 'Legendary Forger',
          description: 'Create a Legendary-rarity Chimera.',
          emoji: '🌑',
          xpReward: 150,
          type: AchievementType.legendaryChimera,
          progressTarget: 1,
        ),
        Achievement(
          id: 'dust_master',
          name: 'Dust Master',
          description: 'Accumulate 100 dust.',
          emoji: '💫',
          xpReward: 35,
          type: AchievementType.dustAccumulated,
          progressTarget: 100,
        ),
        Achievement(
          id: 'passive_tycoon',
          name: 'Passive Tycoon',
          description: 'Earn 1,000 coins from passive Chimera income.',
          emoji: '🪙',
          xpReward: 60,
          type: AchievementType.passiveIncome,
          progressTarget: 1000,
        ),
        Achievement(
          id: 'grand_collection',
          name: 'Grand Collection',
          description: 'Unlock all 15 Chimeras.',
          emoji: '🏛️',
          xpReward: 200,
          type: AchievementType.allChimeras,
          progressTarget: 15,
        ),
        Achievement(
          id: 'event_master',
          name: 'Event Master',
          description: 'Complete all 3 special events.',
          emoji: '🗺️',
          xpReward: 150,
          type: AchievementType.allEvents,
          progressTarget: 3,
        ),
        Achievement(
          id: 'ancient_one',
          name: 'Ancient One',
          description: 'Reach the maximum rank — Fossil Legend.',
          emoji: '🌌',
          xpReward: 300,
          type: AchievementType.reachRank,
          progressTarget: 8,
        ),
      ];
}

enum AchievementType {
  collectBones,
  createChimeras,
  disassembleBones,
  mesozoicComplete,
  iceAgeComplete,
  stoneAgeComplete,
  triggerEvent,
  legendaryBone,
  reachRank,
  streakDays,
  epicChimera,
  legendaryChimera,
  dustAccumulated,
  passiveIncome,
  allChimeras,
  allEvents,
}
