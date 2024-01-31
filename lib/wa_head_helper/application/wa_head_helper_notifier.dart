import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';

import '../infrastructure/wa_head_helper_remote_service.dart';
import '../infrastructure/wa_head_helper_repository.dart';
import 'wa_head.dart';

part 'wa_head_helper_notifier.g.dart';

@Riverpod(keepAlive: true)
WaHeadHelperRemoteService waHeadHelperRemoteService(
    WaHeadHelperRemoteServiceRef ref) {
  return WaHeadHelperRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
WaHeadHelperRepository waHeadHelperRepository(WaHeadHelperRepositoryRef ref) {
  return WaHeadHelperRepository(
    ref.watch(waHeadHelperRemoteServiceProvider),
  );
}

@riverpod
class WaHeadHelperNotifier extends _$WaHeadHelperNotifier {
  @override
  FutureOr<List<WaHead>> build() {
    return [];
  }

  Future<void> sendWa({
    required int idUser,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return ref.read(waHeadHelperRepositoryProvider).getWaHead(idUser: idUser);
    });
  }
}