// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentFlameTheme)
const currentFlameThemeProvider = CurrentFlameThemeProvider._();

final class CurrentFlameThemeProvider
    extends $NotifierProvider<CurrentFlameTheme, FlameGameTheme> {
  const CurrentFlameThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentFlameThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentFlameThemeHash();

  @$internal
  @override
  CurrentFlameTheme create() => CurrentFlameTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlameGameTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlameGameTheme>(value),
    );
  }
}

String _$currentFlameThemeHash() => r'4617721e96dd19295a781c17728d047586b2e01a';

abstract class _$CurrentFlameTheme extends $Notifier<FlameGameTheme> {
  FlameGameTheme build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FlameGameTheme, FlameGameTheme>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FlameGameTheme, FlameGameTheme>,
              FlameGameTheme,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
