import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/bone.dart';
import '../models/chimera.dart';
import '../services/game_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../widgets/animated_background.dart';
import '../widgets/bone_card.dart';
import '../widgets/chimera_card.dart';

class MergeScreen extends StatefulWidget {
  const MergeScreen({super.key});

  @override
  State<MergeScreen> createState() => _MergeScreenState();
}

class _MergeScreenState extends State<MergeScreen>
    with TickerProviderStateMixin {
  final GameService _gs = GameService.instance;

  List<Bone> _slotBones = []; // up to 3
  bool _isMerging = false;
  Chimera? _justRevealedChimera;

  late AnimationController _forgeSpinCtrl;
  late Animation<double> _forgeSpin;
  late AnimationController _revealCtrl;
  late Animation<double> _revealScale;

  @override
  void initState() {
    super.initState();
    _gs.addListener(_onStateChanged);
    _forgeSpinCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    _forgeSpin =
        Tween<double>(begin: 0, end: 6.2832).animate(_forgeSpinCtrl);

    _revealCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _revealScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _revealCtrl, curve: Curves.elasticOut));
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _gs.removeListener(_onStateChanged);
    _forgeSpinCtrl.dispose();
    _revealCtrl.dispose();
    super.dispose();
  }

  void _toggleBoneSlot(Bone bone) {
    setState(() {
      final idx = _slotBones.indexWhere((b) => b.id == bone.id);
      if (idx >= 0) {
        _slotBones.removeAt(idx);
      } else if (_slotBones.length < 3) {
        _slotBones.add(bone);
      }
    });
  }

  bool get _canMerge => _slotBones.length == 3 && _gs.canMerge(_slotBones.map((b) => b.id).toList());

  Epoch? get _slotEpoch {
    if (_slotBones.isEmpty) return null;
    final e = _slotBones.first.epoch;
    final allSame = _slotBones.every((b) => b.epoch == e);
    return allSame ? e : null;
  }

  Future<void> _performMerge() async {
    if (!_canMerge) return;
    setState(() => _isMerging = true);
    // Spin animation
    _forgeSpinCtrl.repeat();
    await Future.delayed(const Duration(milliseconds: 2000));
    _forgeSpinCtrl.stop();

    final chimera = _gs.mergeBones(_slotBones.map((b) => b.id).toList());
    _slotBones = [];

    if (chimera != null) {
      _justRevealedChimera = chimera;
      _revealCtrl
        ..reset()
        ..forward();
    }
    setState(() => _isMerging = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      accentColor: AppColors.secondary,
      child: Stack(
        children: [
          Column(
            children: [
              // Header
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(AppStrings.forgeTitle,
                          style: AppTextStyles.headlineLarge)
                      .animate()
                      .fadeIn(duration: 400.ms),
                ),
              ),
              const SizedBox(height: 16),
              _buildSlots(),
              const SizedBox(height: 16),
              _buildForgeButton(),
              _buildSlotValidation(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(height: 1, color: AppColors.border),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  AppStrings.pickBones,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              _buildBonePickerGrid(),
              const SizedBox(height: 8),
            ],
          ),
          // Chimera reveal overlay
          if (_justRevealedChimera != null)
            _buildRevealOverlay(_justRevealedChimera!),
        ],
      ),
    );
  }

  Widget _buildSlots() {
    final epoch = _slotEpoch;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) {
        final bone = i < _slotBones.length ? _slotBones[i] : null;
        return _buildSlot(bone, i, epoch);
      }),
    );
  }

  Widget _buildSlot(Bone? bone, int index, Epoch? dominantEpoch) {
    final hasMismatch = bone != null &&
        _slotBones.length > 1 &&
        dominantEpoch == null;

    return GestureDetector(
      onTap: bone != null ? () => _toggleBoneSlot(bone) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 90,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.surfaceElevated,
          border: Border.all(
            color: hasMismatch
                ? CupertinoColors.destructiveRed.withAlpha(180)
                : bone != null
                    ? bone.epoch.color.withAlpha(180)
                    : AppColors.border,
            width: bone != null ? 2 : 1,
          ),
          boxShadow: bone != null
              ? [
                  BoxShadow(
                    color: bone.epoch.color.withAlpha(60),
                    blurRadius: 12,
                  )
                ]
              : null,
        ),
        child: bone != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(bone.type.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 4),
                  Text(bone.epoch.emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    bone.rarity.emoji,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )
            : Center(
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.border,
                    fontSize: 28,
                  ),
                ),
              ),
      ).animate(key: ValueKey(bone?.id)).fadeIn(duration: 200.ms),
    );
  }

  Widget _buildForgeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _forgeSpin,
          builder: (_, child) {
            return _isMerging
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.rotate(
                        angle: _forgeSpin.value,
                        child: const Text('⚗️',
                            style: TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppStrings.mergingText,
                        style: AppTextStyles.headlineSmall,
                      ),
                    ],
                  )
                : CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    color: _canMerge ? AppColors.secondary : AppColors.border,
                    borderRadius: BorderRadius.circular(16),
                    onPressed: _canMerge ? _performMerge : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⚗️',
                            style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Text(
                          AppStrings.mergeButton,
                          style: AppTextStyles.buttonText,
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildSlotValidation() {
    if (_slotBones.length < 2) return const SizedBox.shrink();
    final epoch = _slotEpoch;
    if (epoch != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(epoch.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              'All ${epoch.label} — Good!',
              style: AppTextStyles.bodySmall
                  .copyWith(color: epoch.color),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          AppStrings.epochMismatch,
          style: AppTextStyles.bodySmall.copyWith(
              color: CupertinoColors.destructiveRed),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _buildBonePickerGrid() {
    final bones = _gs.bones;
    if (bones.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            AppStrings.noBones,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).size.width >= 768 ? 5 : 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.78,
        ),
        itemCount: bones.length,
        itemBuilder: (_, i) => BoneCard(
          key: ValueKey(bones[i].id),
          bone: bones[i],
          isSelected: _slotBones.any((b) => b.id == bones[i].id),
          onTap: () => _toggleBoneSlot(bones[i]),
          onLongPress: null,
        ),
      ),
    );
  }

  Widget _buildRevealOverlay(Chimera chimera) {
    final def = chimera.definition;
    return GestureDetector(
      onTap: () => setState(() => _justRevealedChimera = null),
      child: Container(
        color: AppColors.background.withAlpha(230),
        child: Center(
          child: ScaleTransition(
            scale: _revealScale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('✨', style: const TextStyle(fontSize: 48))
                    .animate()
                    .fadeIn(duration: 300.ms),
                const SizedBox(height: 16),
                ChimeraCard(
                  definition: def,
                  isUnlocked: true,
                  onTap: null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${def.name} Unleashed!',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: def.rarity.color,
                    shadows: [
                      Shadow(color: def.rarity.color, blurRadius: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '+${def.incomePerMinute} ${AppStrings.coinsPerMin}',
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: AppColors.coinGold),
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.tapToContinue,
                  style: AppTextStyles.caption,
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fadeIn(duration: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
