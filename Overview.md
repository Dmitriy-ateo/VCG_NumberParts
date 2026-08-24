# 📐 NumberParts — Math Games for Elementary School (Grades 1–2)

## 1. Project Overview & Vision

**NumberParts** is a collection of educational math mini-games designed specifically for 1st and 2nd grade pupils (ages 6–8). The app makes early mathematics intuitive, tangible, and fun through tactile visual representations and game mechanics inspired by classic puzzle games (e.g., Mahjong Solitaire / Card Piles).

The application is structured as a **modular platform** capable of hosting multiple math mini-games, starting with its flagship game: **"Number Bonds" (Состав числа)**.

---

## 2. Core Game: "Number Bonds" (Wooden Card Pile)

### 🎯 Educational Goal
Mastering **number composition** (e.g., understanding that $7 = 3 + 4 = 2 + 5 = 1 + 6$) is foundational for mental arithmetic, addition, and subtraction fluency.

### 🎮 Gameplay Mechanics
1. **Target Number**: Each level specifies a target sum (e.g., `Target: 10`, `Target: 7`).
2. **Layered Card Pile**: A board of wooden cards arranged in overlapping 2.5D layers (pyramids, cascades, or free piles).
3. **Card States**:
   - **Active (Free)**: Cards that have no other cards resting on top of them. They are fully illuminated, interactive, and face-up.
   - **Blocked (Locked)**: Cards partially or fully covered by cards in higher layers. They appear slightly dimmed with a subtle shadow overlay and cannot be tapped until uncovered.
   - **Selected**: A tapped active card lifts up with a warm glow.
4. **Matching & Clearing**:
   - The player selects two free cards whose sum equals the level's **Target Number** (e.g., in a Level 10 game, selecting `3` and `7`).
   - On a valid match: the pair sparkles, produces a warm wooden clack sound, and animates off the board.
   - Any cards previously blocked beneath them become active with a subtle bounce animation.
   - On an invalid match: both cards shake gently with a friendly soft sound, deselect, and 1 life (heart) is lost.
5. **Lives System (3 Mistakes Allowed)**:
   - The player starts each level with **3 lives** (displayed as wooden/pastel hearts at the top bar).
   - Each incorrect pair selection consumes 1 life with an animated cracking/fading heart effect.
   - If all 3 lives are lost (3 mistakes), a friendly "Try Again" overlay appears and the level restarts.
6. **Level Completion**:
   - The level is won when all cards in the pile are cleared before losing all lives.
   - Star rating (1–3 stars) is awarded based on remaining lives, moves, or accuracy (e.g., 3 stars for 0 mistakes / 3 lives left).

---

## 3. Visual & Aesthetic Guidelines

### 🎨 Color Palette (Warm Pastel & Cozy Natural)
- **Backgrounds**: Warm cream (`#FDF8F0`), soft oatmeal (`#F4EFE6`), and gentle warm sand (`#EFE6D8`).
- **Cards**: Rich natural wood textures (warm birch, maple, honey pine) with soft beveled edges and soft ambient drop shadows.
- **Accents & Highlights**:
  - Warm Terracotta / Peach (`#F48C68`)
  - Soft Meadow Green / Sage (`#78B088`)
  - Warm Buttercup Yellow (`#F3CA65`)
  - Gentle Sky Blue (`#7EAED9`)
  - Muted Plum / Lilac (`#9F8EB9`)
- **Typography**: Dark warm chocolate brown (`#3E2D23`) instead of stark black for high contrast with a gentle feel.

### 🔤 Typography
- Large, rounded, highly legible numbers (e.g., *Nunito*, *Fredoka*, or *Baloo 2*).
- Clear dot patterns or dice pips optionally displayed beneath numbers on early levels for visual counting scaffolding (subitizing).

### 🪵 Card & Interactive Design
- **Tactile Physics**: Cards feel solid and wooden, with subtle parallax tilt, depth layers, and smooth spring physics.
- **Feedback**:
  - Card Tap: Smooth scale-up and warm inner glow.
  - Match: Wooden tap sound + particle burst (golden stars / soft leaves).
  - Uncovering: Cards below smoothly pop into full brightness.

---

## 4. Level Design & Progression Curve

### Difficulty Dimensions:
1. **Target Number**:
   - *Tier 1*: Sums up to 5 (e.g., 1+4, 2+3) — Introduction.
   - *Tier 2*: Sums up to 10 (most critical milestone for Grade 1).
   - *Tier 3*: Sums up to 12 & 15.
   - *Tier 4*: Sums up to 20 (Grade 2 mental math mastery).
2. **Pile Complexity & Card Count**:
   - *Beginner*: 6–10 cards, simple 2-layer flat cascades.
   - *Intermediate*: 12–18 cards, 3-layer pyramids and crosses.
   - *Advanced*: 20–30 cards, multi-tier overlapping maze layouts.
3. **Visual Aids & Hints**:
   - *Beginner mode*: Optional dot indicators on cards (e.g., 3 has 3 dots) to aid counting.
   - *Hint button*: Gently highlights a valid matching pair if the child gets stuck.
   - *Undo / Shuffle*: Kid-friendly helpers to prevent frustrating dead-ends.

---

## 5. Technical Architecture (Flutter)

```
lib/
├── app/
│   ├── app.dart                    # Main MaterialApp setup, theme, router
│   ├── theme/                      # Warm pastel palette, typography, card styles
│   └── routes.dart                 # Navigation
├── core/
│   ├── audio/                      # Sound manager (wooden clacks, ambient chime)
│   ├── storage/                    # Local progress & level stars (shared_preferences / hive)
│   └── widgets/                    # Custom wooden buttons, dialogs, progress bars
├── features/
│   ├── home/                       # Game Selection Hub / World Map
│   │   ├── presentation/
│   │   └── widgets/
│   └── number_bonds_game/          # First Game Feature
│       ├── domain/
│       │   ├── models/             # CardNode, LayerPosition, LevelConfig
│       │   └── logic/              # Overlap detection, solvable deck generator
│       ├── presentation/
│       │   ├── controllers/        # Game state (selected cards, remaining, timer, stars)
│       │   ├── widgets/            # BoardView, WoodenCardWidget, TargetDisplay
│       │   └── game_screen.dart
│       └── data/
│           └── levels_repository.dart # Predefined level layouts and generators
└── future_games/                   # Extensibility hooks for upcoming math games
```

### Key Technical Pillars
- **Multi-Language Support (i18n)**:
  - Supported Languages: **Ukrainian (Українська)**, **English**, **Slovenian (Slovenščina)**.
  - Interactive tactile language switcher accessible from the top bar on the landing page / settings.
  - Persistent language selection saved locally.
- **Guaranteed Solvability**: Deck generator algorithm generates matching pairs and places them such that a valid sequence of moves always exists.
- **2.5D Layer & Overlap Engine**: Fast bounding-box overlap calculations to determine blocked/free state dynamically as cards are removed.
- **Smooth Animations**: High-performance Flutter `ImplicitlyAnimatedWidget` / `Rive` or custom `CustomPainter` with Flutter's animation controllers.
- **Offline First**: No internet required, no ads, safe environment for young learners.

---

## 6. Future Expansion Roadmap

- 🧩 **Game 2: "Comparison Scale" (Больше / Меньше / Равно)**: Balancing scales with wooden weights and numbers.
- 🚂 **Game 3: "Number Train / Sequences" (Числовой поезд)**: Arranging numbers in ascending/descending and skip-counting patterns.
- 🎯 **Game 4: "Quick Math Archer" (Быстрый счет)**: Quick mental addition and subtraction challenges.
