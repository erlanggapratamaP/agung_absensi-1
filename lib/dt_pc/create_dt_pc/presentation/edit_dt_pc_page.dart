import 'dart:developer';

import 'package:face_net_authentication/dt_pc/dt_pc_list/application/dt_pc_list_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../shared/providers.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../style/style.dart';
import '../../../user_helper/user_helper_notifier.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/v_button.dart';
import '../../../widgets/v_dialogs.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../dt_pc_list/application/dt_pc_list.dart';
import '../application/create_dt_pc_notifier.dart';

String _returnPlaceHolderText(
  String hour,
) {
  final DateTime jam = DateTime.parse(hour);
  final startPlaceHolder = DateFormat(
    'dd MMM yyyy HH:mm',
  ).format(jam);

  return "$startPlaceHolder";
}

class EditDtPcPage extends HookConsumerWidget {
  const EditDtPcPage(this.item);

  final DtPcList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final ptTextController = useTextEditingController(text: nama.user.payroll);

    final keteranganTextController = useTextEditingController(text: item.ket);
    final kategoriTextController = useState(
        item.kategori!.toLowerCase() == 'dt' ? 'Datang Telat' : 'Pulang Cepat');

    final tglPlaceholderTextController =
        useTextEditingController(text: _returnPlaceHolderText(item.jam!));

    final dtTglTextController = useState(item.dtTgl!);
    final jamTextController = useState(item.jam!);

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    ref.listen<AsyncValue>(createDtPcNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form DT/PC',
          onDone: () {
            ref.invalidate(dtPcListControllerProvider);
            context.pop();
            return Future.value(true);
          },
        );
      }
      return state.showAlertDialogOnError(context);
    });

    final createIzin = ref.watch(createDtPcNotifierProvider);
    // final jenisIzin = ref.watch(jenisIzinNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: createIzin,
        data: (_) => VScaffoldWidget(
            appbarColor: Palette.primaryColor,
            scaffoldTitle: 'Create Form DT / PC',
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
                        keyboardType: TextInputType.name,
                        cursorColor: Palette.primaryColor,
                        decoration: Themes.formStyleBordered(
                          'Nama',
                        ),
                        style: Themes.customColor(
                          14,
                          fontWeight: FontWeight.normal,
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
                          fontWeight: FontWeight.normal,
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

                    DropdownButtonFormField<String>(
                      elevation: 0,
                      iconSize: 20,
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: Palette.primaryColor),
                      decoration: Themes.formStyleBordered(
                        'Kategori',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Form tidak boleh kosong';
                        }

                        if (value.isEmpty) {
                          return 'Form tidak boleh kosong';
                        }
                        return null;
                      },
                      value: kategoriTextController.value,
                      onChanged: (String? value) {
                        if (value != null) {
                          kategoriTextController.value = value;
                        }
                      },
                      isExpanded: true,
                      items: ['Datang Telat', 'Pulang Cepat']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: Themes.customColor(
                              14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    // TGL AWAL
                    Ink(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 3)),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) {
                            print(picked);

                            final dtTgl = StringUtils.midnightDate(picked)
                                .replaceAll('.000', '');

                            dtTglTextController.value = dtTgl;

                            final hour = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            final jam = DateTime(picked.year, picked.month,
                                picked.day, hour!.hour, hour.minute);

                            final startPlaceHolder = DateFormat(
                              'dd MMM yyyy HH:mm',
                            ).format(jam);

                            log('jam $jam dtTgl $dtTgl ');

                            jamTextController.value =
                                jam.toString().replaceAll('.000', '');

                            tglPlaceholderTextController.text =
                                "$startPlaceHolder";
                          }
                        },
                        child: IgnorePointer(
                          ignoring: true,
                          child: TextFormField(
                              maxLines: 1,
                              cursorColor: Palette.primaryColor,
                              controller: tglPlaceholderTextController,
                              decoration: Themes.formStyleBordered(
                                'Tanggal & Jam',
                              ),
                              style: Themes.customColor(
                                14,
                                fontWeight: FontWeight.normal,
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
                          'Keterangan',
                        ),
                        style: Themes.customColor(
                          14,
                          fontWeight: FontWeight.normal,
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
                      height: 54,
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VButton(
                          label: kategoriTextController.value == 'Datang Telat'
                              ? 'Apply Datang Telat'
                              : 'Apply Pulang Cepat',
                          onPressed: () async {
                            final kategori =
                                kategoriTextController.value == 'Datang Telat'
                                    ? 'DT'
                                    : 'PC';

                            log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                            log(' Payroll: ${ptTextController.value.text} \n ');
                            log(' Keterangan: ${keteranganTextController.value.text} \n ');
                            log(' Jenis DT/PC: $kategori \n ');

                            final user = ref.read(userNotifierProvider).user;

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await ref
                                  .read(createDtPcNotifierProvider.notifier)
                                  .updateDtPc(
                                    id: item.idDt!,
                                    uUser: user.nama!,
                                    idUser: user.idUser!,
                                    dtTgl: dtTglTextController.value,
                                    jam: jamTextController.value,
                                    kategori: kategori,
                                    ket: keteranganTextController.text,
                                    onError: (msg) => HapticFeedback.vibrate()
                                        .then((_) => showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (_) => VSimpleDialog(
                                                  color: Palette.red,
                                                  asset: Assets.iconCrossed,
                                                  label: 'Oops',
                                                  labelDescription: msg,
                                                ))),
                                  );
                            }
                          }),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}