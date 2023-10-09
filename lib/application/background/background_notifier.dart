import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/background/background_item_state.dart';
import 'package:face_net_authentication/application/background/background_state.dart';
import 'package:face_net_authentication/domain/background_failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/background/background_repository.dart';
import '../absen/absen_state.dart';
import 'saved_location.dart';

class BackgroundNotifier extends StateNotifier<BackgroundState> {
  BackgroundNotifier(this._backgroundRepository)
      : super(BackgroundState.initial());

  final BackgroundRepository _backgroundRepository;

  Future<List<SavedLocation>> getSaved() => _backgroundRepository.getSaved();

  // BG ITEM
  List<BackgroundItemState>? getBackgroundItemsAsList(
      List<SavedLocation> items) {
    List<BackgroundItemState> backgroundItem = [];

    log('items ${items.length}');
    log('items $items');

    if (items.isNotEmpty) {
      for (final item in items) {
        backgroundItem.add(BackgroundItemState(
            savedLocations: item, abenStates: AbsenState.empty()));
      }

      return backgroundItem;
    }

    return null;
  }

  void changeBackgroundItems(List<BackgroundItemState> backgroundItems) {
    state = state.copyWith(savedBackgroundItems: [...backgroundItems]);
  }

  // SVD LOC
  Future<void> addSavedLocation({required SavedLocation savedLocation}) async {
    Either<BackgroundFailure, Unit> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOptionSave: none());

    failureOrSuccess = await _backgroundRepository.addBackgroundLocation(
        inputData: savedLocation);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionSave: optionOf(failureOrSuccess));
  }

  Future<void> getSavedLocations() async {
    Either<BackgroundFailure, List<SavedLocation>> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _backgroundRepository.getSavedLocations();

    log('failureOrSuccess $failureOrSuccess');

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  List<SavedLocation>? getSavedLocationsAsList(
      List<BackgroundItemState> items) {
    List<SavedLocation> locations = [];

    log('items ${items.length}');
    log('items $items');

    if (items.isNotEmpty) {
      for (final location in items) {
        log('items ${location.savedLocations}');
        locations.add(location.savedLocations);
      }

      return locations;
    }

    return null;
  }

  Future<List<SavedLocation>> _parseLocation(
      {required String? savedLocations}) async {
    final parsedData = jsonDecode(savedLocations!);

    // log('parsedData $parsedData ');

    if (parsedData is Map<String, dynamic>) {
      final location = SavedLocation.fromJson(parsedData);

      final List<SavedLocation> empty = [];

      empty.add(location);

      return empty;
    } else {
      return (parsedData as List<dynamic>)
          .map((locationData) => SavedLocation.fromJson(locationData))
          .toList();
    }
  }

  Future<void> removeLocationFromSaved(SavedLocation currentLocation,
      {required Function onSaved}) async {
    final _sharedPreference = await SharedPreferences.getInstance();

    if (_sharedPreference.getString("locations") != null) {
      final savedLocations = await _parseLocation(
          savedLocations: _sharedPreference.getString("locations"));

      final processLocation = savedLocations
          .where((location) => location.date != currentLocation.date)
          .toSet()
          .toList();

      await _sharedPreference.setString(
          "locations", jsonEncode(processLocation));

      await onSaved();
    }
  }

  Future<void> processSavedLocations(
      {required List<SavedLocation> locations,
      required void onProcessed(
          {required List<BackgroundItemState> items})}) async {
    final List<BackgroundItemState> list = [];

    for (int i = 0; i < locations.length; i++) {
      list.add(BackgroundItemState(
        savedLocations: locations[i],
        abenStates: AbsenState.empty(),
      ));
    }

    if (list.isNotEmpty) {
      onProcessed(items: list);
    }
  }
}
