import '../utils/constants.dart';

class PlayerData {
  int xp;
  int coins;
  int dust;
  int rank; // 1-based, 1 = Fossil Finder
  int streakDays;
  DateTime? lastActiveDate;
  int totalBonesCollected;
  int totalChimerasCreated;
  int totalBonesDisassembled;
  int totalPassiveCoinsEarned;
  int totalDustEverAccumulated;
  DateTime? lastSaved;

  PlayerData({
    required this.xp,
    required this.coins,
    required this.dust,
    required this.rank,
    required this.streakDays,
    this.lastActiveDate,
    this.totalBonesCollected = 0,
    this.totalChimerasCreated = 0,
    this.totalBonesDisassembled = 0,
    this.totalPassiveCoinsEarned = 0,
    this.totalDustEverAccumulated = 0,
    this.lastSaved,
  });

  factory PlayerData.initial() => PlayerData(
        xp: 0,
        coins: 0,
        dust: 0,
        rank: 1,
        streakDays: 0,
        lastActiveDate: DateTime.now(),
      );

  // ── XP / rank helpers ──────────────────────────────────────────────────────

  /// XP needed to reach the next rank threshold.
  int get xpForNextRank {
    if (rank >= AppNumerics.rankXpThresholds.length) return AppNumerics.rankXpThresholds.last;
    return AppNumerics.rankXpThresholds[rank]; // rank is 1-based; index = rank (next rank threshold)
  }

  /// XP at the start of the current rank.
  int get xpForCurrentRank {
    if (rank <= 1) return 0;
    return AppNumerics.rankXpThresholds[rank - 1];
  }

  /// Progress from 0.0 to 1.0 within current rank.
  double get rankProgress {
    if (rank >= AppNumerics.rankXpThresholds.length) return 1.0;
    final start = xpForCurrentRank;
    final end = xpForNextRank;
    if (end <= start) return 1.0;
    return ((xp - start) / (end - start)).clamp(0.0, 1.0);
  }

  bool get isMaxRank => rank >= AppNumerics.rankXpThresholds.length;

  String get rankName => AppStrings.rankNames[rank - 1];
  String get rankEmoji => AppStrings.rankEmojis[rank - 1];

  // ── Serialization ──────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'xp': xp,
        'coins': coins,
        'dust': dust,
        'rank': rank,
        'streakDays': streakDays,
        'lastActiveDate': lastActiveDate?.toIso8601String(),
        'totalBonesCollected': totalBonesCollected,
        'totalChimerasCreated': totalChimerasCreated,
        'totalBonesDisassembled': totalBonesDisassembled,
        'totalPassiveCoinsEarned': totalPassiveCoinsEarned,
        'totalDustEverAccumulated': totalDustEverAccumulated,
        'lastSaved': lastSaved?.toIso8601String(),
      };

  factory PlayerData.fromJson(Map<String, dynamic> json) => PlayerData(
        xp: json['xp'] as int? ?? 0,
        coins: json['coins'] as int? ?? 0,
        dust: json['dust'] as int? ?? 0,
        rank: json['rank'] as int? ?? 1,
        streakDays: json['streakDays'] as int? ?? 0,
        lastActiveDate: json['lastActiveDate'] != null
            ? DateTime.parse(json['lastActiveDate'] as String)
            : null,
        totalBonesCollected: json['totalBonesCollected'] as int? ?? 0,
        totalChimerasCreated: json['totalChimerasCreated'] as int? ?? 0,
        totalBonesDisassembled: json['totalBonesDisassembled'] as int? ?? 0,
        totalPassiveCoinsEarned: json['totalPassiveCoinsEarned'] as int? ?? 0,
        totalDustEverAccumulated: json['totalDustEverAccumulated'] as int? ?? 0,
        lastSaved: json['lastSaved'] != null
            ? DateTime.parse(json['lastSaved'] as String)
            : null,
      );
}
