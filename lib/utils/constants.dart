/// Application-wide string and numeric constants for Paleo Merge.
/// Never use magic strings or numbers inline — define them here.
library;

class AppStrings {
  AppStrings._();

  // App identity
  static const String appName = 'Paleo Merge';
  static const String appTagline = 'Forge legends from ancient bones';

  // Tab labels
  static const String tabHome = 'Fossils';
  static const String tabMerge = 'Forge';
  static const String tabChimeras = 'Chimeras';
  static const String tabAchievements = 'Feats';
  static const String tabEvents = 'Events';

  // Home screen
  static const String bonesInventory = 'Bone Inventory';
  static const String nextBoneIn = 'Next bone in';
  static const String noBones = 'No bones yet — wait for the next spawn!';
  static const String disassemble = 'Disassemble';
  static const String selectForMerge = 'Select for Forge';
  static const String offlineBones = 'Fossils found while away';
  static const String dustLabel = 'Dust';
  static const String coinsLabel = 'Coins';
  static const String streakLabel = 'Streak';
  static const String days = 'days';

  // Merge screen
  static const String mergeTitle = 'Alchemical Forge';
  static const String mergeSubtitle = 'Place 3 bones of the same epoch';
  static const String mergeButton = 'FORGE CHIMERA';
  static const String mergeSlotEmpty = 'Empty Slot';
  static const String mergeHintSameEpoch = 'Bones must share an epoch';
  static const String mergeSuccess = 'Chimera Born!';
  static const String incomePerMin = '/min';
  static const String clearSlots = 'Clear Slots';
  static const String craftBone = 'Craft Bone';

  // Chimeras screen
  static const String chimerasTitle = 'Chimera Collection';
  static const String locked = '???';
  static const String unlocked = 'Unlocked';
  static const String totalIncome = 'Total Income';
  static const String perMinute = ' coins/min';

  // Achievements screen
  static const String achievementsTitle = 'Feats of Legend';
  static const String achievementXpReward = 'XP Reward';
  static const String achievementUnlocked = 'Achievement Unlocked!';

  // Trophies screen
  static const String trophiesTitle = 'Hall of Trophies';

  // Events screen
  static const String eventsTitle = 'Ancient Events';
  static const String eventActive = 'ACTIVE';
  static const String eventLocked = 'LOCKED';
  static const String eventCompleted = 'COMPLETED';
  static const String eventEndsIn = 'Ends in';
  static const String eventTrigger = 'Trigger: ';

  // Bone types
  static const String boneTypeJaw = 'Jaw';
  static const String boneTypeVertebra = 'Vertebra';
  static const String boneTypeRib = 'Rib';
  static const String boneTypeClaw = 'Claw';

  // Epochs
  static const String epochMesozoic = 'Mesozoic';
  static const String epochIceAge = 'Ice Age';
  static const String epochStoneAge = 'Stone Age';

  // Rarities
  static const String rarityCommon = 'Common';
  static const String rarityUncommon = 'Uncommon';
  static const String rarityRare = 'Rare';
  static const String rarityEpic = 'Epic';
  static const String rarityLegendary = 'Legendary';

  // XP actions
  static const String xpCollectedBone = '+5 XP — Bone collected';
  static const String xpMergedBones = '+15 XP — Bones forged';
  static const String xpRareChimera = '+25 XP — Rare Chimera!';
  static const String xpEpicChimera = '+50 XP — Epic Chimera!';
  static const String xpLegendaryChimera = '+100 XP — Legendary Chimera!';

  // Rank names
  static const List<String> rankNames = [
    'Fossil Finder',
    'Bone Collector',
    'Excavator',
    'Paleontologist',
    'Chimera Crafter',
    'Ancient Scholar',
    'Epoch Master',
    'Fossil Legend',
  ];

  // Rank emojis
  static const List<String> rankEmojis = [
    '🦴', '🦷', '⛏️', '🔬', '🐉', '📜', '🌍', '👑',
  ];

  // Misc
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String close = 'Close';
  static const String ok = 'OK';
  static const String rankUp = 'Rank Up!';
  static const String newRank = 'New Rank';
  static const String dustCraft = 'Craft from Dust';
  static const String notEnoughDust = 'Not enough dust';
  static const String boneInventoryFull = 'Inventory full (max 50 bones)';

