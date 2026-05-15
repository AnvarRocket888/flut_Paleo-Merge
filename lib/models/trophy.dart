class Trophy {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final TrophyTier tier;
  final String unlockCondition;
  bool isUnlocked;
  DateTime? unlockedAt;

  Trophy({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.tier,
    required this.unlockCondition,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  void applyJson(Map<String, dynamic> json) {
    isUnlocked = json['isUnlocked'] as bool? ?? false;
    final raw = json['unlockedAt'];
    unlockedAt = raw != null ? DateTime.parse(raw as String) : null;
  }

  static List<Trophy> defaultList() => [
        Trophy(
          id: 'bronze_excavator',
          name: 'Bronze Excavator',
          description: 'Awarded for creating your first Chimera from the Alchemical Forge.',
          emoji: '🥉',
          tier: TrophyTier.bronze,
          unlockCondition: 'Create your first Chimera',
        ),
        Trophy(
          id: 'silver_collector',
          name: 'Silver Collector',
          description: 'Awarded for assembling a collection of 5 magnificent Chimeras.',
          emoji: '🥈',
          tier: TrophyTier.silver,
          unlockCondition: 'Collect 5 Chimeras',
        ),
        Trophy(
          id: 'gold_paleontologist',
          name: 'Gold Paleontologist',
          description:
              'An honor bestowed upon those who have mastered the art of fossil alchemy with 10 Chimeras.',
          emoji: '🥇',
          tier: TrophyTier.gold,
          unlockCondition: 'Collect 10 Chimeras',
        ),
        Trophy(
          id: 'platinum_scholar',
          name: 'Platinum Scholar',
          description: 'Triggered all three ancient epoch events — a rare feat known to only the most dedicated paleomancers.',
          emoji: '🏅',
          tier: TrophyTier.platinum,
          unlockCondition: 'Trigger all 3 epoch events',
        ),
        Trophy(
          id: 'diamond_legend',
          name: 'Diamond Legend',
          description:
              'The ultimate trophy. You have gathered every Chimera across all epochs and written your name into the fossil record.',
          emoji: '💎',
          tier: TrophyTier.diamond,
          unlockCondition: 'Unlock all 15 Chimeras',
        ),
      ];
}

enum TrophyTier { bronze, silver, gold, platinum, diamond }

extension TrophyTierExtensions on TrophyTier {
  String get label {
    switch (this) {
      case TrophyTier.bronze:
        return 'Bronze';
      case TrophyTier.silver:
        return 'Silver';
      case TrophyTier.gold:
        return 'Gold';
      case TrophyTier.platinum:
        return 'Platinum';
      case TrophyTier.diamond:
        return 'Diamond';
    }
  }

  String get emoji {
    switch (this) {
      case TrophyTier.bronze:
        return '🥉';
      case TrophyTier.silver:
        return '🥈';
      case TrophyTier.gold:
        return '🥇';
      case TrophyTier.platinum:
        return '🏅';
      case TrophyTier.diamond:
        return '💎';
    }
  }
}
