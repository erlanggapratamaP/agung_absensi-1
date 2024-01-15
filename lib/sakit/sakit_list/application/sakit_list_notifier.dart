import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../infrastructure/sakit_list_remote_service.dart';
import '../infrastructure/sakit_list_repository.dart';
import 'sakit_list.dart';

part 'sakit_list_notifier.g.dart';

@Riverpod(keepAlive: true)
SakitListRemoteService sakitListRemoteService(SakitListRemoteServiceRef ref) {
  return SakitListRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
SakitListRepository sakitListRepository(SakitListRepositoryRef ref) {
  return SakitListRepository(
    ref.watch(sakitListRemoteServiceProvider),
  );
}

@riverpod
class SakitListController extends _$SakitListController {
  @override
  FutureOr<List<SakitList>> build() {
    return ref.read(sakitListRepositoryProvider).getSakitList(page: 0);
  }

  Future<void> load({required int page}) async {
    state = const AsyncLoading<List<SakitList>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final res =
          await ref.read(sakitListRepositoryProvider).getSakitList(page: page);

      final List<SakitList> list = [
        ...state.requireValue.toList(),
        ...res,
      ];

      return list;
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await ref.read(sakitListRepositoryProvider).getSakitList(page: 0);
    });
  }
}