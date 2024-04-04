import 'package:face_net_authentication/widgets/v_async_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';

import '../../../shared/providers.dart';
import '../../../style/style.dart';

import '../../../utils/dialog_helper.dart';
import '../../../widgets/tappable_widget.dart';
import '../../../widgets/v_dialogs.dart';
import '../../absen_manual_approve/application/absen_manual_approve_notifier.dart';
import '../../create_absen_manual/application/create_absen_manual_notifier.dart';
import '../../create_absen_manual/application/jenis_absen.dart';
import '../application/absen_manual_list.dart';
import 'absen_manual_dtl_dialog.dart';

class AbsenManualListItem extends HookConsumerWidget {
  const AbsenManualListItem(
    this.item,
  );

  final AbsenManualList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // final _isSpvApprove = item.spvTgl != item.cDate && item.spvSta == true;
    // final spvAging = _isSpvApprove
    //     ? DateTime.parse(item.spvTgl!)
    //         .difference(DateTime.parse(item.cDate!))
    //         .inDays
    //     : DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

    // final _isHrdApprove = item.hrdTgl != item.cDate && item.hrdSta == true;
    // final hrdAging = _isHrdApprove
    //     ? DateTime.parse(item.hrdTgl!)
    //         .difference(DateTime.parse(item.cDate!))
    //         .inDays
    //     : DateTime.now().difference(DateTime.parse(item.cDate!)).inDays;