  // Forge / merge
  static const String forgeTitle = 'Alchemical Forge';
  static const String pickBones = 'Pick bones from inventory:';
  static const String mergingText = 'Forging…';
  static const String epochMismatch = 'All 3 bones must share the same epoch';
  static const String tapToContinue = 'Tap to continue';

  // Chimeras
  static const String passiveIncome = 'Passive Income';
  static const String collected = 'Collected';
  static const String mergeToUnlock = 'Forge 3 bones of this epoch to unlock';
  static const String coinsPerMin = 'coins/min';

  // Achievements / trophies
  static const String achievements = 'Feats of Legend';
  static const String trophies = 'Hall of Trophies';

  // Events
  static const String eventsSubtitle =
      'Collect all chimeras of an epoch to trigger its event';
  static const String endsIn = 'Ends in:';
  static const String eventCompletedMessage = 'Event completed — bonuses earned!';
}

class AppNumerics {
  AppNumerics._();

  // Bone spawning
  static const int boneSpawnIntervalSeconds = 60;
  static const int boneSpawnFrenzySeconds = 30; // during Frozen Frenzy event
  static const int maxOfflineBones = 240; // 4 hours worth
  static const int maxBoneInventory = 50;

  // Dust economy
  static const Map<int, int> dustFromDisassemble = {
    0: 1,  // Common
    1: 3,  // Uncommon
    2: 5,  // Rare
    3: 10, // Epic
    4: 20, // Legendary
  };
  static const Map<int, int> dustToCraft = {
    0: 5,   // Common
    1: 15,  // Uncommon
    2: 30,  // Rare
    3: 80,  // Epic
    4: 200, // Legendary
  };

  // XP rewards
  static const int xpPerBoneCollected = 5;
  static const int xpPerMerge = 15;
  static const int xpBonusRareChimera = 25;
  static const int xpBonusEpicChimera = 50;
  static const int xpBonusLegendaryChimera = 100;

  // XP thresholds for each rank (0-indexed)
  static const List<int> rankXpThresholds = [
    0, 100, 300, 600, 1000, 1500, 2200, 3000,
  ];

  // Rarity weights (out of 100)
  static const int weightCommon = 50;
  static const int weightUncommon = 25;
  static const int weightRare = 15;
  static const int weightEpic = 8;
  static const int weightLegendary = 2;

  // Chimera passive income per minute (by rarity)
  static const Map<int, int> chimerapassiveIncome = {
    0: 2,   // Common
    1: 5,   // Uncommon
    2: 12,  // Rare
    3: 25,  // Epic
    4: 50,  // Legendary
  };

  // Event duration
  static const int eventDurationHours = 24;

  // Splash screen
  static const int splashAutoCloseSeconds = 5;
}

class AppEmojis {
  AppEmojis._();

  // Bone types
  static const String jaw = '🦷';
  static const String vertebra = '🔮';
  static const String rib = '🦴';
  static const String claw = '⚡';

  // Epochs
  static const String mesozoic = '🌿';
  static const String iceAge = '❄️';
  static const String stoneAge = '🔥';

  // Rarities
  static const String rarityCommon = '⚪';
  static const String rarityUncommon = '🟢';
  static const String rarityRare = '🔵';
  static const String rarityEpic = '🟣';
  static const String rarityLegendary = '🌟';

  // Chimera icons
  static const List<String> chimeraEmojis = [
    // Mesozoic
    '🐉', '🦅', '🐍', '🦕', '☄️',
    // Ice Age
    '🐘', '🐯', '🧊', '🌊', '⭐',
    // Stone Age
    '🔥', '⛰️', '🌍', '💥', '🌑',
  ];

  // Nav bar
  static const String navHome = '🦴';
  static const String navMerge = '⚗️';
  static const String navChimeras = '🐉';
  static const String navAchievements = '🏆';
  static const String navEvents = '⚡';

  // Misc
  static const String coin = '🪙';
  static const String dust = '✨';
  static const String streak = '🔥';
  static const String lock = '🔒';
  static const String xp = '⭐';
  static const String rankUp = '🎊';
  static const String timer = '⏱️';
}
