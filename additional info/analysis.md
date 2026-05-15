# App Concept Analysis — Paleo Merge

## Summary

**Paleo Merge** is an offline idle/collection game set in a prehistoric world. The core loop revolves around:

1. **Collecting fossil bones** — automatically spawned every 60 seconds (jaw, vertebra, rib, claw), each with a geological epoch (Mesozoic, Ice Age, Stone Age) and rarity tier (Common → Legendary).
2. **Merging bones** — placing 3 bones of the same epoch into an alchemical forge to create a **Chimera** — a fantastical creature that joins the player's collection.
3. **Passive income** — each unlocked Chimera generates coins per minute automatically.
4. **Disassembling & crafting** — unwanted bones can be broken down into Dust; Dust can be spent to craft any specific bone, allowing targeted completion of merge combos.
5. **Special events** — triggered when the player collects all Chimeras of a given epoch, granting timed bonuses (e.g. doubled rewards for 24 hours).

**Central theme:** Prehistoric alchemy — ancient paleontology meets mystical creature fusion. The aesthetic is dark, cosmic, and arcane, with glowing fossils, swirling particle effects, and rune-like UI elements.

---

## Proposed Screens

### 1. Splash / Welcome Screen (`splash_screen.dart`)
- Shown every time the app launches.
- Displays the Paleo Merge logo, a glowing fossil icon, and a one-line tagline.
- Auto-dismisses after 5 seconds with a fade-out animation.
- Tapping anywhere triggers the same fade-out immediately.

### 2. Main Screen — Root Navigation (`main_screen.dart`)
- Hosts a custom animated bottom navigation bar.
- Five tabs: **Home**, **Merge**, **Chimeras**, **Achievements**, **Events**.
- Custom tab icons using emoji/CupertinoIcons with glow + scale animations on selection.
- Handles global overlay notifications: achievement toasts, rank-up celebration.

### 3. Home Screen (`home_screen.dart`)
- Shows the player's bone inventory as an animated grid.
- Displays coin balance, dust balance, XP bar, current rank, and streak counter.
- A countdown timer shows when the next bone will spawn.
- Tapping a bone card opens a detail sheet with options to select for merge or disassemble.
- Offline bone accumulation is calculated and shown on resume.

### 4. Merge / Alchemical Interface (`merge_screen.dart`)
- Three glowing slots in a mystical circular arrangement.
- Player drags or taps bones from inventory into slots.
- Slots validate same-epoch constraint and highlight compatible bones.
- When all 3 slots are filled, the "Forge" button activates with a pulsing animation.
- Forging plays a full-screen alchemical animation and reveals the resulting Chimera.
- Chimera name, description, rarity, and passive income are shown on the result card.

### 5. Chimeras Collection (`chimeras_screen.dart`)
- Grid of all 15 Chimera types (3 epochs × 5 rarities).
- Locked Chimeras show a glowing silhouette with "???" name.
- Unlocked Chimeras show emoji art, name, epoch badge, rarity badge, and income/min.
- Tapping an unlocked Chimera opens a detail view.
- A progress bar shows how many Chimeras have been unlocked per epoch.

### 6. Achievements Screen (`achievements_screen.dart`)
- Full-screen list of 20 achievements.
- Each achievement has an icon (emoji), name, description, XP reward, and locked/unlocked state.
- Unlocked achievements glow and show the unlock date.
- Progress achievements show a progress bar.

### 7. Trophies Screen (`trophies_screen.dart`)
- Showcase of 5 major trophies earned through milestone accomplishments.
- Large trophy card with epic visual styling, tier badge, and description.
- Locked trophies are shown as shadowed outlines.

### 8. Events Screen (`events_screen.dart`)
- Shows all 3 possible special events (one per epoch).
- Each event shows: epoch name, trigger condition, status (locked/active/completed), bonus description, and remaining time if active.
- Active events display a countdown timer and animated glow effect.

---

## Chimera Roster (15 total)

### Mesozoic Epoch 🌿
| # | Name | Rarity | Income/min |
|---|------|--------|-----------|
| 1 | Raptor Drake | Common | 2 |
| 2 | Ptero Wyrm | Uncommon | 5 |
| 3 | Trilobite Serpent | Rare | 12 |
| 4 | Ankylox | Epic | 25 |
| 5 | The Great Saurian | Legendary | 50 |

### Ice Age Epoch ❄️
| # | Name | Rarity | Income/min |
|---|------|--------|-----------|
| 6 | Mammoth Sprite | Common | 2 |
| 7 | Sabertooth Shade | Uncommon | 5 |
| 8 | Glacial Golem | Rare | 12 |
| 9 | Frost Wyvern | Epic | 25 |
| 10 | The Frozen One | Legendary | 50 |

### Stone Age Epoch 🔥
| # | Name | Rarity | Income/min |
|---|------|--------|-----------|
| 11 | Fire Gnome | Common | 2 |
| 12 | Stone Troll | Uncommon | 5 |
| 13 | Earth Warden | Rare | 12 |
| 14 | Primal Beast | Epic | 25 |
| 15 | The Ancient | Legendary | 50 |

---

## XP / Rank Progression

| Rank | XP Required | Title |
|------|-------------|-------|
| 1 | 0 | Fossil Finder |
| 2 | 100 | Bone Collector |
| 3 | 300 | Excavator |
| 4 | 600 | Paleontologist |
| 5 | 1,000 | Chimera Crafter |
| 6 | 1,500 | Ancient Scholar |
| 7 | 2,200 | Epoch Master |
| 8 | 3,000 | Fossil Legend |

---

## Achievements (20 total)

1. First Fossil — Collect your first bone
2. First Chimera — Create your first Chimera
3. Bone Hoarder — Collect 10 bones
4. Chimera Collector — Create 5 Chimeras
5. Dust to Dust — Disassemble your first bone
6. Mesozoic Master — Unlock all 5 Mesozoic Chimeras
7. Ice Age Survivor — Unlock all 5 Ice Age Chimeras
8. Stone Age Scholar — Unlock all 5 Stone Age Chimeras
9. Event Trigger — Activate your first special event
10. Legendary Find — Obtain a Legendary-rarity bone
11. Level 5 — Reach rank 5 (Chimera Crafter)
12. Streak Week — Maintain a 7-day activity streak
13. Chimera King — Unlock 15 Chimeras total
14. Epic Forger — Create an Epic-rarity Chimera
15. Legendary Forger — Create a Legendary-rarity Chimera
16. Dust Master — Accumulate 100 dust
17. Passive Tycoon — Earn 1,000 coins from passive chimera income
18. Grand Collection — Unlock all 15 Chimeras
19. Event Master — Complete all 3 special events
20. Ancient One — Reach the max rank (Fossil Legend)

---

## Special Events

| Event | Trigger | Bonus | Duration |
|-------|---------|-------|---------|
| Jurassic Surge 🌿 | All Mesozoic Chimeras unlocked | 2× passive coin income | 24 hours |
| Frozen Frenzy ❄️ | All Ice Age Chimeras unlocked | Bones spawn every 30s | 24 hours |
| Primal Power 🔥 | All Stone Age Chimeras unlocked | 2× XP for all actions | 24 hours |
