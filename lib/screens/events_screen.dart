import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/bone.dart';
import '../models/event_model.dart';
import '../services/game_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../widgets/animated_background.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final GameService _gs = GameService.instance;

  @override
  void initState() {
    super.initState();
    _gs.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _gs.removeListener(_onStateChanged);
    super.dispose();
  }

  String _statusLabel(GameEvent event) {
    if (event.isCompleted) return AppStrings.eventCompleted;
    if (event.isActive && !event.isExpired) return AppStrings.eventActive;
    return AppStrings.eventLocked;
  }

  Color _statusColor(GameEvent event) {
    if (event.isCompleted) return AppColors.accentTeal;
    if (event.isActive && !event.isExpired) return AppColors.secondaryGlow;
    return AppColors.textHint;
  }

  Widget _buildEventCard(GameEvent event, int index) {
    final def = event.definition;
    final epoch = def.relatedEpoch;
    final epochColor = _epochColor(epoch);
    final isActive = event.isActive && !event.isExpired;
    final isCompleted = event.isCompleted;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            epochColor.withAlpha(isActive ? 30 : 12),
            AppColors.surfaceElevated,
          ],
        ),
        border: Border.all(
          color: isActive
              ? epochColor.withAlpha(200)
              : isCompleted
                  ? AppColors.accentTeal.withAlpha(120)
                  : AppColors.border,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: epochColor.withAlpha(50),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(def.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        def.name,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: epochColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            _epochEmoji(epoch),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _epochLabel(epoch),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: epochColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _statusColor(event).withAlpha(25),
                    border: Border.all(
                        color: _statusColor(event).withAlpha(120)),
                  ),
                  child: Text(
                    _statusLabel(event),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _statusColor(event),
                      fontSize: 11,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              def.description,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            // Bonus row
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondaryGlow.withAlpha(18),
                border: Border.all(
                    color: AppColors.secondaryGlow.withAlpha(80)),
              ),
              child: Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    def.bonusDescription,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryGlow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Trigger description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🔓', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    def.triggerDescription,
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
            // Countdown for active events
            if (isActive) ...[
              const SizedBox(height: 12),
              Container(height: 1, color: AppColors.border),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('⏳', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    AppStrings.endsIn,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    event.remainingSeconds.asHumanTime,
                    style: AppTextStyles.timerText.copyWith(
                      color: epochColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
            // Completion note
            if (isCompleted) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('✅', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    AppStrings.eventCompletedMessage,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentTeal,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
            delay: Duration(milliseconds: 100 * index),
            duration: 400.ms)
        .slideY(
            begin: 0.15,
            end: 0,
            delay: Duration(milliseconds: 100 * index),
            curve: Curves.easeOut);
  }

  Color _epochColor(Epoch epoch) {
    switch (epoch) {
      case Epoch.mesozoic: return AppColors.mesozoic;
      case Epoch.iceAge: return AppColors.iceAge;
      case Epoch.stoneAge: return AppColors.stoneAge;
    }
  }

  String _epochEmoji(Epoch epoch) {
    switch (epoch) {
      case Epoch.mesozoic: return '🌿';
      case Epoch.iceAge: return '❄️';
      case Epoch.stoneAge: return '🔥';
    }
  }

  String _epochLabel(Epoch epoch) {
    switch (epoch) {
      case Epoch.mesozoic: return 'Mesozoic';
      case Epoch.iceAge: return 'Ice Age';
      case Epoch.stoneAge: return 'Stone Age';
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _gs.events;

    return AnimatedBackground(
      accentColor: AppColors.secondaryGlow,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(AppStrings.eventsTitle,
                      style: AppTextStyles.headlineLarge)
                  .animate()
                  .fadeIn(duration: 400.ms),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              AppStrings.eventsSubtitle,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: events.length,
              itemBuilder: (_, i) => _buildEventCard(events[i], i),
            ),
          ),
        ],
      ),
    );
  }
}
