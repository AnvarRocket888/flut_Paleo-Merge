import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/chimera.dart';
import '../models/bone.dart';
import '../services/game_service.dart';
import '../services/chimera_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../widgets/animated_background.dart';
import '../widgets/chimera_card.dart';

class ChimerasScreen extends StatefulWidget {
  const ChimerasScreen({super.key});

  @override
  State<ChimerasScreen> createState() => _ChimerasScreenState();
}

class _ChimerasScreenState extends State<ChimerasScreen> {
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

  void _showChimeraDetail(ChimeraDefinition def, bool isUnlocked) {
    final chimera = isUnlocked
        ? _gs.chimeras.firstWhere((c) => c.type == def.type)
        : null;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? def.rarity.color.withAlpha(40)
                      : AppColors.surfaceElevated,
                  border: Border.all(
                    color: isUnlocked
                        ? def.rarity.color.withAlpha(150)
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    isUnlocked ? def.emoji : '🔒',
                    style: const TextStyle(fontSize: 38),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isUnlocked ? def.name : '???',
                style: AppTextStyles.headlineLarge.copyWith(
                  color:
                      isUnlocked ? def.rarity.color : AppColors.textHint,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(def.epoch.emoji,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    def.epoch.label,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: def.epoch.color),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    def.rarity.emoji,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    def.rarity.label,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: def.rarity.color),
                  ),
                ],
              ),
              if (isUnlocked) ...[
                const SizedBox(height: 12),
                Text(
                  def.description,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.coinGold.withAlpha(20),
                    border: Border.all(
                        color: AppColors.coinGold.withAlpha(80)),
                  ),
                  child: Text(
                    '💰 ${def.incomePerMinute} ${AppStrings.coinsPerMin}',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.coinGold),
                  ),
                ),
                if (chimera != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Unlocked ${_formatDate(chimera.unlockedAt)}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ] else ...[
                const SizedBox(height: 12),
                Text(
                  AppStrings.mergeToUnlock,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textHint),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.close,
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  Widget _buildTotalIncomeHeader() {
    final income = ChimeraService.totalPassiveIncome(_gs.chimeras);
    final total = ChimeraDefinition.all.length;
    final unlocked = _gs.chimeras.length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceElevated,
        border: Border.all(color: AppColors.coinGold.withAlpha(80)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.passiveIncome,
                style: AppTextStyles.labelSmall,
              ),
              const SizedBox(height: 4),
              Text(
                '💰 $income ${AppStrings.coinsPerMin}',
                style: AppTextStyles.coinText.copyWith(fontSize: 18),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppStrings.collected,
                style: AppTextStyles.labelSmall,
              ),
              const SizedBox(height: 4),
              Text(
                '$unlocked / $total',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEpochProgress(Epoch epoch) {
    final epochDefs =
        ChimeraDefinition.all.where((d) => d.epoch == epoch).toList();
    final unlockedCount = ChimeraService.countForEpoch(_gs.chimeras, epoch);
    final total = epochDefs.length;
    final isComplete = ChimeraService.isEpochComplete(_gs.chimeras, epoch);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: epoch.color.withAlpha(15),
        border: Border.all(
          color: isComplete
              ? epoch.color.withAlpha(200)
              : epoch.color.withAlpha(60),
          width: isComplete ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(epoch.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            epoch.label,
            style: AppTextStyles.bodySmall.copyWith(color: epoch.color),
          ),
          const Spacer(),
          if (isComplete)
            Text('✅', style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(height: 6, color: AppColors.border),
                  FractionallySizedBox(
                    widthFactor:
                        total > 0 ? unlockedCount / total : 0,
                    child: Container(
                        height: 6, color: epoch.color),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$unlockedCount/$total',
            style:
                AppTextStyles.caption.copyWith(color: epoch.color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unlockedTypes =
        _gs.chimeras.map((c) => c.type).toSet();

    return AnimatedBackground(
      accentColor: AppColors.accentTeal,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(AppStrings.chimerasTitle,
                      style: AppTextStyles.headlineLarge)
                  .animate()
                  .fadeIn(duration: 400.ms),
            ),
          ),
          const SizedBox(height: 8),
          _buildTotalIncomeHeader(),
          for (final epoch in Epoch.values)
            _buildEpochProgress(epoch),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).size.width >= 768 ? 5 : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: ChimeraDefinition.all.length,
              itemBuilder: (_, i) {
                final def = ChimeraDefinition.all[i];
                final isUnlocked = unlockedTypes.contains(def.type);
                return ChimeraCard(
                  key: ValueKey(def.type),
                  definition: def,
                  isUnlocked: isUnlocked,
                  onTap: () => _showChimeraDetail(def, isUnlocked),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
