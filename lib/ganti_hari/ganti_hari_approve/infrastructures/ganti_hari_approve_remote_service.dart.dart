import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/constants.dart';
import '../../../infrastructures/exceptions.dart';

class GantiHariApproveRemoteService {
  GantiHariApproveRemoteService(
    this._dio,
  );

  final Dio _dio;

  Future<Unit> approve({
    required int idDayOff,
    required String username,
    required String pass,
    required String jenisApp,
    required String note,
    String? server = Constants.isDev ? 'testing' : 'live',
  }) async {
    try {
      final response = await _dio.post(
        '/service_dayoff.asmx/approveDayoff',
        options: Options(contentType: 'text/plain', headers: {
          'id_dayoff': idDayOff,
          'username': username,
          'pass': pass,
          'server': server,
          'jenis_app': jenisApp,
          'note': note,
        }),
      );

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<Unit> batal({
    required int idDayOff,
    required String username,
    required String pass,
  }) async {
    try {
      final response = await _dio.post(
        '/service_dayoff.asmx/batalDayoff',
        options: Options(contentType: 'text/plain', headers: {
          'id_dayoff': idDayOff,
          'username': username,
          'pass': pass,
        }),
      );

      final items = response.data;

      if (items['status_code'] == 200) {
        return unit;
      } else {
        final message = items['message'] as String?;
        final errorCode = items['status_code'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioException catch (e) {
      if ((e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout)) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