    final jenisAbsen = ref.watch(jenisAbsenManualNotifierProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 170,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: item.btlSta == true ? Palette.red : theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: item.btlSta == true
                          ? Colors.white
                          : Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset:
                          Offset(0, 1), // Controls the position of the shadow
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upper Part
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT
                      Text(
                        DateFormat(
                          'EEEE, dd MMMM yyyy',
                        ).format(DateTime.parse(item.cDate!)),
                        style: Themes.customColor(10,
                            fontWeight: FontWeight.w500,
                            color: item.btlSta == true
                                ? Colors.white
                                : Palette.primaryColor),
                      ),

                      Spacer(),

                      // tappable svg
                      TappableSvg(
                          assetPath: Assets.iconDetail,
                          color: item.btlSta == true
                              ? Colors.white
                              : Palette.primaryColor,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AbsenManualDtlDialog(
                                item: item,
                              ),
                            );
                          }),
                      SizedBox(
                        width: 4,
                      ),
                      if (item.btlSta == false)
                        TappableSvg(
                            assetPath: Assets.iconBatal,
                            onTap: () {
                              if (!ref
                                  .read(absenManualApproveControllerProvider
                                      .notifier)
                                  .canBatal(item)) {
                                showDialog(
                                  context: context,
                                  builder: (context) => VFailedDialog(),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => VBatalDialog(
                                    onTap: () async {
                                      context.pop();
                                      await ref
                                          .read(
                                              absenManualApproveControllerProvider
                                                  .notifier)
                                          .batal(
                                            item: item,
                                            nama: ref
                                                .read(userNotifierProvider)
                                                .user
                                                .nama!,
                                          );
                                    },
                                  ),
                                );
                              }
                            }),
                    ],
                  ),

                  SizedBox(
                    height: 2,
                  ),

                  Divider(
                    height: 2,
                    color: Palette.dividerColor,
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // MIDDLE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama',
                              style: Themes.customColor(7,
                                  color: item.btlSta == true
                                      ? Colors.white
                                      : Colors.grey),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              item.fullname ?? '-',
                              style: Themes.customColor(9,
                                  color: item.btlSta == true
                                      ? Colors.white
                                      : Palette.primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jam Awal',
                            style: Themes.customColor(7,
                                color: item.btlSta == true
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            item.jamAwal == null
                                ? '-'
                                : DateFormat(
                                    'hh:mm a',
                                  ).format(DateTime.parse(item.jamAwal!)),
                            style: Themes.customColor(9,
                                color: item.btlSta == true
                                    ? Colors.white
                                    : Palette.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jam Akhir',
                            style: Themes.customColor(7, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            item.jamAkhir == null
                                ? '-'
                                : DateFormat(
                                    'hh:mm a',
                                  ).format(DateTime.parse(item.jamAkhir!)),
                            style: Themes.customColor(9,
                                color: item.btlSta == true
                                    ? Colors.white
                                    : Palette.tertiaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jenis',
                            style: Themes.customColor(7, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: 90,
                            child: VAsyncValueWidget<List<JenisAbsen>>(
                              value: jenisAbsen,
                              data: (list) => Text(
                                "${list.firstWhere((element) => element.Kode == item.jenisAbsen).Nama}",
                                style: Themes.customColor(9,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.orange,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 4,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keterangan',
                        style: Themes.customColor(7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        '${item.ket}',
                        style: Themes.customColor(9,
                            color: item.btlSta == true
                                ? Colors.white
                                : Palette.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // approval
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      if (item.btlSta == true) ...[
                        Expanded(
                          child: Container(
                            height: 25,
                            decoration: BoxDecoration(
                                color: Palette.primaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0,
                                        1), // Controls the position of the shadow
                                  ),
                                ]),
                            child: Center(
                              child: Text(
                                'Canceled by ${item.btlNm}',
                                style: Themes.customColor(7,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        // ok
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey
                                            .withOpacity(0.5), // Shadow color
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0,
                                        1), // Controls the position of the shadow
                                  ),
                                ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Palette.primaryColor,
                                    onTap: () async {
                                      if (!ref
                                          .read(
                                              absenManualApproveControllerProvider
                                                  .notifier)
                                          .canSpvApprove(item)) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VFailedDialog(),
                                        );
                                      } else {
                                        // jika belum diapprove maka approve
                                        // kl udah di unapprove
                                        if (item.spvSta == false) {
                                          await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  VAlertDialog2(
                                                      label:
                                                          'Dibutuhkan Konfirmasi SPV (Approve)',
                                                      onPressed: () async {
                                                        context.pop();

                                                        await ref
                                                            .read(
                                                                absenManualApproveControllerProvider
                                                                    .notifier)
                                                            .approveSpv(
                                                                item: item,
                                                                nama: ref
                                                                    .read(
                                                                        userNotifierProvider)
                                                                    .user
                                                                    .nama!);
                                                      }));
                                        } else {
                                          await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  VAlertDialog2(
                                                      label:
                                                          'Dibutuhkan Konfirmasi SPV (Unapprove)',
                                                      onPressed: () async {
                                                        context.pop();
                                                        await ref
                                                            .read(
                                                                absenManualApproveControllerProvider
                                                                    .notifier)
                                                            .unApproveSpv(
                                                                item: item,
                                                                nama: ref
                                                                    .read(
                                                                        userNotifierProvider)
                                                                    .user
                                                                    .nama!);
                                                      }));
                                        }
                                      }
                                    },
                                    child: Ink(
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                          ),
                                          color: item.spvSta == true
                                              ? Palette.green
                                              : Palette.red2,
                                          boxShadow: [
                                            BoxShadow(
                                              color: item.btlSta == true
                                                  ? Colors.white
                                                  : Colors.grey.withOpacity(
                                                      0.5), // Shadow color
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: Offset(0,
                                                  1), // Controls the position of the shadow
                                            ),
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Approve SPV',
                                            style: Themes.customColor(7,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (item.spvSta == true)
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbUp,
                                  ),
                                ),
                              if (item.spvSta == false)
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: SvgPicture.asset(
                                    Assets.iconThumbDown,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // not ok
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Colors.grey
                                            .withOpacity(0.5), // Shadow color
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0,
                                        1), // Controls the position of the shadow
                                  ),
                                ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Palette.primaryColor,
                                    onTap: () async {
                                      if (!ref
                                          .read(
                                              absenManualApproveControllerProvider
                                                  .notifier)
                                          .canHrdApprove(item)) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => VFailedDialog(),
                                        );
                                      } else {
                                        final String? text =
                                            await DialogHelper<void>()
                                                .showFormDialog(
                                          label: 'Note HRD',
                                          context: context,
                                        );

                                        if (text != null) {
                                          if (item.hrdSta == false)
                                            await ref
                                                .read(
                                                    absenManualApproveControllerProvider
                                                        .notifier)
                                                .approveHrd(
                                                  note: text,
                                                  item: item,
                                                  namaHrd: ref
                                                      .read(
                                                          userNotifierProvider)
                                                      .user
                                                      .nama!,
                                                );
                                          else
                                            await ref
                                                .read(
                                                    absenManualApproveControllerProvider
                                                        .notifier)
                                                .unApproveHrd(
                                                  idAbsenMnl: item.idAbsenmnl,
                                                  note: text,
                                                  namaHrd: ref
                                                      .read(
                                                          userNotifierProvider)
                                                      .user
                                                      .nama!,
                                                );
                                        }
                                      }
                                    },
                                    child: Ink(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(8),
                                        ),
                                        color: item.hrdSta == true
                                            ? Palette.green
                                            : Palette.red2,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Approve HRD',
                                            style: Themes.customColor(7,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (item.hrdSta == true)
                                Positioned(
                                  left: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: Transform.scale(
                                    scaleX: -1,
                                    child: SvgPicture.asset(
                                      Assets.iconThumbUp,
                                    ),
                                  ),
                                ),
                              if (item.hrdSta == false)
                                Positioned(
                                  left: 5,
                                  bottom: 0,
                                  top: 0,
                                  child: Transform.scale(
                                    scaleX: -1,
                                    child: SvgPicture.asset(
                                      Assets.iconThumbDown,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ]
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
