# Scalable Raining Words Game: Enhancing Difficulty Parameters

## 1. Current Problem

The `raining_words_game` currently uses a simple `_speed` and `_wordList` derived from a generic `Map<String, dynamic>` within `GameLevelConfig.parameters`. While functional for basic levels, this approach lacks the granularity and type safety needed for defining advanced difficulty parameters. As we aim to create more diverse and challenging levels, relying solely on a generic map for configuration becomes:

*   **Error-Prone:** Easy to make typos in string keys or assign incorrect data types, leading to runtime errors.
*   **Hard to Read:** The meaning of parameters is not immediately clear without consulting documentation or the game's implementation.
*   **Not Scalable:** Adding new parameters for difficulty (e.g., spawn intervals, word length limits, max words on screen) would further bloat the generic map and make `RainingWordsGame`'s `onLoad` method complex with numerous type casts and null checks.
*   **Lacks Autocompletion:** IDEs cannot provide suggestions for available parameters.

## 2. Justification for the Proposed Solution

The proposed solution focuses on maintaining **modularity, type safety, and separation of concerns** within the game's clean architecture. Instead of modifying the generic `GameLevelConfig` to accommodate all possible parameters for all game types, we introduce a dedicated, type-safe parameter class specifically for the `raining_words_game`.

**Why this approach?**

*   **Type Safety:** By defining a dedicated `RainingWordsGameParameters` class, we leverage Dart's type system. This means compile-time checks for parameter names and types, significantly reducing runtime errors.
*   **Readability and Maintainability:** Parameters are clearly defined with their types and default values, making the code easier to understand and maintain.
*   **Modularity:** The `RainingWordsGameParameters` class is encapsulated within the `raining_words_game` feature's domain layer. This ensures that the `raining_words_game` feature is self-contained and doesn't impose its specific parameter needs on other game types or the core `GameLevelConfig`.
*   **Scalability:** `GameLevelConfig` remains lean and generic, serving as a bridge to the specific game's parameters. New parameters for `raining_words_game` can be added to `RainingWordsGameParameters` without affecting `GameLevelConfig` or other game implementations.
*   **Autocompletion:** IDEs will provide autocompletion for the fields within `RainingWordsGameParameters`, improving developer experience.

## 3. Detailed Plan for Improvement

The plan involves three main phases: enhancing `GameLevelConfig`, adapting `RainingWordsGame` to use the new parameters, and updating `LevelManager` to reflect these changes.

---

### Phase 1: Enhance `GameLevelConfig` with a Dedicated Parameter Class

**Action 1.1: Create `RainingWordsGameParameters` Data Class**

*   **File:** `lib/features/raining_words_game/domain/entities/raining_words_game_parameters.dart`
*   **Purpose:** To encapsulate all configurable parameters specific to the `RainingWordsGame`, providing type safety and clear definitions.
*   **Content:**
    ```dart
    import 'package:equatable/equatable.dart';

    class RainingWordsGameParameters extends Equatable {
      final List<String> wordList;
      final double baseSpeed;
      final double minSpeedMultiplier;
      final double maxSpeedMultiplier;
      final Duration spawnInterval;
      final int maxWordsOnScreen;
      final int wordLengthMin;
      final int wordLengthMax;

      const RainingWordsGameParameters({
        required this.wordList,
        this.baseSpeed = 100.0, // Default base speed
        this.minSpeedMultiplier = 0.5, // Default min speed multiplier
        this.maxSpeedMultiplier = 1.5, // Default max speed multiplier
        this.spawnInterval = const Duration(seconds: 2), // Default spawn interval
        this.maxWordsOnScreen = 5, // Default max words on screen
        this.wordLengthMin = 1, // Default min word length
        this.wordLengthMax = 100, // Default max word length (effectively no max)
      });

      @override
      List<Object?> get props => [
            wordList,
            baseSpeed,
            minSpeedMultiplier,
            maxSpeedMultiplier,
            spawnInterval,
            maxWordsOnScreen,
            wordLengthMin,
            wordLengthMax,
          ];
    }
    ```

**Action 1.2: Update `GameLevelConfig` to Include `RainingWordsGameParameters`**

*   **File:** `lib/core/games/domain/entities/game_level_config.dart`
*   **Purpose:** Allow `GameLevelConfig` to directly hold an instance of `RainingWordsGameParameters` when the `gameType` is `rainingWordsGame`.
*   **Modification:**
    *   Add an import for `package:flame_based_games/features/raining_words_game/domain/entities/raining_words_game_parameters.dart`.
    *   Add an optional field: `final RainingWordsGameParameters? rainingWordsGameParameters;`
    *   Update the `GameLevelConfig` constructor to accept and initialize this new field.
    *   Modify the `copyWith` method (if it exists) to include this new field.

---

### Phase 2: Adapt `RainingWordsGame` to Utilize New Parameters

**Action 2.1: Modify `RainingWordsGame` to Consume `RainingWordsGameParameters`**

*   **File:** `lib/features/raining_words_game/flame/raining_words_game.dart`
*   **Purpose:** Replace the direct use of `levelConfig.parameters` with the type-safe `_gameParameters` object and implement dynamic spawning.
*   **Modifications:**
    *   **Remove:** Existing `_wordList` and `_speed` member variables.
    *   **Add:** `late RainingWordsGameParameters _gameParameters;`
    *   **`onLoad()` Method:**
        *   Initialize `_gameParameters` from `levelConfig.rainingWordsGameParameters`. If `levelConfig.rainingWordsGameParameters` is `null`, use a default `RainingWordsGameParameters` instance (e.g., `const RainingWordsGameParameters(wordList: ['default'])`).
        *   Initialize a `TimerComponent` for managing word spawning based on `_gameParameters.spawnInterval`.
        *   Remove the current `_addWordsToGame()` call that adds all words at once.
    *   **`_addWordsToGame()` Method (Refactor/Rename to `_spawnWord()`):**
        *   This method will now be responsible for spawning a *single* word.
        *   It should check `children.whereType<WordComponent>().length < _gameParameters.maxWordsOnScreen` before spawning a new word.
        *   The `randomSpeed` calculation should use `_gameParameters.baseSpeed`, `_gameParameters.minSpeedMultiplier`, and `_gameParameters.maxSpeedMultiplier`.
        *   The `wordList` for spawning should come from `_gameParameters.wordList`.
    *   **`update()` Method:**
        *   Ensure word movement uses the `speed` property of each `WordComponent`.
        *   When a word goes off-screen, instead of immediately repositioning it, it should be removed, and the spawning mechanism should decide when to add a new one.
    *   **`_onWordTapped()` Method:**
        *   No significant changes here, but ensure it correctly interacts with the updated word spawning/removal logic.

---

### Phase 3: Update `LevelManager`

**Action 3.1: Update `rainingWordsGame` Level Entry**

*   **File:** `lib/core/games/data/repositories/level_manager.dart`
*   **Purpose:** Configure the existing "Raining Words" level using the new `RainingWordsGameParameters` class.
*   **Modification:**
    *   Remove the `parameters` map for the `rainingWordsGame` entry.
    *   Add `rainingWordsGameParameters: const RainingWordsGameParameters(...)` and populate it with the desired `wordList`, `baseSpeed`, `spawnInterval`, etc.

---

This comprehensive plan will establish a robust and type-safe foundation for defining and managing advanced difficulty parameters for the `raining_words_game`, significantly improving its scalability and maintainability for future level development.
