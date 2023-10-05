import 'package:face_net_authentication/application/permission/permission_state.dart';
import 'package:face_net_authentication/application/permission/shared/permission_introduction_providers.dart';
import 'package:face_net_authentication/pages/widgets/v_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/app_logo.dart';
import '../widgets/copyright_text.dart';
import '../widgets/welcome_label.dart';
import 'widget/permission_item.dart';

class PermissionScaffold extends ConsumerWidget {
  const PermissionScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(permissionNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 70),
                const AppLogo(),
                const SizedBox(height: 70),
                const WelcomeLabel(title: 'Selamat datang'),
                const SizedBox(height: 35),
                // Visibility(
                //   visible: !permission.cameraAuthorized,
                //   child: Padding(
                //       padding: const EdgeInsets.all(12.0),
                //       child: PermissionItem(
                //         label:
                //             'Kamera dibutuhkan untuk verifikasi wajah. \nPastikan kamera menyala.',
                //         onPressed: () =>
                //             ref.read(permissionProvider.notifier).askCamera(),
                //         title: 'Nyalakan kamera anda',
                //       )),
                // ),
                Visibility(
                  visible: permission == PermissionState.initial(),
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: PermissionItem(
                        label:
                            'Lokasi dibutuhkan untuk memastikan anda berada di lokasi kantor agung group.',
                        onPressed: () async {
                          if (!await FlLocation.isLocationServicesEnabled) {
                            showDialog(
                              context: context,
                              builder: (context) => VSimpleDialog(
                                  label: 'GPS Tidak Berfungsi',
                                  labelDescription:
                                      'Mohon nyalakan GPS pada device anda. Terimakasih',
                                  asset: 'assets/ic_location_off.svg'),
                            );
                          } else {
                            await ref
                                .read(permissionNotifierProvider.notifier)
                                .requestLocation();

                            await ref
                                .read(permissionNotifierProvider.notifier)
                                .requestDenied();

                            await ref
                                .read(permissionNotifierProvider.notifier)
                                .checkAndUpdateLocation();
                          }
                        },
                        title: 'Nyalakan lokasi anda',
                      )),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CopyrightAgung(),
            ),
          ],
        ),
      ),
    );
  }
}
