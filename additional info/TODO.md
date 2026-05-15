# Paleo Merge — TODO & Future Work

## Not Yet Implemented (Stubs)

### AppsFlyer Integration
- Replace all `debugPrint` stubs in `lib/services/appsflyer_service.dart` with real AppsFlyer SDK calls
- Add `appsflyer_sdk` Flutter package when ready for production
- Events to wire: bone_collected, bones_merged, chimera_unlocked, achievement_unlocked, rank_up, event_started

### Push Notifications
- `scripts/setup_notifications.sh` sets up basic capability but no actual scheduling
- Implement local notifications via `flutter_local_notifications` package
- Suggested triggers: bone spawned while app is closed, event activated, daily streak reminder

### Missing Widget Files
- `lib/widgets/epoch_badge.dart` — small pill badge with epoch emoji + colored background
- `lib/widgets/rarity_badge.dart` — small pill badge with rarity star + colored background

## App Store / Distribution
- Set up correct Bundle ID and team in Xcode
- Replace placeholder app icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Add launch screen images to `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- Configure `fastlane/Appfile` with real Apple ID and bundle identifier
- Run `bundle exec fastlane deliver` for App Store Connect metadata

## Quality & Polish
- Add haptic feedback (via `HapticFeedback.lightImpact()`) on bone tap, merge, achievement
- Add sound effects stub (use `audioplayers` package or AVAudioPlayer via platform channel)
- Accessibility: add semantic labels to all emoji-only widgets
- App Store Review prompt via `in_app_review` package after ~5 chimeras collected
- iCloud sync for player data via `icloud_storage` package (optional)

## Analytics / Monitoring
- Integrate Firebase Analytics or Mixpanel for funnel analysis
- Track: D1/D7/D30 retention, merge funnel, achievement completion rates

## Testing
- Write unit tests for `GameService` (bone spawning, merge logic, XP calculation)
- Widget tests for key screens (home_screen, merge_screen)
- Integration test: full merge flow

## Known Warnings (non-blocking)
- Several `info`-level lint hints (unnecessary underscores in private classes, for-loop braces) — cosmetic only
