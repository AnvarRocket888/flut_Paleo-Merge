import 'package:flutter/foundation.dart';

/// AppsFlyer event stubs — the real SDK will be integrated later.
/// All methods currently print to debug console only.
class AppsFlyerService {
  AppsFlyerService._();
  static final AppsFlyerService instance = AppsFlyerService._();

  // ── App lifecycle ──────────────────────────────────────────────────────────

  /// Fired once when the app launches and is fully initialised.
  void logAppLaunch(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    debugPrint('[AppsFlyer] app_launch — $params');
  }

  // ── Core feature usage ─────────────────────────────────────────────────────

  /// Fired each time a fossil bone is collected (spawned or offline recovery).
  void logBoneCollected(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: bone_type, epoch, rarity, total_bones_collected
    debugPrint('[AppsFlyer] bone_collected — $params');
  }

  /// Fired when the user disassembles a bone into dust.
  void logBoneDisassembled(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: bone_type, epoch, rarity, dust_gained, total_dust
    debugPrint('[AppsFlyer] bone_disassembled — $params');
  }

  /// Fired when the user crafts a bone from dust.
  void logBoneCrafted(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: bone_type, epoch, rarity, dust_spent
    debugPrint('[AppsFlyer] bone_crafted — $params');
  }

  /// Fired when the user successfully merges 3 bones into a Chimera.
  void logChimeraCreated(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: chimera_name, epoch, rarity, income_per_min, total_chimeras
    debugPrint('[AppsFlyer] chimera_created — $params');
  }

  /// Fired when the player opens the Merge/Forge screen.
  void logMergeScreenOpened(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    debugPrint('[AppsFlyer] merge_screen_opened — $params');
  }

  /// Fired when the player opens the Chimeras collection screen.
  void logChimerasScreenOpened(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    debugPrint('[AppsFlyer] chimeras_screen_opened — $params');
  }

  // ── Gamification events ────────────────────────────────────────────────────

  /// Fired when an achievement is unlocked.
  void logAchievementUnlocked(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: achievement_id, achievement_name, xp_reward, total_achievements
    debugPrint('[AppsFlyer] achievement_unlocked — $params');
  }

  /// Fired when the player levels up / ranks up.
  void logRankUp(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: new_rank, rank_name, total_xp
    debugPrint('[AppsFlyer] rank_up — $params');
  }

  /// Fired when a trophy is earned.
  void logTrophyEarned(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: trophy_id, trophy_name, trophy_tier
    debugPrint('[AppsFlyer] trophy_earned — $params');
  }

  /// Fired when a special epoch event is activated.
  void logEventActivated(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: event_type, event_name, epoch
    debugPrint('[AppsFlyer] event_activated — $params');
  }

  /// Fired when a special epoch event expires after 24 hours.
  void logEventCompleted(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: event_type, event_name
    debugPrint('[AppsFlyer] event_completed — $params');
  }

  /// Fired when the player's streak increases.
  void logStreakUpdate(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: streak_days
    debugPrint('[AppsFlyer] streak_update — $params');
  }

  // ── Economy ────────────────────────────────────────────────────────────────

  /// Fired when the player earns coins (from any source).
  void logCoinsEarned(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: amount, source (passive/merge/event), total_coins
    debugPrint('[AppsFlyer] coins_earned — $params');
  }

  // ── Offline / session ──────────────────────────────────────────────────────

  /// Fired when offline bones are recovered on app resume.
  void logOfflineBoneRecovery(Map<String, dynamic> params) {
    // TODO: replace with real AppsFlyer SDK call
    // Expected keys: bones_recovered, offline_minutes
    debugPrint('[AppsFlyer] offline_bone_recovery — $params');
  }
}
