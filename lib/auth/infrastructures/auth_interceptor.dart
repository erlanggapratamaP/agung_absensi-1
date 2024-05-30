import 'package:dio/dio.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/constants.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref);

  final Ref _ref;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);

    final items = response.data?[0];

    if (items != null) {
      _ref.read(absenOfflineModeProvider.notifier).state = false;
    }

    // final message = items['error'] as String?;
    final errorNum = items['errornum'] as int?;

    if (errorNum == Constants.passWrongCode ||
        errorNum == Constants.passExpCode) {
      await _ref.read(userNotifierProvider.notifier).logout();
    }
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    super.onError(e, handler);

    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      _ref.read(absenOfflineModeProvider.notifier).state = true;
    }
  }
}
