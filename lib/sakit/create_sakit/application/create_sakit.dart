import 'package:freezed_annotation/freezed_annotation.dart';

import 'create_sakit_cuti.dart';

part 'create_sakit.freezed.dart';
part 'create_sakit.g.dart';

@freezed
class CreateSakit with _$CreateSakit {
  factory CreateSakit(
      {@JsonKey(name: 'jdw_sabtu') String? jadwalSabtu,
      @JsonKey(name: 'hitunglibur') int? hitungLibur,
      @Default(false) bool bulanan,
      @JsonKey(name: 'Masuk') String? masuk,
      CreateSakitCuti? createSakitCuti}) = _CreateSakit;

  factory CreateSakit.fromJson(Map<String, dynamic> json) =>
      _$CreateSakitFromJson(json);
}