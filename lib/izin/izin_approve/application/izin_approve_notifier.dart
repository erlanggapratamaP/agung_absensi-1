import 'package:face_net_authentication/izin/izin_approve/infrastructure/izin_approve_repository.dart';
import 'package:face_net_authentication/izin/izin_list/application/izin_list_notifier.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../send_wa/application/phone_num.dart';
import '../../../shared/providers.dart';

import '../../izin_list/application/izin_list.dart';

import '../infrastructure/izin_approve_remote_service.dart.dart';

part 'izin_approve_notifier.g.dart';

@Riverpod(keepAlive: true)
IzinApproveRemoteService izinApproveRemoteService(
    IzinApproveRemoteServiceRef ref) {
  return IzinApproveRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
IzinApproveRepository izinApproveRepository(IzinApproveRepositoryRef ref) {
  return IzinApproveRepository(
    ref.watch(izinApproveRemoteServiceProvider),
  );
}

@riverpod
class IzinApproveController extends _$IzinApproveController {
  @override
  FutureOr<void> build() {}

  Future<void> _sendWa(
      {required IzinList itemIzin, required String messageContent}) async {
    final PhoneNum registeredWa = PhoneNum(
      noTelp1: itemIzin.noTelp1,
      noTelp2: itemIzin.noTelp2,
    );

    if (registeredWa.noTelp1!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp1!),
          idUser: itemIzin.idUser!,
          idDept: itemIzin.idDept!,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else if (registeredWa.noTelp2!.isNotEmpty) {
      await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
          phone: int.parse(registeredWa.noTelp2!),
          idUser: itemIzin.idUser!,
          idDept: itemIzin.idDept!,
          notifTitle: 'Notifikasi HRMS',
          notifContent: '$messageContent');
    } else {
      throw AssertionError(
          'User yang dituju tidak memiliki nomor telfon. Silahkan hubungi HR ');
    }
  }

  Future<void> approveSpv({
    required String nama,
    required IzinList itemIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(izinApproveRepositoryProvider)
          .approveSpv(nama: nama, idIzin: itemIzin.idIzin!);
      final String messageContent =
          'Izin Anda Sudah Diapprove Oleh Atasan $nama';
      await _sendWa(itemIzin: itemIzin, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveSpv({
    required String nama,
    required IzinList itemIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(izinApproveRepositoryProvider)
          .unApproveSpv(nama: nama, idIzin: itemIzin.idIzin!);

      state = AsyncData<void>('Sukses Unapprove Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> approveHrd({
    required String namaHrd,
    required String note,
    required IzinList itemIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(izinApproveRepositoryProvider)
          .approveHrd(namaHrd: namaHrd, note: note, idIzin: itemIzin.idIzin!);

      final String messageContent =
          'Izin Anda Sudah Diapprove Oleh HRD $namaHrd';
      await _sendWa(itemIzin: itemIzin, messageContent: messageContent);

      state = AsyncData<void>('Sukses Melakukan Approve Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> unApproveHrd({
    required String namaHrd,
    required String note,
    required int idIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(izinApproveRepositoryProvider)
          .unApproveHrd(nama: namaHrd, note: note, idIzin: idIzin);

      state = AsyncData<void>('Sukses Melakukan Unapprove Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> batal({
    required String nama,
    required IzinList itemIzin,
  }) async {
    state = const AsyncLoading();

    try {
      await ref.read(izinApproveRepositoryProvider).batal(
            nama: nama,
            idIzin: itemIzin.idIzin!,
          );
      final String messageContent = 'Izin Anda Telah Di Batalkan Oleh : $nama';

      await _sendWa(itemIzin: itemIzin, messageContent: messageContent);
      state = AsyncData<void>('Sukses Membatalkan Form Izin');
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  bool canSpvApprove(IzinList item) {
    if (item.hrdSta == true) {
      return false;
    }

    if (ref.read(izinListControllerProvider.notifier).isHrdOrSpv() == false) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
      return false;
    }

    // if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
    //     3) {
    //   return false;
    // }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      return true;
    }

    return false;
  }

  bool canHrdApprove(IzinList item) {
    if (item.spvSta == false) {
      return false;
    }

    if (item.hrdSta == true) {
      return false;
    }

    if (ref.read(izinListControllerProvider.notifier).isHrdOrSpv() == false) {
      return false;
    }

    if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
      return false;
    }

    // if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
    //     1) {
    //   return false;
    // }

    if (ref.read(userNotifierProvider).user.fullAkses == true) {
      return true;
    }

    return false;
  }
}