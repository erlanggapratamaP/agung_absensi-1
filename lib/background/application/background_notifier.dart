import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:face_net_authentication/domain/background_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../tester/application/tester_state.dart';
import '../infrastructures/background_repository.dart';
import 'background_state.dart';
import 'saved_location.dart';

class BackgroundNotifier extends StateNotifier<BackgroundState> {
  BackgroundNotifier(this._backgroundRepository)
      : super(BackgroundState.initial());

  final BackgroundRepository _backgroundRepository;

  Future<int> getSavedLocationsLen() =>
      _backgroundRepository.getSavedLocations().then((value) => value.fold(
            (_) => 0,
            (r) => r.length,
          ));

  Future<SavedLocation> getLastSavedLocations() =>
      _backgroundRepository.getSavedLocations().then((value) => value.fold(
            (_) => SavedLocation.initial(),
            (r) => r.isEmpty ? SavedLocation.initial() : r.last,
          ));

  void changeBackgroundItems(List<SavedLocation> backgroundItems) {
    state = state.copyWith(savedBackgroundItems: [...backgroundItems]);
  }

  Future<void> addSavedLocationDev(
      {required SavedLocation savedLocation}) async {
    await _backgroundRepository.addBackgroundLocation(
      savedLocation: savedLocation,
    );

    return;
  }

  reset() {
    state = state.copyWith(failureOrSuccessOptionSave: none());
  }

  Future<void> addSavedLocation({required SavedLocation savedLocation}) async {
    Either<BackgroundFailure, Unit> failureOrSuccess;

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOptionSave: none(),
    );

    failureOrSuccess = await _backgroundRepository.addBackgroundLocation(
      savedLocation: savedLocation,
    );

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOptionSave: optionOf(failureOrSuccess),
    );
  }

  Future<Either<BackgroundFailure, Unit>> executeLocation({
    required BuildContext context,
    required TesterState isTester,
    required Future<void> Function({
      required List<SavedLocation> location,
    }) absen,
  }) async {
    final failureOrSuccess = await _backgroundRepository.getSavedLocations();

    return failureOrSuccess.fold(
      left,
      (list) async {
        try {
          final res = await _backgroundRepository.updateBackgroundLocation(
            locations: list,
          );

          if (res == []) {
            return right(unit);
          }

          if (res.isNotEmpty) {
            await absen(location: res);

            return right(unit);
          }
        } on PlatformException catch (_) {
          return left(BackgroundFailure.unknown(
            '1',
            'Storage penuh saat menyimpan update absen',
          ));
        }

        return left(BackgroundFailure.unknown(
          '1',
          'executeLocation interrupted',
        ));
      },
    );
  }

  Future<void> getSavedLocations() async {
    Either<BackgroundFailure, List<SavedLocation>> failureOrSuccess;

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOption: none(),
    );

    failureOrSuccess = await _backgroundRepository.getSavedLocations();

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }

  modify() {
    state = state.copyWith(failureOrSuccessOptionUpdate: none());
  }

  Future<List<SavedLocation>> _parseLocation(
      {required String? savedLocations}) async {
    if (savedLocations == null) {
      return [];
    }

    final parsedData = jsonDecode(savedLocations);
    return (parsedData as List<dynamic>)
        .map((locationData) => SavedLocation.fromJson(locationData))
        .toList();
  }

  Future<void> clear() async {
    final _sharedPreference = await SharedPreferences.getInstance();
    await _sharedPreference.setString(Constants.keyLocation, '');
  }

  Future<void> removeLocationFromSaved(SavedLocation location) async {
    final _sharedPreference = await SharedPreferences.getInstance();
    final _loc = await _sharedPreference.getString(Constants.keyLocation);

    if (_loc != null) {
      final savedLocations = await _parseLocation(
        savedLocations: _loc,
      );

      if (savedLocations.isEmpty) {
        return;
      }

      if (savedLocations.length == 1) {
        await _backgroundRepository.clear();

        return;
      } else {
        final processLocation =
            savedLocations.where((loc) => loc != location).toSet().toList();

        await _backgroundRepository.save(
          processLocation,
        );

        return;
      }
    }
  }
}
