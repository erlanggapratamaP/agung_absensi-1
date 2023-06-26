import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_model.dart';
import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_notifier.dart';
import 'package:face_net_authentication/constants/assets.dart';
import 'package:face_net_authentication/domain/riwayat_absen_failure.dart';
import 'package:face_net_authentication/pages/riwayat/riwayat_scaffold.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:face_net_authentication/pages/widgets/v_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';

class RiwayatAbsenPage extends ConsumerWidget {
  const RiwayatAbsenPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Option<Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>>>>(
        riwayatAbsenNotifierProvider
            .select((value) => value.failureOrSuccessOption),
        (_, failureOrSuccessOption) => {
              failureOrSuccessOption.fold(
                  () {},
                  (either) => either.fold(
                          (error) => error.when(
                                server: ((errorCode, message) =>
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (builder) => VSimpleDialog(
                                            label: 'Error $errorCode',
                                            labelDescription: '$message',
                                            asset: Assets.iconCrossed,
                                            color: Palette.red))),
                                wrongFormat: () => showCupertinoDialog(
                                    context: context,
                                    builder: (builder) => VSimpleDialog(
                                        label: 'FormatException',
                                        labelDescription: 'Error parsing',
                                        asset: Assets.iconCrossed,
                                        color: Palette.red)),
                                noConnection: () => showCupertinoDialog(
                                    context: context,
                                    builder: (builder) => VSimpleDialog(
                                        label: 'NoConnection',
                                        labelDescription: 'no internet',
                                        asset: Assets.iconCrossed,
                                        color: Palette.red)),
                              ), (list) {
                        final oldList = ref
                            .read(riwayatAbsenNotifierProvider.notifier)
                            .state
                            .riwayatAbsen;

                        log('list.length ${list.length}');

                        if (list.length < 1) {
                          ref
                              .read(riwayatAbsenNotifierProvider.notifier)
                              .changeIsMore(false);
                        } else {
                          // debugger(message: 'called');

                          ref
                              .read(riwayatAbsenNotifierProvider.notifier)
                              .changeAbsenRiwayat(oldList, list);
                        }
                      }))
            });

    final isLoading = ref
        .watch(riwayatAbsenNotifierProvider.select((value) => value.isGetting));

    return Stack(
      children: [RiwayatAbsenScaffold(), LoadingOverlay(isLoading: isLoading)],
    );
  }
}
