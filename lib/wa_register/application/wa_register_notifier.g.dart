// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wa_register_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waRegisterRepositoryHash() =>
    r'c888cbd3821004fc9d55fcfefa64a98606bb9999';

/// See also [waRegisterRepository].
@ProviderFor(waRegisterRepository)
final waRegisterRepositoryProvider = Provider<WaRegisterRepository>.internal(
  waRegisterRepository,
  name: r'waRegisterRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$waRegisterRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WaRegisterRepositoryRef = ProviderRef<WaRegisterRepository>;
String _$waRegisterNotifierHash() =>
    r'98513db8d198e621fe31892118b68ad9b2363d21';

/// See also [WaRegisterNotifier].
@ProviderFor(WaRegisterNotifier)
final waRegisterNotifierProvider =
    AutoDisposeAsyncNotifierProvider<WaRegisterNotifier, WaRegister>.internal(
  WaRegisterNotifier.new,
  name: r'waRegisterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$waRegisterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WaRegisterNotifier = AutoDisposeAsyncNotifier<WaRegister>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member