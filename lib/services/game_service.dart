import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../models/bone.dart';
import '../models/chimera.dart';
import '../models/achievement.dart';
import '../models/trophy.dart';
import '../models/event_model.dart';
import '../models/player_data.dart';
import '../utils/constants.dart';
import 'storage_service.dart';
import 'chimera_service.dart';
import 'achievement_service.dart';
import 'appsflyer_service.dart';

/// Central game state manager. Singleton ChangeNotifier.
/// All screens listen to this and rebuild on state changes.
class GameService extends ChangeNotifier with WidgetsBindingObserver {
  GameService._internal();
  static final GameService instance = GameService._internal();

  // ── State ──────────────────────────────────────────────────────────────────
  late PlayerData _playerData;
  final List<Bone> _bones = [];
  final List<Chimera> _chimeras = [];
  late List<Achievement> _achievements;
  late List<Trophy> _trophies;
  late List<GameEvent> _events;

  int _boneTimerSeconds = AppNumerics.boneSpawnIntervalSeconds;
  bool _initialized = false;

  Timer? _boneTimer;
  Timer? _incomeTimer;
  Timer? _tickTimer;

  // ── Callbacks (set by MainScreen overlay) ─────────────────────────────────
  void Function(Achievement)? onAchievementUnlocked;
  void Function(String rankName, String rankEmoji)? onRankUp;
  void Function(GameEvent)? onEventStarted;

  // ── Public getters ─────────────────────────────────────────────────────────
  PlayerData get playerData => _playerData;
  List<Bone> get bones => List.unmodifiable(_bones);
  List<Chimera> get chimeras => List.unmodifiable(_chimeras);
  List<Achievement> get achievements => List.unmodifiable(_achievements);
  List<Trophy> get trophies => List.unmodifiable(_trophies);
  List<GameEvent> get events => List.unmodifiable(_events);
  int get boneTimerSeconds => _boneTimerSeconds;
  bool get isInitialized => _initialized;
  bool get isBoneFrenzy => _events.any(
      (e) => e.isActive && !e.isExpired && e.type == EventType.frozenFrenzy);
  bool get isDoubleCoins => _events.any(
      (e) => e.isActive && !e.isExpired && e.type == EventType.jurassicSurge);
  bool get isDoubleXP => _events.any(
      (e) => e.isActive && !e.isExpired && e.type == EventType.primalPower);

