import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/bone.dart';
import '../services/game_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../widgets/animated_background.dart';
import '../widgets/bone_card.dart';
import '../widgets/xp_bar.dart';
import '../widgets/coin_display.dart';
import 'how_to_play_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _toggleBoneSelection(String boneId) {
    final bone = _gs.bones.firstWhere((b) => b.id == boneId);
    // Count currently selected
    final selectedCount = _gs.bones.where((b) => b.isSelected).length;

    if (bone.isSelected) {
      // Deselect
      GameService.instance.bones
          .firstWhere((b) => b.id == boneId)
          .isSelected = false;
    } else {
      if (selectedCount < 3) {
        GameService.instance.bones
            .firstWhere((b) => b.id == boneId)
            .isSelected = true;
      }
    }
    setState(() {});
  }

  void _showBoneActionSheet(Bone bone) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(
          '${bone.type.emoji} ${bone.type.label} — ${bone.rarity.label}',
          style: AppTextStyles.headlineSmall,
        ),
        message: Text(
          '${bone.epoch.emoji} ${bone.epoch.label} epoch\n'
          'Disassemble for ${AppNumerics.dustFromDisassemble[bone.rarity.index2] ?? 1} dust',
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _gs.disassembleBone(bone.id);
            },
            isDestructiveAction: true,
            child: Text(
              '${AppStrings.disassemble} (+${AppNumerics.dustFromDisassemble[bone.rarity.index2] ?? 1} ✨)',
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    final seconds = _gs.boneTimerSeconds;
    final isFrenzy = _gs.isBoneFrenzy;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceElevated,
        border: Border.all(
          color: isFrenzy
              ? AppColors.iceAge.withAlpha(150)
              : AppColors.border,
        ),
        boxShadow: isFrenzy
            ? [
                BoxShadow(
                  color: AppColors.iceAge.withAlpha(60),
                  blurRadius: 12,
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.nextBoneIn,
                style: AppTextStyles.labelSmall,
              ),
              const SizedBox(height: 4),
              Text(
                seconds.asTimer,
                style: AppTextStyles.timerText,
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isFrenzy)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.iceAge.withAlpha(40),
                    border: Border.all(
                        color: AppColors.iceAge.withAlpha(150), width: 1),
                  ),
                  child: Text(
                    '❄️ FRENZY',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.iceAgeGlow,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                '${_gs.bones.length}/${AppNumerics.maxBoneInventory} bones',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final p = _gs.playerData;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          CoinDisplay(coins: p.coins),
          const SizedBox(width: 16),
          DustDisplay(dust: p.dust),
          const Spacer(),
          StreakDisplay(streakDays: p.streakDays),
        ],
      ),
    );
  }

  Widget _buildXpSection() {
    final p = _gs.playerData;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: XpBar(
        progress: p.rankProgress,
        currentXp: p.xp,
        nextRankXp: p.isMaxRank ? p.xp : p.xpForNextRank,
        rankName: p.rankName,
        rankEmoji: p.rankEmoji,
        rank: p.rank,
      ),
    );
  }

  Widget _buildActiveEventsBanner() {
    final active = _gs.events.where((e) => e.isActive && !e.isExpired);
    if (active.isEmpty) return const SizedBox.shrink();
    return Column(
      children: active.map((e) {
        final def = e.definition;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                def.relatedEpoch.color.withAlpha(40),
                AppColors.surfaceElevated,
              ],
            ),
            border: Border.all(
                color: def.relatedEpoch.color.withAlpha(150), width: 1),
          ),
          child: Row(
            children: [
              Text(def.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${def.name}: ${def.bonusDescription}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: def.relatedEpoch.color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                e.remainingSeconds.asHumanTime,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBoneGrid() {
    final bones = _gs.bones;
    if (bones.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🦴', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(
                AppStrings.noBones,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms),
      );
    }

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width >= 768 ? 5 : 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.78,
        ),
        itemCount: bones.length,
        itemBuilder: (_, i) => BoneCard(
          key: ValueKey(bones[i].id),
          bone: bones[i],
          isSelected: bones[i].isSelected,
          onTap: () => _toggleBoneSelection(bones[i].id),
          onLongPress: () => _showBoneActionSheet(bones[i]),
        ),
      ),
    );
  }

  Widget _buildCraftButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        onPressed: _showCraftSheet,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚗️', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              AppStrings.dustCraft,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.dust,
              ),
            ),
            const SizedBox(width: 6),
            DustDisplay(dust: _gs.playerData.dust),
          ],
        ),
      ),
    );
  }

  void _showCraftSheet() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => _CraftSheet(gameService: _gs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  // Profile button
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 36,
                    onPressed: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceElevated,
                        border: Border.all(
                          color: AppColors.primary.withAlpha(120),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(40),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _gs.playerData.rankEmoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppStrings.bonesInventory,
                      style: AppTextStyles.headlineLarge,
                    ).animate().fadeIn(duration: 400.ms),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 36,
                    onPressed: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => const HowToPlayScreen(),
                      ),
                    ),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceElevated,
                        border: Border.all(
                          color: AppColors.border,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '?',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildXpSection(),
          _buildStatsRow(),
          _buildTimerSection(),
          _buildActiveEventsBanner(),
          const SizedBox(height: 4),
          _buildBoneGrid(),
          _buildCraftButton(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _CraftSheet extends StatefulWidget {
  final GameService gameService;
  const _CraftSheet({required this.gameService});

  @override
  State<_CraftSheet> createState() => _CraftSheetState();
}

class _CraftSheetState extends State<_CraftSheet> {
  BoneType _selectedType = BoneType.jaw;
  Epoch _selectedEpoch = Epoch.mesozoic;
  Rarity _selectedRarity = Rarity.common;

  int get _cost =>
      AppNumerics.dustToCraft[_selectedRarity.index2] ?? 5;
  bool get _canAfford => widget.gameService.playerData.dust >= _cost;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(AppStrings.craftBone,
                    style: AppTextStyles.headlineMedium),
                const Spacer(),
                DustDisplay(dust: widget.gameService.playerData.dust),
              ],
            ),
            const SizedBox(height: 16),
            Text('Bone Type', style: AppTextStyles.labelMedium),
            const SizedBox(height: 8),
            _buildSegment<BoneType>(
              values: BoneType.values,
              selected: _selectedType,
              label: (t) => '${t.emoji} ${t.label}',
              onChanged: (v) => setState(() => _selectedType = v),
            ),
            const SizedBox(height: 12),
            Text('Epoch', style: AppTextStyles.labelMedium),
            const SizedBox(height: 8),
            _buildSegment<Epoch>(
              values: Epoch.values,
              selected: _selectedEpoch,
              label: (e) => '${e.emoji} ${e.label}',
              onChanged: (v) => setState(() => _selectedEpoch = v),
            ),
            const SizedBox(height: 12),
            Text('Rarity', style: AppTextStyles.labelMedium),
            const SizedBox(height: 8),
            _buildSegment<Rarity>(
              values: Rarity.values,
              selected: _selectedRarity,
              label: (r) => '${r.emoji} ${r.label}',
              onChanged: (v) => setState(() => _selectedRarity = v),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(14),
                onPressed: _canAfford
                    ? () {
                        final ok = widget.gameService.craftBone(
                          _selectedType,
                          _selectedEpoch,
                          _selectedRarity,
                        );
                        if (ok) Navigator.pop(context);
                      }
                    : null,
                child: Text(
                  _canAfford
                      ? '${AppStrings.dustCraft} (${_cost}✨)'
                      : AppStrings.notEnoughDust,
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment<T>({
    required List<T> values,
    required T selected,
    required String Function(T) label,
    required ValueChanged<T> onChanged,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: values.map((v) {
          final isSelected = v == selected;
          return GestureDetector(
            onTap: () => onChanged(v),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceElevated,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGlow
                      : AppColors.border,
                ),
              ),
              child: Text(
                label(v),
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
