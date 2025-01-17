import 'package:face_net_authentication/utils/logging.dart';

import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_button.dart';

import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../../utils/dialog_helper.dart';
import '../../../../widgets/alert_helper.dart';
import '../../../../widgets/v_async_widget.dart';
import '../../../../style/style.dart';
import '../../../../utils/string_utils.dart';
import '../../cuti_list/application/cuti_list.dart';
import '../../cuti_list/application/cuti_list_notifier.dart';
import '../application/alasan_cuti.dart';
import '../application/create_cuti_notifier.dart';
import '../application/jenis_cuti.dart';

class EditCutiPage extends HookConsumerWidget {
  const EditCutiPage(this.item);

  final CutiList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final jenisCutiTextController = useState(item.jenisCuti!);
    final alasanCutiTextController = useState(item.alasan!);

    final keteranganCutiTextController =
        useTextEditingController(text: item.ket);

    final tglPlaceholderTextController = useTextEditingController(
      text: _returnPlaceHolderText(
          DateTimeRange(start: item.tglStart!, end: item.tglEnd!)),
    );

    final tglStart = useState(item.tglStart!);
    final tglEnd = useState(item.tglEnd!);

    final createCuti = ref.watch(createCutiNotifierProvider);
    final jenisCuti = ref.watch(jenisCutiNotifierProvider);
    final alasanCuti = ref.watch(alasanCutiNotifierProvider);

