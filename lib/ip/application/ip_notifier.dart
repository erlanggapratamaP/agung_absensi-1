import 'package:dio/dio.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/configuration.dart';

part 'ip_notifier.g.dart';

const bool isTesting = true;

const ip = 'http://agunglogisticsapp.co.id:1225/service_mobile.asmx/Perintah';
const ipHosting = 'http://202.157.184.229:1001/service_mobile.asmx/Perintah';

// API Mobile Cutmutiah:
// http://agunglogisticsapp.co.id:1225/service_mobile.asmx/Perintah
// http://180.250.79.122:1225/service_mobile.asmx/Perintah
// const domainCut =
//     'http://agunglogisticsapp.co.id:1225/service_mobile.asmx/Perintah';

// const ipCut = 'http://202.157.184.229:1001/service_mobile.asmx/Perintah';

// API Mobile Priuk :
// http://agunglogisticsapp.co.id:1025/service_mobile.asmx/Perintah
// http://118.97.100.75:1025/service_mobile.asmx/Perintah
// untuk ARV, AJL
// const domainPriyok =
//     'http://agunglogisticsapp.co.id:1025/service_mobile.asmx/Perintah';

// const ipPriyok = 'http://118.97.100.75:1025/service_mobile.asmx/Perintah';

// [16:35, 18/12/2023] Pak Ismu: oke gini gs_18 dan gs_21 diarahkan ke http://118.97.100.75:1025/service_mobile.asmx/Perintah
// [16:36, 18/12/2023] Pak Ismu: gs_12, gs_14, gs_16 diarahkan ke http://180.250.79.122:1025/service_mobile.asmx/Perintah

@riverpod
class IpNotifier extends _$IpNotifier {
  @override
  FutureOr<void> build() async {
    initOnLogin('');

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? _json = prefs.getString('remember_me');

    // if (_json != null) {
    //   final model = _parseJson(_json);
    //   final ip = _initializeIp(model.ptName);

    // } else {
    //   final ip = ipCut;

    // }
  }

  initOnLogin(String pt) {
    // final ip = _initializeIp(pt);

    ref.read(dioProvider)
      ..options = BaseOptions(
        connectTimeout: BuildConfig.get().connectTimeout,
        receiveTimeout: BuildConfig.get().receiveTimeout,
        validateStatus: (status) {
          return true;
        },
        baseUrl: isTesting ? ipHosting : ip,
      )
      ..interceptors.add(ref.read(authInterceptorProvider));

    ref.read(dioProviderHosting)
      ..options = BaseOptions(
        connectTimeout: BuildConfig.get().connectTimeout,
        receiveTimeout: BuildConfig.get().receiveTimeout,
        validateStatus: (status) {
          return true;
        },
        baseUrl: ipHosting,
      )
      ..interceptors.add(ref.read(authInterceptorProvider));
  }
}



  // RememberMeModel _parseJson(String json) {
  //   return RememberMeModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
  // }

  // Map<String, List<String>> ipMap = {
  //   ipCut: [
  //     'PT Agung Citra Transformasi',
  //     'PT Agung Transina Raya',
  //     'PT Agung Lintas Raya'
  //         'PT Agung Tama Raya'
  //   ],
  //   // ipPriyok: ['PT Agung Raya', 'PT Agung Jasa Logistik'],
  // };

  // String _initializeIp(String pt) {
  //   final ptInMap = ipMap.entries.firstWhereOrNull(
  //     (entries) =>
  //         entries.value.firstWhereOrNull((element) => element == pt) != null,
  //   );

  //   if (ptInMap != null) {
  //     final ip = ptInMap.key;
  //     return ip;
  //   } else {
  //     // default
  //     return ipCut;
  //   }
  // }