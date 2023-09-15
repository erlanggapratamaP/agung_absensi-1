import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/edit_failure.dart';
import 'package:face_net_authentication/pages/profile/edit_profile/edit_profile_scaffold.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/routes/route_names.dart';
import '../../../constants/assets.dart';
import '../../../shared/providers.dart';
import '../../widgets/v_dialogs.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage();

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider.select((value) => value.user));

    ref.listen<Option<Either<EditFailure, Unit>>>(
      editProfileNotifierProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
              (failure) => failure.maybeMap(
                    orElse: () => showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                        label: 'Error',
                        labelDescription: failure.maybeMap(
                            server: (server) => 'error server $server',
                            passwordExpired: (value) => '$value',
                            passwordWrong: (value) => '$value',
                            noConnection: (_) => 'no connection',
                            orElse: () => ''),
                        asset: Assets.iconCrossed,
                      ),
                    ),
                  ),
              (_) => ref
                  .read(editProfileNotifierProvider.notifier)
                  .onEditProfile(
                      saveUser: () => ref
                          .read(userNotifierProvider.notifier)
                          .saveUserAfterUpdate(user: user),
                      onUser: () =>
                          context.replaceNamed(RouteNames.profileNameRoute)))),
    );

    final isSubmitting = ref.watch(
        editProfileNotifierProvider.select((value) => value.isSubmitting));

    return Stack(
      children: [
        EditProfileScaffold(),
        LoadingOverlay(isLoading: isSubmitting)
      ],
    );
  }
}