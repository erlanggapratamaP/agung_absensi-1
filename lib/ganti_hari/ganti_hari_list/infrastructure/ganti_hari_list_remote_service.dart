import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/infrastructure/dio_extensions.dart';

import '../../../infrastructure/exceptions.dart';
import '../application/ganti_hari_list.dart';

class GantiHariListRemoteService {
  GantiHariListRemoteService(
    this._dio,
    this._dioRequest,
  );

  final Dio _dio;
  final Map<String, String> _dioRequest;

  static const String dbName = 'hr_trs_dayoff';
  //
  static const String dbMstUser = 'mst_user';
  //
  static const String dbKaryawan = 'karyawan';
  static const String dbMstDept = 'mst_dept';
  static const String dbMstJabatan = 'mst_jabatan';

  Future<List<GantiHariList>> getGantiHariList({required int page}) async {
    try {
      // debugger();
      final data = _dioRequest;

      final Map<String, String> select = {
        'command': //
            " SELECT "
                " $dbName.*, "
                " (SELECT no_telp1 FROM $dbMstUser WHERE id_user = $dbName.id_user) AS no_telp1, "
                " (SELECT no_telp2 FROM $dbMstUser WHERE id_user = $dbName.id_user) AS no_telp2, "
                " (SELECT fullname FROM $dbMstUser WHERE id_user = $dbName.id_user) AS fullname, "
                " (SELECT nama FROM $dbMstDept WHERE id_dept = (SELECT id_dept FROM $dbMstUser WHERE id_user = $dbName.id_user)) AS dept, "
                " (SELECT nama FROM mst_comp WHERE id_comp =  (SELECT id_comp FROM $dbMstUser WHERE id_user = $dbName.id_user) ) AS comp, "
                " (SELECT id_level FROM $dbMstJabatan WHERE id_jbt = (SELECT id_jbt FROM $dbMstUser WHERE id_user = $dbName.id_user )) AS level_user, "
                " (SELECT pt FROM $dbKaryawan WHERE IdKary = $dbName.IdKary) AS pt "
                " FROM "
                " $dbName "
                " WHERE "
                "     id_dayoff IS NOT NULL "
                " ORDER BY "
                "     c_date DESC "
                " OFFSET "
                "     $page * 20 ROWS FETCH FIRST 20 ROWS ONLY ",
        'mode': 'SELECT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      // log('data ${jsonEncode(data)}');
      // log('response page $page : $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        //
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            return list
                .map((e) => GantiHariList.fromJson(e as Map<String, dynamic>))
                .toList();
          } else {
            return [];
          }
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
        //
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

  Future<List<GantiHariList>> getGantiHariListLimitedAccess(
      {required int page, required String staff}) async {
    try {
      // debugger();
      final data = _dioRequest;

      final Map<String, String> select = {
        'command': //
            " SELECT "
                "          $dbName.*, "
                "          $dbMstUser.no_telp1, "
                "          $dbMstUser.no_telp2, "
                "          $dbMstUser.fullname, "
                "          $dbKaryawan.pt, "
                "          $dbMstDept.nama AS dept, "
                "          (SELECT nama FROM mst_comp WHERE id_comp = (SELECT id_comp FROM $dbMstUser WHERE id_user = $dbName.id_user)) AS comp "
                "      FROM "
                "          $dbName "
                "      JOIN "
                "           $dbMstUser ON $dbName.id_user = $dbMstUser.id_user "
                "      JOIN "
                "          $dbKaryawan ON $dbName.IdKary = $dbKaryawan.IdKary "
                "      JOIN "
                "          $dbMstDept ON $dbMstUser.id_dept = $dbMstDept.id_dept "
                "      WHERE "
                "          $dbName.id_user IN ($staff) "
                "          AND $dbName.id_dayoff IS NOT NULL "
                "      ORDER BY "
                "          $dbName.c_date DESC "
                "      OFFSET "
                "          $page * 20 ROWS FETCH FIRST 20 ROWS ONLY ",
        'mode': 'SELECT'
      };

      data.addAll(select);

      final response = await _dio.post('',
          data: jsonEncode(data), options: Options(contentType: 'text/plain'));

      log('data ${jsonEncode(data)}');
      log('response page $page : $response');

      final items = response.data?[0];

      if (items['status'] == 'Success') {
        //
        final listExist = items['items'] != null && items['items'] is List;

        if (listExist) {
          final list = items['items'] as List;

          if (list.isNotEmpty) {
            return list
                .map((e) => GantiHariList.fromJson(e as Map<String, dynamic>))
                .toList();
          } else {
            return [];
          }
        } else {
          final message = items['error'] as String?;
          final errorCode = items['errornum'] as int;

          throw RestApiExceptionWithMessage(errorCode, message);
        }
        //
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