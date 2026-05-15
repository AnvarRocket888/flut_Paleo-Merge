import 'bone.dart';

enum EventType { jurassicSurge, frozenFrenzy, primalPower }

class GameEvent {
  final EventType type;
  bool isActive;
  bool isCompleted;
  DateTime? activatedAt;

  GameEvent({
    required this.type,
    this.isActive = false,
    this.isCompleted = false,
    this.activatedAt,
  });

  String get id => type.name;

  EventDefinition get definition => EventDefinition.forType(type);

  bool get isExpired {
    if (!isActive || activatedAt == null) return false;
    return DateTime.now().difference(activatedAt!).inHours >= 24;
  }

  int get remainingSeconds {
    if (!isActive || activatedAt == null) return 0;
    final elapsed = DateTime.now().difference(activatedAt!).inSeconds;
    final total = 24 * 3600;
    return (total - elapsed).clamp(0, total);
  }

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'isActive': isActive,
        'isCompleted': isCompleted,
        'activatedAt': activatedAt?.toIso8601String(),
      };

  factory GameEvent.fromJson(Map<String, dynamic> json) => GameEvent(
        type: EventType.values[json['type'] as int],
        isActive: json['isActive'] as bool? ?? false,
        isCompleted: json['isCompleted'] as bool? ?? false,
        activatedAt: json['activatedAt'] != null
            ? DateTime.parse(json['activatedAt'] as String)
            : null,
      );

  static List<GameEvent> defaultList() => [
        GameEvent(type: EventType.jurassicSurge),
        GameEvent(type: EventType.frozenFrenzy),
        GameEvent(type: EventType.primalPower),
      ];
}

class EventDefinition {
  final EventType type;
  final String name;
  final String description;
  final String bonusDescription;
  final String emoji;
  final Epoch relatedEpoch;
  final String triggerDescription;

  const EventDefinition({
    required this.type,
    required this.name,
    required this.description,
    required this.bonusDescription,
    required this.emoji,
    required this.relatedEpoch,
    required this.triggerDescription,
  });

  static const List<EventDefinition> all = [
    EventDefinition(
      type: EventType.jurassicSurge,
      name: 'Jurassic Surge',
      description:
          'The ancient Mesozoic forces awaken! Dinosaurian energy surges through your Chimeras.',
      bonusDescription: '2× passive coin income from all Chimeras',
      emoji: '🌿',
      relatedEpoch: Epoch.mesozoic,
      triggerDescription: 'Unlock all 5 Mesozoic Chimeras',
    ),
    EventDefinition(
      type: EventType.frozenFrenzy,
      name: 'Frozen Frenzy',
      description:
          'The glacier cracks and ancient bones rain down! The Ice Age stirs from its long slumber.',
      bonusDescription: 'Fossil bones spawn every 30 seconds',
      emoji: '❄️',
      relatedEpoch: Epoch.iceAge,
      triggerDescription: 'Unlock all 5 Ice Age Chimeras',
    ),
    EventDefinition(
      type: EventType.primalPower,
      name: 'Primal Power',
      description:
          'The first fire of the Stone Age burns bright! All knowledge flows faster in its ancient glow.',
      bonusDescription: '2× XP for all actions',
      emoji: '🔥',
      relatedEpoch: Epoch.stoneAge,
      triggerDescription: 'Unlock all 5 Stone Age Chimeras',
    ),
  ];

  static EventDefinition forType(EventType t) =>
      all.firstWhere((d) => d.type == t);
}
