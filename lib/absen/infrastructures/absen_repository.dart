import 'package:dartz/dartz.dart';

import '../../domain/absen_failure.dart';
import '../../domain/riwayat_absen_failure.dart';
import '../../infrastructures/exceptions.dart';
import '../../riwayat_absen/application/riwayat_absen_model.dart';

import '../../utils/enums.dart';
import '../application/absen_state.dart';
import 'absen_remote_service.dart';

class AbsenRepository {
  AbsenRepository(
    this._remoteService,
  );

  final AbsenRemoteService _remoteService;

  Future<Either<AbsenFailure, Unit>> absen({
    required String imei,
    required DateTime date,
    required String idGeof,
    required String lokasi,
    required DateTime dbDate,
    required String latitude,
    required String longitude,
    required JenisAbsen inOrOut,
  }) async {
    try {
      await _remoteService.absen(
        imei: imei,
        date: date,
        idGeof: idGeof,
        dbDate: dbDate,
        lokasi: lokasi,
        inOrOut: inOrOut,
        latitude: latitude,
        longitude: longitude,
      );

      return right(unit);
    } on NoConnectionException {
      return left(AbsenFailure.noConnection());
    } on RestApiException catch (error) {
      return left(AbsenFailure.server(error.errorCode));
    } on RestApiExceptionWithMessage catch (error) {
      return left(AbsenFailure.server(error.errorCode, error.message));
    }
  }

  Future<AbsenState> getAbsen({required DateTime date}) async {
    try {
      return await _remoteService.getAbsen(date: date);
    } on NoConnectionException {
      return AbsenState.failure(message: 'no connection');
    } on RestApiExceptionWithMessage catch (e) {
      return AbsenState.failure(errorCode: e.errorCode, message: e.message);
    } on RestApiException catch (e) {
      return AbsenState.failure(
          errorCode: e.errorCode, message: 'RestApiException getAbsen');
    }
  }

  Future<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>> getRiwayatAbsen({
    required String? dateFirst,
    required String? dateSecond,
  }) async {
    try {
      return right(await _remoteService.getRiwayatAbsen(
        dateFirst: dateFirst,
        dateSecond: dateSecond,
      ));
    } on NoConnectionException {
      return left(RiwayatAbsenFailure.noConnection());
    } on FormatException catch (e) {
      return left(RiwayatAbsenFailure.wrongFormat(e.message));
    } on RestApiException catch (e) {
      return left(RiwayatAbsenFailure.server(e.errorCode));
    } on RestApiExceptionWithMessage catch (e) {
      return left(RiwayatAbsenFailure.server(e.errorCode, e.message));
    }
  }
}
