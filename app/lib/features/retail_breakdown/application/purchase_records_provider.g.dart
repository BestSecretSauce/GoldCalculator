// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_records_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$purchaseRecordStoreHash() =>
    r'74536c17e10acf74b334636861d4de2d41ab34fd';

/// See also [purchaseRecordStore].
@ProviderFor(purchaseRecordStore)
final purchaseRecordStoreProvider =
    AutoDisposeProvider<PurchaseRecordStore>.internal(
      purchaseRecordStore,
      name: r'purchaseRecordStoreProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$purchaseRecordStoreHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PurchaseRecordStoreRef = AutoDisposeProviderRef<PurchaseRecordStore>;
String _$purchaseRecordsHash() => r'31c3718589d6fd38d5abf67ba6ae3ee7666da5d5';

/// See also [PurchaseRecords].
@ProviderFor(PurchaseRecords)
final purchaseRecordsProvider =
    AutoDisposeAsyncNotifierProvider<
      PurchaseRecords,
      List<PurchaseRecord>
    >.internal(
      PurchaseRecords.new,
      name: r'purchaseRecordsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$purchaseRecordsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PurchaseRecords = AutoDisposeAsyncNotifier<List<PurchaseRecord>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
