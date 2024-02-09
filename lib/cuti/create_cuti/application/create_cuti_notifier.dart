import 'package:face_net_authentication/mst_karyawan_cuti/application/mst_karyawan_cuti_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../sakit/create_sakit/application/create_sakit.dart';

import '../../../sakit/create_sakit/application/create_sakit_notifier.dart';
import '../../../shared/providers.dart';
import '../../../user/application/user_model.dart';
import '../infrastructure/create_cuti_remote_service.dart';
import '../infrastructure/create_cuti_repository.dart';
import 'alasan_cuti.dart';
import 'jenis_cuti.dart';

part 'create_cuti_notifier.g.dart';

@Riverpod(keepAlive: true)
CreateCutiRemoteService createCutiRemoteService(
    CreateCutiRemoteServiceRef ref) {
  return CreateCutiRemoteService(
      ref.watch(dioProvider), ref.watch(dioRequestProvider));
}

@Riverpod(keepAlive: true)
CreateCutiRepository createCutiRepository(CreateCutiRepositoryRef ref) {
  return CreateCutiRepository(
    ref.watch(createCutiRemoteServiceProvider),
  );
}

@riverpod
class JenisCutiNotifier extends _$JenisCutiNotifier {
  @override
  FutureOr<List<JenisCuti>> build() async {
    return ref.read(createCutiRepositoryProvider).getJenisCuti();
  }
}

@riverpod
class AlasanCutiNotifier extends _$AlasanCutiNotifier {
  @override
  FutureOr<List<AlasanCuti>> build() async {
    return ref.read(createCutiRepositoryProvider).getAlasanEmergency();
  }
}

