// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gold_price_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goldPriceRepositoryHash() =>
    r'd91ac80870b02b049c312eaf1bf979970e269806';

/// See also [goldPriceRepository].
@ProviderFor(goldPriceRepository)
final goldPriceRepositoryProvider =
    AutoDisposeProvider<GoldPriceRepository>.internal(
      goldPriceRepository,
      name: r'goldPriceRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$goldPriceRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoldPriceRepositoryRef = AutoDisposeProviderRef<GoldPriceRepository>;
String _$goldPriceHistoryHash() => r'9ad62e09de433180dfd06f05643912eb94e85275';

/// See also [goldPriceHistory].
@ProviderFor(goldPriceHistory)
final goldPriceHistoryProvider =
    AutoDisposeFutureProvider<List<GoldPriceSnapshot>>.internal(
      goldPriceHistory,
      name: r'goldPriceHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$goldPriceHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoldPriceHistoryRef =
    AutoDisposeFutureProviderRef<List<GoldPriceSnapshot>>;
String _$goldPricesHash() => r'f884b1ea9513d4a3dcc1c0b3fbf6f450fe0eb23f';

/// See also [GoldPrices].
@ProviderFor(GoldPrices)
final goldPricesProvider =
    AutoDisposeAsyncNotifierProvider<GoldPrices, GoldPriceSnapshot>.internal(
      GoldPrices.new,
      name: r'goldPricesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$goldPricesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GoldPrices = AutoDisposeAsyncNotifier<GoldPriceSnapshot>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
