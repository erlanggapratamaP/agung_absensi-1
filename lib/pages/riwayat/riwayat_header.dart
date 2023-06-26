import 'dart:developer';

import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_notifier.dart';
import 'package:face_net_authentication/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';

class RiwayatHeader extends ConsumerWidget {
  const RiwayatHeader({required this.date});

  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Palette.primaryColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                date,
                style: Themes.black(FontWeight.bold, 15),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              lastDate: DateTime.now(),
              firstDate: new DateTime(2021),
            );
            if (picked != null) {
              print(picked);

              final start = StringUtils.formatTanggal('${picked.start}');
              final end = StringUtils.formatTanggal('${picked.end}');

              await ref.read(riwayatAbsenNotifierProvider.notifier).startFilter(
                  changePage: () => ref
                      .read(riwayatAbsenNotifierProvider.notifier)
                      .changePage(1),
                  changeFilter: () => ref
                      .read(riwayatAbsenNotifierProvider.notifier)
                      .changeFilter(end, start),
                  onAllChanged: () async => ref
                      .read(riwayatAbsenNotifierProvider.notifier)
                      .getAbsenRiwayat(
                          page: 1, dateFirst: end, dateSecond: start));
            }
          },
          child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.primaryColor),
              child: Icon(
                Icons.filter_alt_rounded,
                color: Colors.black,
              )),
        ),
      ],
    );
  }
}