  // ── Initialise ─────────────────────────────────────────────────────────────
  Future<void> initialize() async {
    if (_initialized) return;

    await StorageService.instance.init();
    _playerData = StorageService.instance.loadPlayerData() ?? PlayerData.initial();
    final savedBones = StorageService.instance.loadBones();
    _bones.addAll(savedBones);

    final savedChimeras = StorageService.instance.loadChimeras();
    _chimeras.addAll(savedChimeras);

    _achievements = Achievement.defaultList();
    final achData = StorageService.instance.loadAchievementData();
    for (final ach in _achievements) {
      if (achData.containsKey(ach.id)) ach.applyJson(achData[ach.id]!);
    }

    _trophies = Trophy.defaultList();
    final trophyData = StorageService.instance.loadTrophyData();
    for (final t in _trophies) {
      if (trophyData.containsKey(t.id)) t.applyJson(trophyData[t.id]!);
    }

    _events = StorageService.instance.loadEvents();

    _checkAndExpireEvents();
    _recoverOfflineBones();
    _updateStreak();
    _startTimers();

    WidgetsBinding.instance.addObserver(this);
    _initialized = true;

    AppsFlyerService.instance.logAppLaunch({
      'rank': _playerData.rank,
      'total_chimeras': _chimeras.length,
      'total_bones': _bones.length,
    });

    notifyListeners();
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      StorageService.instance.saveCloseTime();
      _save();
    } else if (state == AppLifecycleState.resumed) {
      _checkAndExpireEvents();
      _recoverOfflineBones();
      _updateStreak();
      notifyListeners();
    }
  }

  // ── Offline recovery ───────────────────────────────────────────────────────
  void _recoverOfflineBones() {
    final lastClose = StorageService.instance.loadLastCloseTime();
    if (lastClose == null) return;
    final elapsed = DateTime.now().difference(lastClose).inSeconds;
    if (elapsed <= 0) return;

    final interval = isBoneFrenzy
        ? AppNumerics.boneSpawnFrenzySeconds
        : AppNumerics.boneSpawnIntervalSeconds;
    final bonesToAdd = (elapsed ~/ interval)
        .clamp(0, AppNumerics.maxOfflineBones);
    if (bonesToAdd <= 0) return;

    final added = <Bone>[];
    for (int i = 0; i < bonesToAdd; i++) {
      if (_bones.length >= AppNumerics.maxBoneInventory) break;
      final bone = Bone.random();
      _bones.add(bone);
      added.add(bone);
    }

    if (added.isNotEmpty) {
      _playerData.totalBonesCollected += added.length;
      AppsFlyerService.instance.logOfflineBoneRecovery({
        'bones_recovered': added.length,
        'offline_minutes': elapsed ~/ 60,
      });
    }
  }

  // ── Streak ─────────────────────────────────────────────────────────────────
  void _updateStreak() {
    final now = DateTime.now();
    final last = _playerData.lastActiveDate;
    if (last == null) {
      _playerData.lastActiveDate = now;
      _playerData.streakDays = 1;
      return;
    }

    final daysSince = now.difference(last).inDays;
    if (daysSince == 1) {
      _playerData.streakDays += 1;
      AppsFlyerService.instance
          .logStreakUpdate({'streak_days': _playerData.streakDays});
    } else if (daysSince > 1) {
      _playerData.streakDays = 1;
    }
    _playerData.lastActiveDate = now;
  }

  // ── Timers ─────────────────────────────────────────────────────────────────
  void _startTimers() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });

    _incomeTimer?.cancel();
    _incomeTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _collectPassiveIncome();
    });
  }

  void _tick() {
    _boneTimerSeconds--;
    if (_boneTimerSeconds <= 0) {
      _spawnBone();
      final interval = isBoneFrenzy
          ? AppNumerics.boneSpawnFrenzySeconds
          : AppNumerics.boneSpawnIntervalSeconds;
      _boneTimerSeconds = interval;
    }
    notifyListeners();
  }

  // ── Bone spawning ──────────────────────────────────────────────────────────
  void _spawnBone() {
    if (_bones.length >= AppNumerics.maxBoneInventory) return;
    final bone = Bone.random();
    _bones.add(bone);
    _playerData.totalBonesCollected++;
    AppsFlyerService.instance.logBoneCollected({
      'bone_type': bone.type.name,
      'epoch': bone.epoch.name,
      'rarity': bone.rarity.name,
      'total_bones_collected': _playerData.totalBonesCollected,
    });
    _checkAchievements();
    _save();
    notifyListeners();
  }

  // ── Disassemble bone ───────────────────────────────────────────────────────
  void disassembleBone(String boneId) {
    final idx = _bones.indexWhere((b) => b.id == boneId);
    if (idx < 0) return;
    final bone = _bones.removeAt(idx);
    final dustGained =
        AppNumerics.dustFromDisassemble[bone.rarity.index2] ?? 1;
    _playerData.dust += dustGained;
    _playerData.totalBonesDisassembled++;
    _playerData.totalDustEverAccumulated += dustGained;
    AppsFlyerService.instance.logBoneDisassembled({
      'bone_type': bone.type.name,
      'epoch': bone.epoch.name,
      'rarity': bone.rarity.name,
      'dust_gained': dustGained,
      'total_dust': _playerData.dust,
    });
    _checkAchievements();
    _save();
    notifyListeners();
  }

  // ── Craft bone ─────────────────────────────────────────────────────────────
  bool craftBone(BoneType type, Epoch epoch, Rarity rarity) {
    if (_bones.length >= AppNumerics.maxBoneInventory) return false;
    final cost = AppNumerics.dustToCraft[rarity.index2] ?? 5;
    if (_playerData.dust < cost) return false;
    _playerData.dust -= cost;
    final bone = Bone(
      id: '${DateTime.now().millisecondsSinceEpoch}_crafted',
      type: type,
      epoch: epoch,
      rarity: rarity,
      collectedAt: DateTime.now(),
    );
    _bones.add(bone);
    _playerData.totalBonesCollected++;
    AppsFlyerService.instance.logBoneCrafted({
      'bone_type': type.name,
      'epoch': epoch.name,
      'rarity': rarity.name,
      'dust_spent': cost,
    });
    _checkAchievements();
    _save();
    notifyListeners();
    return true;
  }

  // ── Merge bones → chimera ──────────────────────────────────────────────────
  /// Validates that the 3 bone ids are valid and same-epoch.
  bool canMerge(List<String> boneIds) {
    if (boneIds.length != 3) return false;
    final selected = boneIds
        .map((id) => _bones.firstWhere((b) => b.id == id,
            orElse: () => throw StateError('Bone not found: $id')))
        .toList();
    return selected.every((b) => b.epoch == selected.first.epoch);
  }

  /// Merges 3 bones (by id) into a Chimera. Returns the new Chimera or null.
  Chimera? mergeBones(List<String> boneIds) {
    if (!canMerge(boneIds)) return null;

    final selected =
        boneIds.map((id) => _bones.firstWhere((b) => b.id == id)).toList();

    // Remove bones
    for (final b in selected) _bones.remove(b);

    // Determine resulting chimera
    final def = ChimeraService.resolveChimeraForMerge(
      bones: selected,
      unlockedChimeras: _chimeras,
    );

    final chimera = Chimera(
      id: ChimeraService.generateChimeraId(),
      type: def.type,
      unlockedAt: DateTime.now(),
    );
    _chimeras.add(chimera);

    // XP reward
    int xpGain = AppNumerics.xpPerMerge;
    if (def.rarity == Rarity.rare) xpGain += AppNumerics.xpBonusRareChimera;
    if (def.rarity == Rarity.epic) xpGain += AppNumerics.xpBonusEpicChimera;
    if (def.rarity == Rarity.legendary) {
      xpGain += AppNumerics.xpBonusLegendaryChimera;
    }
    if (isDoubleXP) xpGain *= 2;
    _addXP(xpGain);

    _playerData.totalChimerasCreated++;

    AppsFlyerService.instance.logChimeraCreated({
      'chimera_name': chimera.name,
      'epoch': chimera.epoch.name,
      'rarity': chimera.rarity.name,
      'income_per_min': chimera.incomePerMinute,
      'total_chimeras': _chimeras.length,
    });

    _checkAndTriggerEvents();
    _checkAchievements();
    _checkTrophies();
    _save();
    notifyListeners();
    return chimera;
  }

  // ── Passive income ─────────────────────────────────────────────────────────
  void _collectPassiveIncome() {
    if (_chimeras.isEmpty) return;
    int income = ChimeraService.totalPassiveIncome(_chimeras);
    if (isDoubleCoins) income *= 2;
    _playerData.coins += income;
    _playerData.totalPassiveCoinsEarned += income;
    AppsFlyerService.instance.logCoinsEarned({
      'amount': income,
      'source': 'passive',
      'total_coins': _playerData.coins,
    });
    _checkAchievements();
    _save();
    notifyListeners();
  }

  // ── XP / rank ──────────────────────────────────────────────────────────────
  void _addXP(int amount) {
    _playerData.xp += amount;
    _checkRankUp();
  }

  void _checkRankUp() {
    while (!_playerData.isMaxRank &&
        _playerData.xp >= _playerData.xpForNextRank) {
      _playerData.rank++;
      AppsFlyerService.instance.logRankUp({
        'new_rank': _playerData.rank,
        'rank_name': _playerData.rankName,
        'total_xp': _playerData.xp,
      });
      onRankUp?.call(_playerData.rankName, _playerData.rankEmoji);
      _checkAchievements();
    }
  }

  // ── Events ─────────────────────────────────────────────────────────────────
  void _checkAndTriggerEvents() {
    for (final event in _events) {
      if (event.isActive || event.isCompleted) continue;
      bool shouldActivate = false;
      switch (event.type) {
        case EventType.jurassicSurge:
          shouldActivate =
              ChimeraService.isEpochComplete(_chimeras, Epoch.mesozoic);
        case EventType.frozenFrenzy:
          shouldActivate =
              ChimeraService.isEpochComplete(_chimeras, Epoch.iceAge);
        case EventType.primalPower:
          shouldActivate =
              ChimeraService.isEpochComplete(_chimeras, Epoch.stoneAge);
      }
      if (shouldActivate) {
        event.isActive = true;
        event.activatedAt = DateTime.now();
        AppsFlyerService.instance.logEventActivated({
          'event_type': event.type.name,
          'event_name': event.definition.name,
          'epoch': event.definition.relatedEpoch.name,
        });
        onEventStarted?.call(event);
        _checkAchievements();
      }
    }
  }

  void _checkAndExpireEvents() {
    for (final event in _events) {
      if (event.isActive && event.isExpired) {
        event.isActive = false;
        event.isCompleted = true;
        AppsFlyerService.instance.logEventCompleted({
          'event_type': event.type.name,
          'event_name': event.definition.name,
        });
        _checkAchievements();
      }
    }
  }

  // ── Achievements ───────────────────────────────────────────────────────────
  void _checkAchievements() {
    final newlyUnlocked = AchievementService.instance.evaluateAll(
      achievements: _achievements,
      playerData: _playerData,
      chimeras: _chimeras,
      events: _events,
      bones: _bones,
      totalBonesCollected: _playerData.totalBonesCollected,
      totalChimerasCreated: _playerData.totalChimerasCreated,
      totalBonesDisassembled: _playerData.totalBonesDisassembled,
      totalDustAccumulated: _playerData.totalDustEverAccumulated,
      totalPassiveCoinsEarned: _playerData.totalPassiveCoinsEarned,
    );
    for (final ach in newlyUnlocked) {
      _addXP(ach.xpReward);
      AppsFlyerService.instance.logAchievementUnlocked({
        'achievement_id': ach.id,
        'achievement_name': ach.name,
        'xp_reward': ach.xpReward,
        'total_achievements': _achievements.where((a) => a.isUnlocked).length,
      });
      onAchievementUnlocked?.call(ach);
    }
  }

  // ── Trophies ───────────────────────────────────────────────────────────────
  void _checkTrophies() {
    final newlyEarned = <Trophy>[];

    for (final t in _trophies) {
      if (t.isUnlocked) continue;
      bool earn = false;
      switch (t.id) {
        case 'bronze_excavator':
          earn = _playerData.totalChimerasCreated >= 1;
        case 'silver_collector':
          earn = _chimeras.length >= 5;
        case 'gold_paleontologist':
          earn = _chimeras.length >= 10;
        case 'platinum_scholar':
          earn = _events.every((e) => e.isActive || e.isCompleted);
        case 'diamond_legend':
          earn = ChimeraService.isFullCollectionComplete(_chimeras);
      }
      if (earn) {
        t.isUnlocked = true;
        t.unlockedAt = DateTime.now();
        newlyEarned.add(t);
        AppsFlyerService.instance.logTrophyEarned({
          'trophy_id': t.id,
          'trophy_name': t.name,
          'trophy_tier': t.tier.name,
        });
      }
    }
  }

  // ── Persistence ────────────────────────────────────────────────────────────
  Future<void> _save() async {
    _playerData.lastSaved = DateTime.now();
    await Future.wait([
      StorageService.instance.savePlayerData(_playerData),
      StorageService.instance.saveBones(_bones),
      StorageService.instance.saveChimeras(_chimeras),
      StorageService.instance.saveAchievements(_achievements),
      StorageService.instance.saveTrophies(_trophies),
      StorageService.instance.saveEvents(_events),
    ]);
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _incomeTimer?.cancel();
    _boneTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

extension on Rarity {
  int get index2 {
    switch (this) {
      case Rarity.common: return 0;
      case Rarity.uncommon: return 1;
      case Rarity.rare: return 2;
      case Rarity.epic: return 3;
      case Rarity.legendary: return 4;
    }
  }
}
