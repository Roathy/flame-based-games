# Flame Game Core Architecture Refactor Plan

## 1. Problem

The current project structure is being developed with a "feature-per-mechanic" approach. For example, a `tap_game_feature` would contain all the logic and UI for all tapping games. A separate `world_one_feature` would then need to depend on `tap_game_feature` to play a specific level.

This approach, while seemingly organized at first, leads to a tightly coupled system that is difficult to scale and maintain. As the number of game mechanics and "worlds" (level collections) grows, the dependency web becomes incredibly complex, making updates risky and code navigation confusing.

## 2. Analysis

### Current Approach (Mechanic-per-Feature)

*   **Pros:**
    *   Allows developers to focus on a single game mechanic in isolation.
    *   Keeps all code related to one mechanic (UI, logic, assets) in one place.
*   **Cons:**
    *   **High Coupling:** "World" features are directly and heavily dependent on "Mechanic" features.
    *   **Complex Dependencies:** Creates a messy dependency graph where UI-level features depend on other UI-level features.
    *   **Poor Scalability:** Adding a new level requires changing the mechanic feature. Adding a new world requires depending on multiple mechanic features. Creating a new game by mixing and matching levels is cumbersome.
    *   **Rigid:** It's hard to create variations of a level without duplicating code.

### Proposed Approach (Data-Driven Architecture)

This plan proposes a shift to a data-driven architecture, which is the industry standard for scalable, level-based games. This model separates the **data** (what defines a level) from the **code** (the game engine that runs the level).

*   **Pros:**
    *   **Decoupled:** Game engines (mechanics) are completely independent of the level data. They are generic and reusable.
    *   **Highly Scalable:** New levels and worlds can be created simply by defining new data (e.g., adding a new `GameLevelConfig` object). No new code or features are needed.
    *   **Flexible:** Easily create level variations by changing parameters in the data. Mix and match different game mechanics within a world seamlessly.
    *   **Clear Dependencies:** The dependency flow is simple and one-directional. UI -> Game Host -> Game Engine.

## 3. Plan

The goal is to establish a robust, data-driven core for all Flame-based games in the app. We will create a generic system for defining, loading, and playing game levels.

1.  **Define Core Data Structures:** Create the data models for what a "level" is (`GameLevelConfig`) and the different types of games and difficulties.
2.  **Create a Level Manager:** A central repository responsible for providing the configurations for all available levels.
3.  **Build a Generic Game Host:** A single Flutter page (`FlameGameHostPage`) capable of hosting *any* Flame game by reading its configuration.
4.  **Abstract the Game Engines:** Define a base class (`MirappFlameGame`) that all our game engines will implement.
5.  **Refactor the Existing Template:** Convert the current `TemplateGame` into the first concrete implementation of this new architecture (`TapGame`).

## 4. Steps

This will be a multi-phase process to ensure each part is built and verified correctly.

### Phase 1: Core Configuration Setup

1.  **[x] Create New Branch:** Create and switch to a new branch `feature/flame-game-core`.
2.  **[x] Define `FlameGameType` Enum:**
3.  **[x] Define `Difficulty` Enum:**
4.  **[x] Define `GameLevelConfig` Entity:**
5.  **[x] Create `LevelManager`:**
    *   Create `lib/core/games/data/repositories/level_manager.dart`.
    *   This class will hold a hardcoded list of `GameLevelConfig` objects for now. It will be responsible for fetching level data.
6.  **[x] Register `LevelManager`:**
    *   Update `lib/core/di/injection_container.dart` to register the `LevelManager` as a singleton.

### Phase 2: Abstract Flame Game and Host Page

1.  **[x] Create `MirappFlameGame` Abstract Class:**
    *   Create `lib/core/games/domain/entities/mirapp_flame_game.dart`.
    *   This will be the base class for all our Flame games.
    ```dart
    import 'package:flame/game.dart';
    import 'game_level_config.dart';

    abstract class MirappFlameGame extends FlameGame {
      final GameLevelConfig levelConfig;

      MirappFlameGame({required this.levelConfig});

      void onGameFinished(bool success);
    }
    ```
2.  **[x] Create Generic `FlameGameHostPage`:**
3.  **[x] Update Router:**
    *   Modify `lib/core/router/app_router.dart` to include a route for `FlameGameHostPage`. This route will accept the level ID as a path parameter (e.g., `/game/:levelId`).
4.  **[x] Update Home Page:**
    *   Modify `lib/features/home/presentation/pages/home_page.dart` to fetch the list of levels from the `LevelManager` and display them.
    *   When a user taps a level, it will navigate to `FlameGameHostPage` with the corresponding level ID.

### Phase 3: Refactor Existing Flame Game (`TemplateGame`)

1.  **[x] Rename and Move `TemplateGame`:**
2.  **[x] Update `TapGame`:**
3.  **[x] Implement Game Factory:**
4.  **[x] Update `LevelManager` Data:**
5.  **[x] Cleanup:**

### Phase 4: Verification

1.  **[x] Run Static Analysis:**
2.  **[x] Test End-to-End Flow:**
    *   Launch the app.
    *   Verify the home page shows the sample "Tap Game" level from the `LevelManager`.
    *   Tap the level.
    *   Verify the app navigates to the `FlameGameHostPage`.
    *   Verify the `TapGame` instance is loaded and running.
    *   Verify the back button navigates correctly back to the home page.
