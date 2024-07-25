import 'package:face_net_authentication/utils/logging.dart';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../absen/application/absen_state.dart';
import '../../background/application/saved_location.dart';
import '../../geofence/application/geofence_error_notifier.dart';
import '../../routes/application/route_names.dart';
import '../../utils/dialog_helper.dart';
import '../../utils/enums.dart';
import '../../utils/os_vibrate.dart';
import 'auto_absen_state.dart';

import '../../constants/assets.dart';
import '../../shared/providers.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../widgets/v_dialogs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:face_net_authentication/style/style.dart';

class AutoAbsenNotifier extends StateNotifier<AutoAbsenState> {
  AutoAbsenNotifier(this.ref) : super(AutoAbsenState.initial());

  StateNotifierProviderRef<AutoAbsenNotifier, AutoAbsenState> ref;

  Future<void> processAutoAbsen({
    required String imei,
    required List<Geofence> geofence,
    required BuildContext buildContext,
    required List<SavedLocation> savedItems,
    required Map<DateTime, List<SavedLocation>> autoAbsenMap,
  }) async {
    final Iterable<List<SavedLocation>> list = autoAbsenMap.values;

    final Map<StatusAbsen, List<SavedLocation>> successAbsen = {
      StatusAbsen.sukses: [],
      StatusAbsen.gagal: [],
      StatusAbsen.dihapus: [],
    };

    if (list.isNotEmpty) {
      int startIndex = 0;
      void incrementIndex() => startIndex = startIndex + 1;

      list.forEach((absensInDate) async {
        /// check if absen [AbsenState.empty()], [AbsenState.absenIn()] or [AbsenState.complete()]
        ///

        if (absensInDate.isNotEmpty && startIndex < list.length) {
          // ID GEOF, IMEI field
          final absenSaved = absensInDate[startIndex];
          final idGeofSaved = absenSaved.idGeof;

          // GET RECENT ABSEN STATE
          final absenState = absenSaved.absenState;

          final belumAbsen = absenState == AbsenState.empty();
          final udahAbsenMasuk = absenState == AbsenState.absenIn();
          final udahAbsenSemua = absenState == AbsenState.complete();

          JenisAbsen jenisAbsenShift = JenisAbsen.unknown;

          final karyawanShift =
              await ref.read(karyawanShiftFutureProvider.future);

          if (karyawanShift) {
            await showDialog(
                context: buildContext,
                barrierDismissible: false,
                builder: (context) => VAlertDialog(
                      label: 'PILIH ABSEN',
                      labelDescription: 'PILIH ABSEN IN ATAU OUT',
                      pressedLabel: 'ABSEN IN',
                      backPressedLabel: 'ABSEN OUT',
                      onPressed: () async {
                        await OSVibrate.vibrate();
                        jenisAbsenShift = JenisAbsen.absenIn;
                        buildContext.pop();
                      },
                      onBackPressed: () async {
                        await OSVibrate.vibrate();
                        jenisAbsenShift = JenisAbsen.absenOut;
                        buildContext.pop();
                      },
                    ));
          }

          // debugger();

          Log.info(
              'CONDITION 1 : ${belumAbsen || jenisAbsenShift == JenisAbsen.absenIn}');
          Log.info(
              'CONDITION 2 : ${udahAbsenMasuk || jenisAbsenShift == JenisAbsen.absenOut}');

          if (belumAbsen || jenisAbsenShift == JenisAbsen.absenIn) {
            //
            final jenisAbsen = jenisAbsenShift == JenisAbsen.unknown
                ? JenisAbsen.absenIn
                : jenisAbsenShift;

            final date = absenSaved.date;

            await OSVibrate.vibrate().then((_) => showDialog(
                context: buildContext,
                barrierDismissible: false,
                builder: (context) => VAlertDialog(
                    label: 'Absen In ? ',
                    labelDescription: DateFormat('HH:mm dd MMM').format(date),
                    backPressedLabel: 'TIDAK & HAPUS ABSEN',
                    onPressed: () async {
                      await ref
                          .read(absenAuthNotifierProvidier.notifier)
                          .absenOneLiner(
                              jenisAbsen: jenisAbsen,
                              backgroundItemState: absenSaved,
                              idGeof: idGeofSaved ?? '',
                              imei: imei,
                              onAbsen: getSavedLocations,
                              deleteSaved: () async {
                                await successAbsen.update(
                                  StatusAbsen.dihapus,
                                  (value) => [...value, absenSaved],
                                );

                                await deleteSavedLocation(
                                    savedLocation: absenSaved);
                              },
                              onSuccess: () {
                                successAbsen.update(
                                  StatusAbsen.sukses,
                                  (value) => [...value, absenSaved],
                                );
                              },
                              onFailure: () {
                                successAbsen.update(
                                  StatusAbsen.gagal,
                                  (value) => [...value, absenSaved],
                                );
                              },
                              showFailureDialog: (code, message) =>
                                  _showFailureDialog(
                                      buildContext, code, message));

                      // absen one liner
                      buildContext.pop();
                    },
                    onBackPressed: () async {
                      buildContext.pop();

                      await successAbsen.update(
                        StatusAbsen.dihapus,
                        (value) => [...value, absenSaved],
                      );
                      await deleteSavedLocation(savedLocation: absenSaved);
                    })));

            incrementIndex();
          } else if (udahAbsenMasuk || jenisAbsenShift == JenisAbsen.absenOut) {
            //
            final jenisAbsen = jenisAbsenShift == JenisAbsen.unknown
                ? JenisAbsen.absenOut
                : jenisAbsenShift;

            final date = absenSaved.date;

            await showDialog(
                context: buildContext,
                barrierDismissible: false,
                builder: (context) => VAlertDialog(
                    label: 'Absen Out ? ',
                    labelDescription: DateFormat('HH:mm dd MMM').format(date),
                    backPressedLabel: 'TIDAK & HAPUS ABSEN',
                    onPressed: () async {
                      await ref
                          .read(absenAuthNotifierProvidier.notifier)
                          .absenOneLiner(
                              jenisAbsen: jenisAbsen,
                              backgroundItemState: absenSaved,
                              idGeof: idGeofSaved ?? '',
                              imei: imei,
                              onAbsen: getSavedLocations,
                              deleteSaved: () async {
                                await successAbsen.update(
                                  StatusAbsen.dihapus,
                                  (value) => [...value, absenSaved],
                                );

                                await deleteSavedLocation(
                                    savedLocation: absenSaved);
                              },
                              onSuccess: () {
                                successAbsen.update(
                                  StatusAbsen.sukses,
                                  (value) => [...value, absenSaved],
                                );
                              },
                              onFailure: () {
                                successAbsen.update(
                                  StatusAbsen.gagal,
                                  (value) => [...value, absenSaved],
                                );
                              },
                              showFailureDialog: (code, message) =>
                                  _showFailureDialog(
                                      buildContext, code, message));

                      // absen one liner
                      buildContext.pop();
                    },
                    onBackPressed: () async {
                      buildContext.pop();
                      await successAbsen.update(
                        StatusAbsen.dihapus,
                        (value) => [...value, absenSaved],
                      );

                      await OSVibrate.vibrate();
                      await deleteSavedLocation(savedLocation: absenSaved);
                    }));

            incrementIndex();
          } else if (udahAbsenSemua) {
            await OSVibrate.vibrate();
            await successAbsen.update(
              StatusAbsen.dihapus,
              (value) => [...value, absenSaved],
            );

            await deleteSavedLocation(savedLocation: absenSaved);

            await getSavedLocations();
            await ref.read(geofenceProvider.notifier).getGeofenceList();

            incrementIndex();
          }

          final Function(Location location) mockListener = ref
              .read(mockLocationNotifierProvider.notifier)
              .checkMockLocationState;

          // REINITIALIZE
          await reinitializeDependencies(
            context: buildContext,
            geofence: geofence,
            mockListener: mockListener,
          );

          if (startIndex == list.length) {
            await _showSuccessDialog(buildContext, successAbsen);
          }
        }
      });
    }
  }