@riverpod
class CreateCutiNotifier extends _$CreateCutiNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> updateCuti(
      {
      //
      required int idCuti,
      required String tglAwal,
      required String tglAkhir,
      required String keterangan,
      required String jenisCuti,
      required String alasanCuti,
      required Future<void> Function(String errMessage) onError
      //
      }) async {
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;

    try {
      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(user, tglAwal, tglAkhir);
      final MstKaryawanCuti mstCuti = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(user.idUser!);

      await _finalizeUpdate(
        idCuti: idCuti,
        user: user,
        create: create,
        mstCuti: mstCuti,
        tglAwal: tglAwal,
        tglAkhir: tglAkhir,
        jenisCuti: jenisCuti,
        alasanCuti: alasanCuti,
        keterangan: keterangan,
      );
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  Future<void> submitCuti(
      {
      //
      required String tglAwal,
      required String tglAkhir,
      required String keterangan,
      required String jenisCuti,
      required String alasanCuti,
      required Future<void> Function(String errMessage) onError}) async {
    //
    state = const AsyncLoading();

    final user = ref.read(userNotifierProvider).user;

    try {
      final CreateSakit create = await ref
          .read(createSakitNotifierProvider.notifier)
          .getCreateSakit(user, tglAwal, tglAkhir);
      final MstKaryawanCuti mstCuti = await ref
          .read(mstKaryawanCutiNotifierProvider.notifier)
          .getSaldoMasterCutiById(user.idUser!);

      await _finalizeSubmit(
        user: user,
        mstCuti: mstCuti,
        create: create,
        tglAwal: tglAwal,
        tglAkhir: tglAkhir,
        jenisCuti: jenisCuti,
        alasanCuti: alasanCuti,
        keterangan: keterangan,
      );
    } catch (e) {
      state = const AsyncValue.data('');
      await onError('Error $e');
    }
  }

  /* 

    to submitCuti, initialize the following variables

      dateMasuk: dateMasuk,
      tahunCuti: tahunCuti,
      totalHariCutiBaru: totalHariCutiBaru,
      totalHariCutiTidakBaru: totalHariCutiTidakBaru,

    for table insertion
  */
  Future<void> _finalizeSubmit({
    required String tglAwal,
    required String tglAkhir,
    required String jenisCuti,
    required String alasanCuti,
    required String keterangan,
    required CreateSakit create,
    required MstKaryawanCuti mstCuti,
    required UserModelWithPassword user,
  }) async {
    final DateTime tglAwalInDateTime = DateTime.parse(tglAwal);
    final DateTime tglAkhirInDateTime = DateTime.parse(tglAkhir);

    // 1. Calc jumlah harito substract sundays and saturdays
    final int jumlahhari =
        _getJumlahHari(create, tglAwalInDateTime, tglAkhirInDateTime);

    // Begin VALIDATE DATA MASTER CUTI
    await _validateMasterCuti(create: create, jenisCuti: jenisCuti);

    final isSpvOrHrd = ref.read(userNotifierProvider).user.isSpvOrHrd!;

    if (!isSpvOrHrd) {
      await _notHrCondition(
          jenisCuti: jenisCuti,
          jumlahhari: jumlahhari,
          tglAwalInDateTime: tglAwalInDateTime,
          tglAkhirInDateTime: tglAkhirInDateTime);
    }

    if ((jenisCuti == 'CE' && alasanCuti.isEmpty) ||
        (jenisCuti == 'CE' && alasanCuti == 'A0')) {
      throw AssertionError('Cuti Emergency wajib memilih alasan!');
    }
    // End VALIDATE DATA MASTER CUTI

    // totalHariCutiBaru
    final int totalHariCutiBaru = mstCuti.cutiBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    // totalHariCutiTidakBaru
    final int totalHariCutiTidakBaru = mstCuti.cutiTidakBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    final DateTime openDateJan = DateTime(mstCuti.openDate!.year, 1, 1);

    final DateTime openDateMax = DateTime(mstCuti.openDate!.year + 1, 6, 30);

    final DateTime createMasukInDateTime = DateTime.parse(create.masuk!);

    /* 
      final DateTime? dateMasuk;
      dateMasuk untuk menghitung periode kapan cuti digunakan
    */
    final DateTime? dateMasuk =
        _returnDateMasuk(createMasukInDateTime: createMasukInDateTime);
    final Duration tglAwaltglMasukDiff =
        tglAwalInDateTime.difference(dateMasuk!);

    /* 
      final String? tahunCuti;
      tahunCuti untuk menghitung tahun kapan cuti digunakan
      dalam periode
    */
    final String? tahunCuti = _returnTahunCuti(
      mstCuti: mstCuti,
      tglAwaltglMasukDiff: tglAwaltglMasukDiff.inDays,
    );

    // 3. Menghitung Saldo Cuti
    //    dan menghasilkan error jika habis
    //

    // required String jenisCuti,
    // required int totalHariCutiBaru,
    // required int totalHariCutiTidakBaru,
    // required Duration tglAwaltglMasukDiff,
    // required DateTime openDateJan,
    // required DateTime tglAkhirInDateTime,
    // required DateTime createMasukInDateTime,
    // required CreateSakit create,
    // required MstKaryawanCuti mstCuti,

    await _validateSaldoCuti(
      jenisCuti: jenisCuti,
      totalHariCutiBaru: totalHariCutiBaru,
      totalHariCutiTidakBaru: totalHariCutiTidakBaru,
      tglAwaltglMasukDiff: tglAwaltglMasukDiff,
      openDateJan: openDateJan,
      tglAkhirInDateTime: tglAkhirInDateTime,
      createMasukInDateTime: createMasukInDateTime,
      create: create,
      mstCuti: mstCuti,
    );

    // final String messageContent =
    //     " ( Testing Apps ) Terdapat Waiting Approve Pengajuan Izin Sakit Baru Telah Diinput Oleh : ${user.nama} ";
    // await _sendWaToHead(idUser: user.idUser!, messageContent: messageContent);

    final syarat2 = (mstCuti.cutiBaru! > 0 &&
        !dateMasuk.difference(tglAwalInDateTime).isNegative);

    // get sisaCuti from
    // dateMasuk
    // in _finalizeSubmit() function
    final int? sisaCuti = mstCuti.cutiBaru == 0 || syarat2
        ? mstCuti.cutiBaru
        : mstCuti.cutiTidakBaru;

    state = await AsyncValue.guard(
        () => ref.read(createCutiRepositoryProvider).submitCuti(
              jumlahHari: jumlahhari,
              hitungLibur: create.hitungLibur!,
              tahunCuti: tahunCuti!,
              sisaCuti: sisaCuti!,
              // raw variables
              ket: keterangan,
              alasan: alasanCuti,
              jenisCuti: jenisCuti,
              idUser: user.idUser!,
              // date time
              tglAwalInDateTime: tglAwalInDateTime,
              tglAkhirInDateTime: tglAkhirInDateTime,
            ));
  }

  Future<void> _finalizeUpdate({
    required int idCuti,
    required String tglAwal,
    required String tglAkhir,
    required String jenisCuti,
    required String alasanCuti,
    required String keterangan,
    required CreateSakit create,
    required MstKaryawanCuti mstCuti,
    required UserModelWithPassword user,
  }) async {
    final DateTime tglAwalInDateTime = DateTime.parse(tglAwal);
    final DateTime tglAkhirInDateTime = DateTime.parse(tglAkhir);

    // 1. Calc jumlah harito substract sundays and saturdays
    final int jumlahhari =
        _getJumlahHari(create, tglAwalInDateTime, tglAkhirInDateTime);

    // Begin VALIDATE DATA MASTER CUTI
    await _validateMasterCuti(create: create, jenisCuti: jenisCuti);

    final isSpvOrHrd = ref.read(userNotifierProvider).user.isSpvOrHrd!;

    if (!isSpvOrHrd) {
      await _notHrCondition(
          jenisCuti: jenisCuti,
          jumlahhari: jumlahhari,
          tglAwalInDateTime: tglAwalInDateTime,
          tglAkhirInDateTime: tglAkhirInDateTime);
    }

    if ((jenisCuti == 'CE' && alasanCuti.isEmpty) ||
        (jenisCuti == 'CE' && alasanCuti == 'A0')) {
      throw AssertionError('Cuti Emergency wajib memilih alasan!');
    }
    // End VALIDATE DATA MASTER CUTI

    // totalHariCutiBaru
    final int totalHariCutiBaru = mstCuti.cutiBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    // totalHariCutiTidakBaru
    final int totalHariCutiTidakBaru = mstCuti.cutiTidakBaru! -
        (tglAkhirInDateTime.difference(tglAwalInDateTime).inDays - jumlahhari) -
        create.hitungLibur!;

    final DateTime openDateJan = DateTime(mstCuti.openDate!.year, 1, 1);

    final DateTime openDateMax = DateTime(mstCuti.openDate!.year + 1, 6, 30);

    final DateTime createMasukInDateTime = DateTime.parse(create.masuk!);

    /* 
      final DateTime? dateMasuk;
      dateMasuk untuk menghitung periode kapan cuti digunakan
    */
    final DateTime? dateMasuk =
        _returnDateMasuk(createMasukInDateTime: createMasukInDateTime);
    final Duration tglAwaltglMasukDiff =
        tglAwalInDateTime.difference(dateMasuk!);

    /* 
      final String? tahunCuti;
      tahunCuti untuk menghitung tahun kapan cuti digunakan
      dalam periode
    */
    final String? tahunCuti = _returnTahunCuti(
      mstCuti: mstCuti,
      tglAwaltglMasukDiff: tglAwaltglMasukDiff.inDays,
    );

    // 3. Menghitung Saldo Cuti
    //    dan menghasilkan error jika habis
    //

    await _validateSaldoCuti(
      jenisCuti: jenisCuti,
      totalHariCutiBaru: totalHariCutiBaru,
      totalHariCutiTidakBaru: totalHariCutiTidakBaru,
      tglAwaltglMasukDiff: tglAwaltglMasukDiff,
      openDateJan: openDateJan,
      tglAkhirInDateTime: tglAkhirInDateTime,
      createMasukInDateTime: createMasukInDateTime,
      create: create,
      mstCuti: mstCuti,
    );

    // final String messageContent =
    //     " ( Testing Apps ) Terdapat Waiting Approve Pengajuan Izin Sakit Baru Telah Diinput Oleh : ${user.nama} ";
    // await _sendWaToHead(idUser: user.idUser!, messageContent: messageContent);

    final syarat2 = (mstCuti.cutiBaru! > 0 &&
        !dateMasuk.difference(tglAwalInDateTime).isNegative);

    // get sisaCuti from
    // dateMasuk
    // in _finalizeSubmit() function
    final int? sisaCuti = mstCuti.cutiBaru == 0 || syarat2
        ? mstCuti.cutiBaru
        : mstCuti.cutiTidakBaru;

    final nama = ref.read(userNotifierProvider).user.nama!;

    state = await AsyncValue.guard(
        () => ref.read(createCutiRepositoryProvider).updateCuti(
              jumlahHari: jumlahhari,
              hitungLibur: create.hitungLibur!,
              tahunCuti: tahunCuti!,
              sisaCuti: sisaCuti!,
              // raw variables
              ket: keterangan,
              alasan: alasanCuti,
              jenisCuti: jenisCuti,
              nama: nama,
              idCuti: idCuti,
              idUser: user.idUser!,
              // date time
              tglAwalInDateTime: tglAwalInDateTime,
              tglAkhirInDateTime: tglAkhirInDateTime,
            ));
  }

  Future<void> _validateSaldoCuti({
    required String jenisCuti,
    required int totalHariCutiBaru,
    required int totalHariCutiTidakBaru,
    required Duration tglAwaltglMasukDiff,
    required DateTime openDateJan,
    required DateTime tglAkhirInDateTime,
    required DateTime createMasukInDateTime,
    required CreateSakit create,
    required MstKaryawanCuti mstCuti,
  }) async {
    final bool sayaCutiDiTahunMasuk =
        tglAkhirInDateTime.year == createMasukInDateTime.year;
    final bool sayaCutiDiTahunMasukBerikutnya =
        tglAkhirInDateTime.year == createMasukInDateTime.year + 1;

    final bool sayaMasihAdaCutiTidakBaru = mstCuti.cutiTidakBaru! > 0;
    final bool validateTahunCuti =
        (!sayaCutiDiTahunMasuk || !sayaCutiDiTahunMasukBerikutnya);
    final bool jenisCutiEmergencyOrTahunan =
        jenisCuti == 'CE' || jenisCuti == 'CT';
    final bool tglCutiLebihKecilDariOpenDate =
        createMasukInDateTime.difference(openDateJan).isNegative;

    if (sayaMasihAdaCutiTidakBaru &&
        validateTahunCuti &&
        jenisCutiEmergencyOrTahunan &&
        tglCutiLebihKecilDariOpenDate) {
      throw AssertionError(
          "Saldo Cuti ${mstCuti.closeDate!.year} Habis! Belum Masuk Periode Cuti ${mstCuti.tahunCutiTidakBaru} ");
    }

    // 4. Saldo Cuti Awal (Tahun Masuk)
    //
    //    Jika user masuk kerja saat tahun_cuti sama dengan tahun masuk
    //
    //    variables :
    //
    //    final createMasukInDateTime = DateTime.parse(create.masuk!);
    //    final tglAwaltglMasukDiff = tglAwalInDateTime.difference(dateMasuk);
    //
    /*     
        totalHariCutiBaru =  createSakitCuti!.cutiBaru! -
                             tglAkhirInDateTime.difference(tglAwalInDateTime).inDays -
                             jumlahhari -
                             create.hitungLibur!;
    */

    final bool saldoCutiTidakCukup = totalHariCutiBaru < 0;

    if (sayaCutiDiTahunMasuk) {
      if (saldoCutiTidakCukup) {
        throw AssertionError(
            'Sisa Saldo Cuti Tidak Cukup! Saldo Cuti Anda Tersisa ${mstCuti.cutiBaru} untuk periode ${mstCuti.tahunCutiTidakBaru}');
      }
    }

    // untuk mereset cuti baru jika tgl_start melebihi tanggal expired (datemsk)
    if (mstCuti.cutiBaru! > 0 && !tglAwaltglMasukDiff.isNegative) {
      // BELOM UPDATE QUERY

      throw AssertionError(
          "Saldo Periode ${createMasukInDateTime.year} Tersisa ${mstCuti.cutiBaru} Dan Telah Expired! Silahkan Refresh Page dan Input Kembali");
    }

    final bool saldoCutiTidakBaruTidakCukup = totalHariCutiTidakBaru < 0;

    // 'Saldo Cuti Setelah Setahun Masuk (Tahun Masuk + 1)
    if (sayaCutiDiTahunMasukBerikutnya) {
      if (saldoCutiTidakBaruTidakCukup) {
        // BELOM UPDATE QUERY

        throw AssertionError(
            "Sisa Saldo Cuti Tidak Cukup! Saldo Cuti Anda Tersisa ${mstCuti.cutiTidakBaru} Untuk Periode ${mstCuti.tahunCutiTidakBaru}");
      }
    }

    // 5. Saldo Cuti Setelah Dua Tahun Masuk dan Seterusnya (Tahun Masuk + 2)
    //
    //
    //    Jika masa kerja user sudah 2 tahun atau lebih
    //
    //    variables :
    //
    //    final createMasukInDateTime = DateTime.parse(create.masuk!);
    //    final openDateMax = DateTime(mstCuti.openDate!.year + 1, 6, 30);
    //
    /*     
        totalHariCutiTidakBaru =  mstCuti!.cutiTidakBaru! -
                                  tglAkhirInDateTime.difference(tglAwalInDateTime).inDays -
                                  jumlahhari -
                                  create.hitungLibur!;
    */

    if (sayaCutiDiTahunMasuk && sayaCutiDiTahunMasukBerikutnya) {
      if (saldoCutiTidakBaruTidakCukup) {
        // BELOM UPDATE QUERY

        throw AssertionError(
            "Sisa Saldo Cuti Tidak Cukup! Saldo Cuti Anda Tersisa ${mstCuti.cutiTidakBaru} Untuk Periode ${mstCuti.tahunCutiTidakBaru}");
      }
    }
  }

  Future<void> _validateMasterCuti({
    required String jenisCuti,
    required CreateSakit create,
  }) async {
    // 1. CALC TGL MSK
    if (create.masuk == null) {
      throw AssertionError(
          'Tanggal masuk karyawan atau tanggal join kerja masih kosong!');
    }

    //
    // if (create == ) {
    //   throw AssertionError(
    //       "Master Data Cuti Anda Belum Ada! Silahkan Hubungi HR");
    // }

    final isCutiEmergencyOrTahunan = jenisCuti == 'CE' || jenisCuti == 'CT';

    // 2. CALC JUMLAH MASA KERJA, JIKA KURANG DARI 12 BULAN
    if (DateTime.now().difference(DateTime.parse(create.masuk!)).inDays < 365 &&
        isCutiEmergencyOrTahunan) {
      throw AssertionError(
          "Anda Belum Mendapat Hak Cuti, Masa Kerja Belum Setahun!");
    }
  }

  // dateMasuk, tahunCuti, tglAwaltglMasukDiff

  Future<void> _notHrCondition({
    required int jumlahhari,
    required String jenisCuti,
    required DateTime tglAwalInDateTime,
    required DateTime tglAkhirInDateTime,
  }) async {
    if (!tglAwalInDateTime.difference(tglAkhirInDateTime).isNegative) {
      throw AssertionError(
          'Tanggal Awal Tidak Boleh Lebih Besar Dari Tanggal Akhir');
    }

    if (DateTime.now().difference(tglAwalInDateTime).inDays - jumlahhari > 5 &&
        jenisCuti == 'CT') {
      throw AssertionError('Tanggal input lewat dari 5 hari');
    }
  }

  int _getJumlahHari(CreateSakit create, DateTime tglAwalInDateTime,
      DateTime tglAkhirInDateTime) {
    if (create.jadwalSabtu!.isNotEmpty && create.bulanan == false) {
      return calcDiffSaturdaySunday(tglAwalInDateTime, tglAkhirInDateTime);
    } else if (create.jadwalSabtu!.isEmpty || create.bulanan == true) {
      return calcDiffSunday(tglAwalInDateTime, tglAkhirInDateTime);
    } else {
      return 0;
    }
  }

  int calcDiffSaturdaySunday(DateTime startDate, DateTime endDate) {
    int nbDays = 0;
    DateTime currentDay = startDate;

    while (currentDay.isBefore(endDate)) {
      currentDay = currentDay.add(Duration(days: 1));

      if (currentDay.weekday == DateTime.saturday &&
          currentDay.weekday == DateTime.sunday) {
        nbDays += 1;
      }
    }

    return nbDays;
  }

  int calcDiffSunday(DateTime startDate, DateTime endDate) {
    int nbDays = 0;
    DateTime currentDay = startDate;

    while (currentDay.isBefore(endDate)) {
      currentDay = currentDay.add(Duration(days: 1));

      if (currentDay.weekday == DateTime.saturday) {
        nbDays += 1;
      }
    }

    return nbDays;
  }

  DateTime _returnDateMasuk({required DateTime createMasukInDateTime}) {
    // 1. Mendapatkan date Masuk untuk dikirim
    //    ke proses insert
    //

    //
    //    jika masuk saat bulan februari
    if (createMasukInDateTime.month == 2) {
      return DateTime(
          createMasukInDateTime.year + 2, createMasukInDateTime.month - 1, 28);
    }

    //
    //    jika masuk saat bulan januari
    else if (createMasukInDateTime.month == 1) {
      return DateTime(createMasukInDateTime.year + 1, 12, 31);
    } else {
      return DateTime(
          createMasukInDateTime.year + 2, createMasukInDateTime.month - 1, 30);
    }
  }

  String _returnTahunCuti(
      {required MstKaryawanCuti mstCuti, required int tglAwaltglMasukDiff}) {
    // 2. Mendapatkan tahun Cuti untuk dikirim
    //    ke proses insert
    //
    if (mstCuti.cutiBaru == 0 ||
        mstCuti.cutiBaru! > 0 && !tglAwaltglMasukDiff.isNegative) {
      return mstCuti.tahunCutiTidakBaru!;
    } else {
      return mstCuti.tahunCutiBaru!;
    }
  }
}
