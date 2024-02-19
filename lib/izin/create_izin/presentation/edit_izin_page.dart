import 'dart:developer';

import 'package:face_net_authentication/izin/create_izin/application/create_izin_notifier.dart';
import 'package:face_net_authentication/izin/izin_list/application/izin_list_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_button.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/assets.dart';
import '../../../shared/providers.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../style/style.dart';
import '../../../user_helper/user_helper_notifier.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/v_dialogs.dart';
import '../../izin_list/application/izin_list.dart';
import '../../izin_list/application/jenis_izin.dart';
import '../application/jenis_izin_notifier.dart';

class EditIzinPage extends HookConsumerWidget {
  const EditIzinPage(this.item);

  final IzinList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).user;
    final namaTextController = useTextEditingController(text: user.nama);
    final ptTextController = useTextEditingController(text: user.payroll);

    final keteranganTextController = useTextEditingController(text: item.ket);
    final jenisIzinTextController = useState(item.idMstIzin);

    final tglPlaceholderTextController = useTextEditingController(
        text:
            'Dari ${StringUtils.formatTanggal(item.tglStart!)} Sampai ${StringUtils.formatTanggal(item.tglEnd!)}');

    final tglAwalTextController = useState(
        StringUtils.midnightDate(DateTime.parse(item.tglStart!))
            .replaceAll('.000', ''));
    final tglAkhirTextController = useState(
        StringUtils.midnightDate(DateTime.parse(item.tglEnd!))
            .replaceAll('.000', ''));

    final spvTextController = useTextEditingController();
    final hrdTextController = useTextEditingController();

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    ref.listen<AsyncValue>(createIzinNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(context,
            color: Palette.primaryColor,
            message: 'Sukses Mengupdate Form Izin', onDone: () {
          ref.invalidate(izinListControllerProvider);
          context.pop();
          return Future.value(true);
        });
      }
      return state.showAlertDialogOnError(context);
    });

    final userHelper = ref.watch(userHelperNotifierProvider);
    final createIzin = ref.watch(createIzinNotifierProvider);
    final jenisIzin = ref.watch(jenisIzinNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: userHelper,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createIzin,
          data: (_) => VScaffoldWidget(
              scaffoldTitle: 'Edit Form Izin',
              scaffoldBody: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // NAMA
                      TextFormField(
                          enabled: false,
                          controller: namaTextController,
                          cursorColor: Palette.primaryColor,
                          keyboardType: TextInputType.name,
                          decoration: Themes.formStyleBordered(
                            'Nama',
                          ),
                          style: Themes.customColor(
                            14,
                          ),
                          validator: (item) {
                            if (item == null) {
                              return 'Form tidak boleh kosong';
                            } else if (item.isEmpty) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          }),

                      SizedBox(
                        height: 16,
                      ),

                      // PT
                      TextFormField(
                          enabled: false,
                          controller: ptTextController,
                          cursorColor: Palette.primaryColor,
                          keyboardType: TextInputType.name,
                          decoration: Themes.formStyleBordered(
                            'PT',
                          ),
                          style: Themes.customColor(
                            14,
                          ),
                          validator: (item) {
                            if (item == null) {
                              return 'Form tidak boleh kosong';
                            } else if (item.isEmpty) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          }),

                      SizedBox(
                        height: 16,
                      ),

                      // SURAT DOKTER
                      VAsyncValueWidget<List<JenisIzin>>(
                        value: jenisIzin,
                        data: (item) => DropdownButtonFormField<JenisIzin>(
                          elevation: 0,
                          iconSize: 20,
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Palette.primaryColor),
                          decoration: Themes.formStyleBordered(
                            'Jenis Izin',
                          ),
                          value: item.firstWhere(
                            (element) =>
                                element.idMstIzin ==
                                jenisIzinTextController.value,
                            orElse: () => item.first,
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Form tidak boleh kosong';
                            }

                            if (value.nama!.isEmpty) {
                              return 'Form tidak boleh kosong';
                            }
                            return null;
                          },
                          onChanged: (JenisIzin? value) {
                            if (value != null) {
                              jenisIzinTextController.value = value.idMstIzin!;
                            }
                          },
                          isExpanded: true,
                          items: item.map<DropdownMenuItem<JenisIzin>>(
                              (JenisIzin value) {
                            return DropdownMenuItem<JenisIzin>(
                              value: value,
                              child: Text(
                                value.nama ?? "",
                                style: Themes.customColor(
                                  14,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      // TGL
                      InkWell(
                        onTap: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            lastDate: DateTime.now(),
                            firstDate: new DateTime(2021),
                          );
                          if (picked != null) {
                            print(picked);

                            final start = StringUtils.midnightDate(picked.start)
                                .replaceAll('.000', '');
                            final end = StringUtils.midnightDate(picked.end)
                                .replaceAll('.000', '');

                            tglAwalTextController.value = start;
                            tglAkhirTextController.value = end;

                            final startPlaceHolder = StringUtils.formatTanggal(
                                picked.start.toString());
                            final endPlaceHolder = StringUtils.formatTanggal(
                                picked.end.toString());

                            tglPlaceholderTextController.text =
                                'Dari $startPlaceHolder Sampai $endPlaceHolder';

                            log('START $start END $end');
                          }
                        },
                        child: Ink(
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                controller: tglPlaceholderTextController,
                                cursorColor: Palette.primaryColor,
                                decoration: Themes.formStyleBordered(
                                  'Tanggal',
                                ),
                                style: Themes.customColor(
                                  14,
                                ),
                                validator: (item) {
                                  if (item == null) {
                                    return 'Form tidak boleh kosong';
                                  } else if (item.isEmpty) {
                                    return 'Form tidak boleh kosong';
                                  }

                                  return null;
                                }),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      // DIAGNOSA
                      TextFormField(
                          maxLines: 5,
                          controller: keteranganTextController,
                          cursorColor: Palette.primaryColor,
                          decoration: Themes.formStyleBordered(
                            'Diagnosa',
                          ),
                          style: Themes.customColor(
                            14,
                          ),
                          validator: (item) {
                            if (item == null) {
                              return 'Form tidak boleh kosong';
                            } else if (item.isEmpty) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          }),

                      SizedBox(
                        height: 16,
                      ),

                      VButton(
                          label: 'Update Form Izin',
                          onPressed: () async {
                            log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                            log(' Payroll: ${ptTextController.value.text} \n ');
                            log(' Diagnosa: ${keteranganTextController.value.text} \n ');
                            log(' Surat Dokter: ${jenisIzinTextController.value}  \n ');
                            log(' Tgl Awal: ${tglAwalTextController.value} Tgl Akhir: ${tglAkhirTextController.value} \n ');
                            log(' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                            final totalHari = DateTime.parse(
                                    tglAkhirTextController.value)
                                .difference(
                                    DateTime.parse(tglAwalTextController.value))
                                .inDays;
                            log(' Date Diff: $totalHari');

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await ref
                                  .read(createIzinNotifierProvider.notifier)
                                  .updateIzin(
                                      idIzin: item.idIzin!,
                                      idUser: item.idUser!,
                                      uUser: user.nama!,
                                      totalHari: totalHari,
                                      ket: keteranganTextController.text,
                                      idMstIzin: jenisIzinTextController.value!,
                                      tglAwal: tglAwalTextController.value,
                                      tglAkhir: tglAkhirTextController.value,
                                      onError: (msg) => HapticFeedback.vibrate()
                                          .then((_) => showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (_) => VSimpleDialog(
                                                    color: Palette.red,
                                                    asset: Assets.iconCrossed,
                                                    label: 'Oops',
                                                    labelDescription: msg,
                                                  ))));
                            }
                          })
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}