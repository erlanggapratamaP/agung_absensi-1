import '../application/izin_list.dart';
import '../application/jenis_izin.dart';
import 'izin_list_remote_service.dart';

class IzinListRepository {
  IzinListRepository(this._remoteService);

  final IzinListRemoteService _remoteService;

  Future<List<IzinList>> getIzinList({required int page}) {
    return _remoteService.getIzinList(page: page);
  }

  Future<List<IzinList>> getIzinListLimitedAccess(
      {required int page, required int idUserHead}) {
    return _remoteService.getIzinListLimitedAccess(
        page: page, idUserHead: idUserHead);
  }

  Future<List<JenisIzin>> getJenisIzin() {
    return _remoteService.getJenisIzin();
  }
}
