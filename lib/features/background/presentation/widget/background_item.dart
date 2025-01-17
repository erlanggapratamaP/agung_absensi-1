import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/saved_location.dart';
import 'background_item_detail.dart';

class BackgroundItem extends ConsumerWidget {
  const BackgroundItem({
    Key? key,
    required this.index,
    required this.item,
  }) : super(key: key);

  final int index;
  final SavedLocation item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Palette.containerBackgroundColor.withOpacity(0.1),
        ),
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: BackgroundItemDetail(
                alamat: item.alamat ?? '',
                date: item.date.toString(),
                latitude: item.latitude.toString(),
                longitude: item.longitude.toString(),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                    width: width,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Palette.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: // Lokasi Masuk
                        Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          item.absenState.maybeWhen(
                              orElse: () => 'NaN',
                              empty: () => 'Jenis : Absen Masuk',
                              absenIn: () => 'Jenis : Absen Keluar'),
                          style: Themes.customColor(
                            11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )),
              ),
            ),
            SizedBox(
              width: 4,
            ),
          ],
        ),
      ),
    );
  }
}
