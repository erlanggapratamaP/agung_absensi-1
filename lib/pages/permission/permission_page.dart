import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/auth/auth_notifier.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../application/routes/route_names.dart';
import '../../shared/providers.dart';
import '../widgets/loading_overlay.dart';
import 'permission_scaffold.dart';

final initPermission = FutureProvider<Unit>((ref) async {
  // if (await Permission.camera.status.isPermanentlyDenied ||
  //     await Permission.camera.status.isDenied) {
  //   ref.read(permissionProvider.notifier).changeCamera(false);
  // } else {
  //   ref.read(permissionProvider.notifier).changeCamera(true);
  // }

  if (await Permission.location.status.isPermanentlyDenied ||
      await Permission.location.status.isDenied) {
    ref.read(permissionProvider.notifier).changeLocation(false);
  } else {
    ref.read(permissionProvider.notifier).changeLocation(true);
  }

  ref.read(permissionProvider.notifier).changeAuthorized(
      // ref.read(permissionProvider).cameraAuthorized &&
      ref.read(permissionProvider).locationAuthorized);

  return unit;
});

class PermissionPage extends HookConsumerWidget {
  const PermissionPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initPermission, (_, __) {});

    ref.listen<bool>(permissionProvider.select((value) => value.isAuthorized),
        (_, isAuthorized) async {
      if (isAuthorized == true) {
        await ref
            .read(authNotifierProvider.notifier)
            .checkAndUpdateAuthStatus();

        final isLoggedIn = ref.watch(authNotifierProvider);

        isLoggedIn == AuthState.authenticated()
            ? context.replaceNamed(RouteNames.welcomeNameRoute)
            : context.replaceNamed(RouteNames.signInNameRoute);
      }
    });

    return Stack(
      children: const [
        PermissionScaffold(),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
