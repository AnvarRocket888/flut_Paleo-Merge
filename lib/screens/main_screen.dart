import 'package:flutter/cupertino.dart';
import '../models/achievement.dart';
import '../models/event_model.dart';
import '../services/game_service.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/achievement_toast.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/rank_up_celebration.dart';
import 'achievements_screen.dart';
import 'chimeras_screen.dart';
import 'events_screen.dart';
import 'home_screen.dart';
import 'merge_screen.dart';

/// Root navigation screen.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GameService _gs = GameService.instance;
  int _currentIndex = 0;

  // Toast / celebration state
  Achievement? _pendingToast;
  bool _showingToast = false;
  bool _showingRankUp = false;
  String? _rankUpName;
  String? _rankUpEmoji;
  int? _rankUpNumber;

  final List<Widget> _pages = const [
    HomeScreen(),
    MergeScreen(),
    ChimerasScreen(),
    AchievementsScreen(),
    EventsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Wire up game callbacks
    _gs.onAchievementUnlocked = _handleAchievementUnlocked;
    _gs.onRankUp = _handleRankUp;
    _gs.onEventStarted = _handleEventStarted;
  }

  @override
  void dispose() {
    // Clear callbacks
    if (_gs.onAchievementUnlocked == _handleAchievementUnlocked) {
      _gs.onAchievementUnlocked = null;
    }
    if (_gs.onRankUp == _handleRankUp) {
      _gs.onRankUp = null;
    }
    if (_gs.onEventStarted == _handleEventStarted) {
      _gs.onEventStarted = null;
    }
    super.dispose();
  }

  void _handleAchievementUnlocked(Achievement achievement) {
    if (!mounted) return;
    setState(() {
      _pendingToast = achievement;
      _showingToast = true;
    });
  }

  void _handleRankUp(String rankName, String rankEmoji) {
    if (!mounted) return;
    setState(() {
      _rankUpName = rankName;
      _rankUpEmoji = rankEmoji;
      _rankUpNumber = _gs.playerData.rank;
      _showingRankUp = true;
    });
  }

  void _handleEventStarted(GameEvent event) {
    if (!mounted) return;
    if (!_showingToast) {
      showCupertinoDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('⚡ Event Started!'),
          content: Text(event.definition.name),
          actions: [
            CupertinoDialogAction(
              child: const Text(AppStrings.ok),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  void _dismissToast() {
    setState(() {
      _showingToast = false;
      _pendingToast = null;
    });
  }

  void _dismissRankUp() {
    setState(() {
      _showingRankUp = false;
      _rankUpName = null;
      _rankUpEmoji = null;
      _rankUpNumber = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: Stack(
        children: [
          // Page content + bottom nav
          Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: _pages,
                ),
              ),
              CustomBottomNav(
                currentIndex: _currentIndex,
                onTap: (i) => setState(() => _currentIndex = i),
              ),
            ],
          ),

          // Achievement toast overlay (top)
          if (_showingToast && _pendingToast != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 0,
              right: 0,
              child: AchievementToast(
                achievement: _pendingToast!,
                onDismiss: _dismissToast,
              ),
            ),

          // Rank-up full-screen overlay
          if (_showingRankUp &&
              _rankUpName != null &&
              _rankUpEmoji != null &&
              _rankUpNumber != null)
            Positioned.fill(
              child: RankUpCelebration(
                rankName: _rankUpName!,
                rankEmoji: _rankUpEmoji!,
                rankNumber: _rankUpNumber!,
                onDismiss: _dismissRankUp,
              ),
            ),
        ],
      ),
    );
  }
}
