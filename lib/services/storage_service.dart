import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bone.dart';
import '../models/chimera.dart';
import '../models/achievement.dart';
import '../models/trophy.dart';
import '../models/event_model.dart';
import '../models/player_data.dart';

/// Handles all SharedPreferences persistence for Paleo Merge.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const String _keyPlayerData = 'player_data';
  static const String _keyBones = 'bones';
  static const String _keyChimeras = 'chimeras';
  static const String _keyAchievements = 'achievements';
  static const String _keyTrophies = 'trophies';
  static const String _keyEvents = 'events';
  static const String _keyLastClose = 'last_close_time';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    assert(_prefs != null, 'StorageService.init() must be called first');
    return _prefs!;
  }

  // ── Player Data ────────────────────────────────────────────────────────────

  Future<void> savePlayerData(PlayerData data) async {
    await _p.setString(_keyPlayerData, jsonEncode(data.toJson()));
  }

  PlayerData? loadPlayerData() {
    final raw = _p.getString(_keyPlayerData);
    if (raw == null) return null;
    return PlayerData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  // ── Bones ──────────────────────────────────────────────────────────────────

  Future<void> saveBones(List<Bone> bones) async {
    final list = bones.map((b) => b.toJson()).toList();
    await _p.setString(_keyBones, jsonEncode(list));
  }

  List<Bone> loadBones() {
    final raw = _p.getString(_keyBones);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Bone.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Chimeras ───────────────────────────────────────────────────────────────

  Future<void> saveChimeras(List<Chimera> chimeras) async {
    final list = chimeras.map((c) => c.toJson()).toList();
    await _p.setString(_keyChimeras, jsonEncode(list));
  }

  List<Chimera> loadChimeras() {
    final raw = _p.getString(_keyChimeras);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Chimera.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Achievements ───────────────────────────────────────────────────────────

  Future<void> saveAchievements(List<Achievement> achievements) async {
    final map = {for (final a in achievements) a.id: a.toJson()};
    await _p.setString(_keyAchievements, jsonEncode(map));
  }

  Map<String, Map<String, dynamic>> loadAchievementData() {
    final raw = _p.getString(_keyAchievements);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry(k, v as Map<String, dynamic>),
    );
  }

  // ── Trophies ───────────────────────────────────────────────────────────────

  Future<void> saveTrophies(List<Trophy> trophies) async {
    final map = {for (final t in trophies) t.id: t.toJson()};
    await _p.setString(_keyTrophies, jsonEncode(map));
  }

  Map<String, Map<String, dynamic>> loadTrophyData() {
    final raw = _p.getString(_keyTrophies);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v as Map<String, dynamic>));
  }

  // ── Events ─────────────────────────────────────────────────────────────────

  Future<void> saveEvents(List<GameEvent> events) async {
    final list = events.map((e) => e.toJson()).toList();
    await _p.setString(_keyEvents, jsonEncode(list));
  }

  List<GameEvent> loadEvents() {
    final raw = _p.getString(_keyEvents);
    if (raw == null) return GameEvent.defaultList();
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => GameEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Offline time ───────────────────────────────────────────────────────────

  Future<void> saveCloseTime() async {
    await _p.setString(_keyLastClose, DateTime.now().toIso8601String());
  }

  DateTime? loadLastCloseTime() {
    final raw = _p.getString(_keyLastClose);
    if (raw == null) return null;
    return DateTime.parse(raw);
  }

  // ── Clear ──────────────────────────────────────────────────────────────────

  Future<void> clearAll() async {
    await _p.clear();
  }
}
