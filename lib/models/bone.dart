import 'dart:math';

enum BoneType { jaw, vertebra, rib, claw }

enum Epoch { mesozoic, iceAge, stoneAge }

enum Rarity { common, uncommon, rare, epic, legendary }

class Bone {
  final String id;
  final BoneType type;
  final Epoch epoch;
  final Rarity rarity;
  final DateTime collectedAt;
  bool isSelected;

  Bone({
    required this.id,
    required this.type,
    required this.epoch,
    required this.rarity,
    required this.collectedAt,
    this.isSelected = false,
  });

  factory Bone.random({DateTime? at}) {
    final rng = Random();
    final epoch = Epoch.values[rng.nextInt(Epoch.values.length)];
    final type = BoneType.values[rng.nextInt(BoneType.values.length)];
    final rarity = _randomRarity(rng);
    return Bone(
      id: _generateId(),
      type: type,
      epoch: epoch,
      rarity: rarity,
      collectedAt: at ?? DateTime.now(),
    );
  }

  static Rarity _randomRarity(Random rng) {
    final roll = rng.nextInt(100);
    if (roll < 50) return Rarity.common;
    if (roll < 75) return Rarity.uncommon;
    if (roll < 90) return Rarity.rare;
    if (roll < 98) return Rarity.epic;
    return Rarity.legendary;
  }

  static String _generateId() {
    final rng = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${rng.nextInt(99999)}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'epoch': epoch.index,
        'rarity': rarity.index,
        'collectedAt': collectedAt.toIso8601String(),
        'isSelected': isSelected,
      };

  factory Bone.fromJson(Map<String, dynamic> json) => Bone(
        id: json['id'] as String,
        type: BoneType.values[json['type'] as int],
        epoch: Epoch.values[json['epoch'] as int],
        rarity: Rarity.values[json['rarity'] as int],
        collectedAt: DateTime.parse(json['collectedAt'] as String),
        isSelected: json['isSelected'] as bool? ?? false,
      );

  Bone copyWith({bool? isSelected}) => Bone(
        id: id,
        type: type,
        epoch: epoch,
        rarity: rarity,
        collectedAt: collectedAt,
        isSelected: isSelected ?? this.isSelected,
      );

  @override
  bool operator ==(Object other) => other is Bone && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
