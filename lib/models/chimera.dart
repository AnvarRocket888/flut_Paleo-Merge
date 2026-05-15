import 'bone.dart';

enum ChimeraType {
  // Mesozoic (0–4)
  raptorDrake,
  pteroWyrm,
  trilobiteSerpent,
  ankylox,
  greatSaurian,
  // Ice Age (5–9)
  mammothSprite,
  sabertooth,
  glacialGolem,
  frostWyvern,
  frozenOne,
  // Stone Age (10–14)
  fireGnome,
  stoneTroll,
  earthWarden,
  primalBeast,
  theAncient,
}

class ChimeraDefinition {
  final ChimeraType type;
  final String name;
  final String description;
  final Epoch epoch;
  final Rarity rarity;
  final int incomePerMinute;
  final String emoji;

  const ChimeraDefinition({
    required this.type,
    required this.name,
    required this.description,
    required this.epoch,
    required this.rarity,
    required this.incomePerMinute,
    required this.emoji,
  });

  static const List<ChimeraDefinition> all = [
    // ── Mesozoic ──────────────────────────────────────────────────────────
    ChimeraDefinition(
      type: ChimeraType.raptorDrake,
      name: 'Raptor Drake',
      description:
          'A swift feathered predator with draconic wings. It prowls the edge of the primordial forest.',
      epoch: Epoch.mesozoic,
      rarity: Rarity.common,
      incomePerMinute: 2,
      emoji: '🐉',
    ),
    ChimeraDefinition(
      type: ChimeraType.pteroWyrm,
      name: 'Ptero Wyrm',
      description:
          'Part pterodactyl, part serpent — this sky leviathan soars above ancient canopies.',
      epoch: Epoch.mesozoic,
      rarity: Rarity.uncommon,
      incomePerMinute: 5,
      emoji: '🦅',
    ),
    ChimeraDefinition(
      type: ChimeraType.trilobiteSerpent,
      name: 'Trilobite Serpent',
      description:
          'An armoured ocean behemoth that slithered from the primordial seas with segmented plate scales.',
      epoch: Epoch.mesozoic,
      rarity: Rarity.rare,
      incomePerMinute: 12,
      emoji: '🐍',
    ),
    ChimeraDefinition(
      type: ChimeraType.ankylox,
      name: 'Ankylox',
      description:
          'A fusion of Ankylosaurus and a living boulder. Its tail can shatter mountains.',
      epoch: Epoch.mesozoic,
      rarity: Rarity.epic,
      incomePerMinute: 25,
      emoji: '🦕',
    ),
    ChimeraDefinition(
      type: ChimeraType.greatSaurian,
      name: 'The Great Saurian',
      description:
          'A legendary titan that walked the Earth before the age of men. Its roar reshapes continents.',
      epoch: Epoch.mesozoic,
      rarity: Rarity.legendary,
      incomePerMinute: 50,
      emoji: '☄️',
    ),

    // ── Ice Age ───────────────────────────────────────────────────────────
    ChimeraDefinition(
      type: ChimeraType.mammothSprite,
      name: 'Mammoth Sprite',
      description:
          'A playful tiny mammoth made of swirling ice crystals and ancient memories.',
      epoch: Epoch.iceAge,
      rarity: Rarity.common,
      incomePerMinute: 2,
      emoji: '🐘',
    ),
    ChimeraDefinition(
      type: ChimeraType.sabertooth,
      name: 'Sabertooth Shade',
      description:
          'A translucent phantom cat whose crystal fangs can cut through frozen time.',
      epoch: Epoch.iceAge,
      rarity: Rarity.uncommon,
      incomePerMinute: 5,
      emoji: '🐯',
    ),
    ChimeraDefinition(
      type: ChimeraType.glacialGolem,
      name: 'Glacial Golem',
      description:
          'A colossus formed from a thousand years of packed glacier, animated by the chill of eternity.',
      epoch: Epoch.iceAge,
      rarity: Rarity.rare,
      incomePerMinute: 12,
      emoji: '🧊',
    ),
    ChimeraDefinition(
      type: ChimeraType.frostWyvern,
      name: 'Frost Wyvern',
      description:
          'A majestic frost drake that guards the eternal ice. Its breath freezes entire rivers.',
      epoch: Epoch.iceAge,
      rarity: Rarity.epic,
      incomePerMinute: 25,
      emoji: '🌊',
    ),
    ChimeraDefinition(
      type: ChimeraType.frozenOne,
      name: 'The Frozen One',
      description:
          'A mythic entity sealed inside the world\'s oldest glacier. It predates all known life.',
      epoch: Epoch.iceAge,
      rarity: Rarity.legendary,
      incomePerMinute: 50,
      emoji: '⭐',
    ),

    // ── Stone Age ─────────────────────────────────────────────────────────
    ChimeraDefinition(
      type: ChimeraType.fireGnome,
      name: 'Fire Gnome',
      description:
          'A mischievous imp born from the first lightning strike, dancing in embers.',
      epoch: Epoch.stoneAge,
      rarity: Rarity.common,
      incomePerMinute: 2,
      emoji: '🔥',
    ),
    ChimeraDefinition(
      type: ChimeraType.stoneTroll,
      name: 'Stone Troll',
      description:
          'A massive troll carved by ancient rivers, skin harder than obsidian.',
      epoch: Epoch.stoneAge,
      rarity: Rarity.uncommon,
      incomePerMinute: 5,
      emoji: '⛰️',
    ),
    ChimeraDefinition(
      type: ChimeraType.earthWarden,
      name: 'Earth Warden',
      description:
          'The guardian spirit of the primordial earth, weaving roots and stone into living armor.',
      epoch: Epoch.stoneAge,
      rarity: Rarity.rare,
      incomePerMinute: 12,
      emoji: '🌍',
    ),
    ChimeraDefinition(
      type: ChimeraType.primalBeast,
      name: 'Primal Beast',
      description:
          'An unstoppable force of nature, combining every predatory instinct of the Stone Age.',
      epoch: Epoch.stoneAge,
      rarity: Rarity.epic,
      incomePerMinute: 25,
      emoji: '💥',
    ),
    ChimeraDefinition(
      type: ChimeraType.theAncient,
      name: 'The Ancient',
      description:
          'It was here before the first stone was shaped. It will remain after the last star fades.',
      epoch: Epoch.stoneAge,
      rarity: Rarity.legendary,
      incomePerMinute: 50,
      emoji: '🌑',
    ),
  ];

  static ChimeraDefinition forType(ChimeraType t) =>
      all.firstWhere((d) => d.type == t);
}

class Chimera {
  final String id;
  final ChimeraType type;
  final DateTime unlockedAt;

  Chimera({
    required this.id,
    required this.type,
    required this.unlockedAt,
  });

  ChimeraDefinition get definition => ChimeraDefinition.forType(type);
  String get name => definition.name;
  Epoch get epoch => definition.epoch;
  Rarity get rarity => definition.rarity;
  int get incomePerMinute => definition.incomePerMinute;
  String get emoji => definition.emoji;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'unlockedAt': unlockedAt.toIso8601String(),
      };

  factory Chimera.fromJson(Map<String, dynamic> json) => Chimera(
        id: json['id'] as String,
        type: ChimeraType.values[json['type'] as int],
        unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      );
}