    final spvTextController = useTextEditingController(text: item.spvNote);
    final hrdTextController = useTextEditingController(text: item.hrdNote);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    ref.listen<AsyncValue>(createCutiNotifierProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(context,
            color: Palette.primaryColor,
            message: 'Sukses Mengupdate Form Cuti ', onDone: () {
          ref.invalidate(cutiListControllerProvider);
          context.pop();
          return Future.value(true);
        });
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createCuti,
          data: (_) => VScaffoldWidget(
              appbarColor: Palette.primaryLighter,
              scaffoldTitle: 'Edit Form Cuti',
              scaffoldBody: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    children: [
                      // NAMA
                      TextFormField(
                          enabled: false,
                          controller: namaTextController,
                          cursorColor: Palette.primaryColor,
                          keyboardType: TextInputType.name,
                          decoration: Themes.formStyle(
                            'Masukkan nama',
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

                      // Jenis Cuti
                      VAsyncValueWidget<List<JenisCuti>>(
                        value: jenisCuti,
                        data: (list) => DropdownButtonFormField<JenisCuti>(
                          elevation: 0,
                          iconSize: 20,
                          value: list.firstWhere(
                            (element) =>
                                element.inisial ==
                                jenisCutiTextController.value,
                            orElse: () => list.first,
                          ),
                          padding: EdgeInsets.all(0),
                          icon: const Icon(Icons.arrow_downward),
                          decoration: Themes.formStyleBordered(
                            'Jenis Cuti',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          },
                          onChanged: (JenisCuti? value) {
                            if (value != null) {
                              jenisCutiTextController.value = value.inisial;
                            }
                          },
                          items: list.map<DropdownMenuItem<JenisCuti>>(
                              (JenisCuti value) {
                            return DropdownMenuItem<JenisCuti>(
                              value: value,
                              child: Text(
                                value.nama,
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

                      // Alasan Cuti
                      VAsyncValueWidget<List<AlasanCuti>>(
                        value: alasanCuti,
                        data: (list) => DropdownButtonFormField<AlasanCuti>(
                          elevation: 0,
                          iconSize: 20,
                          padding: EdgeInsets.all(0),
                          icon: const Icon(Icons.arrow_downward),
                          value: list.firstWhere(
                            (element) =>
                                element.kode == alasanCutiTextController.value,
                            orElse: () => list.first,
                          ),
                          decoration: Themes.formStyleBordered(
                            'Alasan Cuti',
                          ),
                          onChanged: (AlasanCuti? value) {
                            if (value != null) {
                              alasanCutiTextController.value = value.kode;
                            }
                          },
                          isExpanded: true,
                          items: list.map<DropdownMenuItem<AlasanCuti>>(
                              (AlasanCuti value) {
                            return DropdownMenuItem<AlasanCuti>(
                              value: value,
                              child: Text(
                                value.alasan,
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

                      TextFormField(
                          controller: keteranganCutiTextController,
                          cursorColor: Palette.primaryColor,
                          keyboardType: TextInputType.name,
                          maxLines: 2,
                          decoration: Themes.formStyleBordered(
                            'Masukkan keterangan',
                          ),
                          style: Themes.customColor(
                            14,
                            fontWeight: FontWeight.normal,
                          ),
                          validator: (item) {
                            if (item == null) {
                              return 'Form tidak boleh kosong';
                            } else if (item.length < 10) {
                              return 'Keterangan Harus Diisi Minimal 10 Karakter!';
                            } else if (item.isEmpty) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          }),
                      SizedBox(
                        height: 16,
                      ),

                      // TGL AWAL
                      Ink(
                        child: InkWell(
                          onTap: () async {
                            final _oneYear = Duration(days: 365);

                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now().subtract(_oneYear),
                              lastDate: DateTime.now().add(_oneYear),
                            );

                            if (picked != null) {
                              print(picked);
                              tglStart.value = picked.start;
                              tglEnd.value = picked.end;
                              final _start = DateFormat('dd MMM yyyy')
                                  .format(tglStart.value);
                              final _end = DateFormat('dd MMMM yyyy')
                                  .format(tglEnd.value);
                              tglPlaceholderTextController.text =
                                  '$_start - $_end';
                            }
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                cursorColor: Palette.primaryColor,
                                controller: tglPlaceholderTextController,
                                decoration: Themes.formStyleBordered(
                                  'Tanggal',
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
                      TextFormField(
                        controller: spvTextController,
                        cursorColor: Palette.primaryColor,
                        decoration: Themes.formStyleBordered(
                          'Note SPV',
                        ),
                        style: Themes.customColor(
                          14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: hrdTextController,
                        cursorColor: Palette.primaryColor,
                        decoration: Themes.formStyleBordered(
                          'Note HRD',
                        ),
                        style: Themes.customColor(
                          14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      Container(
                        height: 58,
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VButton(
                            label: 'Update Cuti',
                            onPressed: () async {
                              Log.info(
                                  ' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                              Log.info(
                                  ' Jenis Cuti: ${jenisCutiTextController.value} \n ');
                              Log.info(
                                  ' Alasan: ${alasanCutiTextController.value} \n ');
                              Log.info(
                                  ' Keterangan: ${keteranganCutiTextController.text} \n ');
                              Log.info(
                                  ' Tgl PlaceHolder: ${tglPlaceholderTextController.text} \n ');
                              Log.info(' Tgl Start: ${tglStart.value} \n ');
                              Log.info(' Tgl End: ${tglEnd.value} \n ');

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createCutiNotifierProvider.notifier)
                                    .updateCuti(
                                        idCuti: item.idCuti!,
                                        tglStart: tglStart.value,
                                        tglEnd: tglEnd.value,
                                        spvNote: spvTextController.text,
                                        hrdNote: hrdTextController.text,
                                        keterangan: keteranganCutiTextController
                                            .text
                                            .replaceAll("\n", " "),
                                        jenisCuti:
                                            jenisCutiTextController.value,
                                        alasanCuti:
                                            alasanCutiTextController.value,
                                        onError: (msg) {
                                          return DialogHelper.showCustomDialog(
                                            msg,
                                            context,
                                          ).then((_) => ref
                                              .read(errLogControllerProvider
                                                  .notifier)
                                              .sendLog(errMessage: msg));
                                        });
                              }
                            }),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  String _returnPlaceHolderText(
    DateTimeRange picked,
  ) {
    final startPlaceHolder = StringUtils.formatTanggal(picked.start.toString());
    final endPlaceHolder = StringUtils.formatTanggal(picked.end.toString());

    return 'Dari $startPlaceHolder Sampai $endPlaceHolder';
  }
}