  Future<void> _showSuccessDialog(
    BuildContext buildContext,
    Map<StatusAbsen, List<SavedLocation>> successAbsen,
  ) async {
    final absenSukses = successAbsen.entries
        .where((element) => element.key == StatusAbsen.sukses)
        .first
        .value;

    final absenGagal = successAbsen.entries
        .where((element) => element.key == StatusAbsen.gagal)
        .first
        .value;

    final absenDihapus = successAbsen.entries
        .where((element) => element.key == StatusAbsen.dihapus)
        .first
        .value;

    final String sukses =
        'Absen Sukses :\n${absenSukses.map((e) => 'Absen ${e.absenState == AbsenState.empty() ? 'Masuk' : 'Keluar'}'
            ' Tanggal: ${DateFormat('dd MMM HH:mm').format(e.date)}\n')}';

    final String gagal =
        'Absen Gagal :\n${absenGagal.map((e) => 'Absen ${e.absenState == AbsenState.empty() ? 'Masuk' : 'Keluar'}'
            ' Tanggal: ${DateFormat('dd MMM HH:mm').format(e.date)}\n')}';

    final String dihapus =
        'Absen Dihapus :\n${absenDihapus.map((e) => 'Absen ${e.absenState == AbsenState.empty() ? 'Masuk' : 'Keluar'}'
            ' Tanggal: ${DateFormat('dd MMM HH:mm').format(e.date)}\n')}';

    return OSVibrate.vibrate().then((_) => showDialog(
          context: buildContext,
          barrierDismissible: true,
          builder: (_) => VSimpleDialog(
              asset:
                  absenSukses.isEmpty ? Assets.iconCrossed : Assets.iconChecked,
              label: 'Daftar Absen Tersimpan ',
              labelDescription: sukses + gagal + dihapus),
        ).then((_) => absenSukses.isEmpty
            ? () {}
            : buildContext.pushNamed(RouteNames.riwayatAbsenRoute)));
  }

  Future<void> _showFailureDialog(
      BuildContext buildContext, String code, String message) async {
    buildContext.pop();
    await OSVibrate.vibrate();
    await showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
              color: Palette.red,
              asset: Assets.iconCrossed,
              label: code,
              labelDescription: message,
            ));
  }

  List<SavedLocation> currentNetworkTimeForSavedAbsen({
    required DateTime dbDate,
    required List<SavedLocation> savedItems,
  }) {
    List<SavedLocation> locations = [];

    savedItems.forEach((element) {
      locations.add(element.copyWith(
        dbDate: dbDate,
      ));
    });

    return locations;
  }

  Map<DateTime, List<SavedLocation>> sortAbsenMap(
      List<SavedLocation> backgroundItems) {
    return backgroundItems.groupListsBy(
      (element) => element.date,
    );
  }

  Future<void> getSavedLocations() async {
    await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();
  }

  Future<void> deleteSavedLocation({
    required SavedLocation savedLocation,
  }) async {
    return ref
        .read(backgroundNotifierProvider.notifier)
        .removeLocationFromSaved(savedLocation);
  }

  Future<void> reinitializeDependencies({
    required BuildContext context,
    required List<Geofence> geofence,
    required Function(Location location) mockListener,
  }) async {
    await getSavedLocations();
    await ref.read(geofenceProvider.notifier).initializeGeoFence(
      geofence,
      mockListener: mockListener,
      onError: (e) async {
        String msg = '';

        if (e is ErrorCodes) {
          msg = ref
              .read(geofenceErrorNotifierProvider.notifier)
              .geofenceErrMessage(e);

          ref
              .read(geofenceErrorNotifierProvider.notifier)
              .checkAndUpdateError(e);
        } else {
          msg = e.toString();
        }

        Log.shout(msg);

        await DialogHelper.showCustomDialog(
          msg,
          context,
        );
      },
    );
  }
}
