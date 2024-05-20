import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructures/dio_extensions.dart';

import '../../../infrastructures/exceptions.dart';
import '../../ganti_hari_list/application/ganti_hari_list.dart';

class GantiHariApproveRemoteService {
  GantiHariApproveRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_dayoff';
  //

  Future<Unit> approveSpv({
    required int idDayOff,
    required String nama,
  }) async {
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " spv_nm = '$nama', " +
            " spv_sta = 1, " +
            " spv_tgl = getdate() " +
            " WHERE id_dayoff = $idDayOff ",
        "mode": "UPDATE"
      };

      // debugger();

      final data = _dioRequest;
      data.addAll(updateSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        return unit;
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<Unit> unapproveSpv(
      {required int idDayOff, required String nama}) async {
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " spv_nm = '$nama', " +
            " spv_sta = 0, " +
            " spv_tgl = GETDATE() " +
            " WHERE id_dayoff = $idDayOff ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        return unit;
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<Unit> approveHrd({
    required String nama,
    required String note,
    required GantiHariList itemGantiHari,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " hrd_nm = '$nama', " +
            " hrd_sta = 1, " +
            " hrd_tgl = getdate() " +
            " WHERE id_dayoff = ${itemGantiHari.idDayOff} ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        return unit;
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<Unit> unapproveHrd({
    required String nama,
    required GantiHariList itemGantiHari,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " hrd_nm = '$nama', " +
            " hrd_sta = 0, " +
            " hrd_tgl = getdate() " +
            " WHERE id_dayoff = ${itemGantiHari.idDayOff} ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        return unit;
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<Unit> batal({
    required String nama,
    required GantiHariList itemGantiHari,
  }) async {
    // 1. UPDATE SAKIT
    try {
      final Map<String, String> updateSakit = {
        "command": "UPDATE $dbName SET "
                " btl_nm = '$nama', " +
            " btl_sta = 1, " +
            " btl_tgl = getdate() " +
            " WHERE id_dayoff = ${itemGantiHari.idDayOff} ",
        "mode": "UPDATE"
      };

      final data = _dioRequest;
      data.addAll(updateSakit);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response $response');
      final items = response.data?[0];

      if (items['status'] == 'Success') {
        return unit;
      } else {
        final message = items['error'] as String?;
        final errorCode = items['errornum'] as int;

        throw RestApiExceptionWithMessage(errorCode, message);
      }
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}