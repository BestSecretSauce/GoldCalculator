// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workmanship_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workmanshipHistoryStoreHash() =>
    r'1632195a071703abd0b95af70f979b635d3232ae';

/// See also [workmanshipHistoryStore].
@ProviderFor(workmanshipHistoryStore)
final workmanshipHistoryStoreProvider =
    AutoDisposeProvider<WorkmanshipHistoryStore>.internal(
      workmanshipHistoryStore,
      name: r'workmanshipHistoryStoreProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workmanshipHistoryStoreHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkmanshipHistoryStoreRef =
    AutoDisposeProviderRef<WorkmanshipHistoryStore>;
String _$workmanshipHistoryHash() =>
    r'd1449331ef8fac559c540d0b3f8ff2a40852a3a3';

/// See also [WorkmanshipHistory].
@ProviderFor(WorkmanshipHistory)
final workmanshipHistoryProvider =
    AutoDisposeAsyncNotifierProvider<WorkmanshipHistory, List<double>>.internal(
      WorkmanshipHistory.new,
      name: r'workmanshipHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workmanshipHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WorkmanshipHistory = AutoDisposeAsyncNotifier<List<double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
