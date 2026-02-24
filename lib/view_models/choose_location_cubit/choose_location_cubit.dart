import 'package:project1/models/location_item_model.dart';

import 'package:project1/services/auth_serviecies.dart';
import 'package:project1/services/location_servicies.dart';
import 'package:project1/view_models/safe_cubit.dart';

part 'choose_location_state.dart';

class ChooseLocationCubit extends SafeCubit<ChooseLocationState> {
  ChooseLocationCubit() : super(ChooseLocationInitial());

  final locationServices = LocationServicesImpl();
  final authServices = AuthServicesImpl();

  String? selectedLocationId;
  LocationItemModel? selectedLocation;

  Future<void> fetchLocations() async {
    emit(FetchingLocations());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(FetchLocationsFailure('Not logged in'));
        return;
      }
      final locations = await locationServices.fetchLocations(currentUser.uid);

      if (locations.isEmpty) {
        selectedLocationId = null;
        selectedLocation = null;
        emit(FetchedLocations(const []));
        return;
      }

      for (var location in locations) {
        if (location.isChosen) {
          selectedLocationId = location.id;
          selectedLocation = location;
        }
      }
      selectedLocationId ??= locations.first.id;
      selectedLocation ??= locations.first;
      emit(FetchedLocations(locations));
      emit(LocationChosen(selectedLocation!));
    } catch (e) {
      emit(FetchLocationsFailure(e.toString()));
    }
  }

  Future<void> addLocation(String location) async {
    emit(AddingLocation());
    try {
      final trimmed = location.trim();
      final splittedLocations = trimmed.split('-');
      if (splittedLocations.length < 2) {
        emit(LocationAddingFailure('Invalid format. Use: city-country'));
        return;
      }
      final locationItem = LocationItemModel(
        id: DateTime.now().toIso8601String(),
        city: splittedLocations[0].trim(),
        country: splittedLocations[1].trim(),
      );
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(LocationAddingFailure('Not logged in'));
        return;
      }
      final userId = currentUser.uid;
      await locationServices.setLocation(locationItem, userId);
      emit(LocationAdded());
      final locations = await locationServices.fetchLocations(userId);
      emit(FetchedLocations(locations));

      if (locations.isNotEmpty) {
        final chosen = locations.firstWhere(
          (l) => l.isChosen,
          orElse: () => locations.first,
        );
        selectedLocationId = chosen.id;
        selectedLocation = chosen;
        emit(LocationChosen(chosen));
      }
    } catch (e) {
      emit(LocationAddingFailure(e.toString()));
    }
  }

  Future<void> selectLocation(String id) async {
    selectedLocationId = id;
    final currentUser = authServices.currentUser();
    if (currentUser == null) {
      emit(FetchLocationsFailure('Not logged in'));
      return;
    }
    final userId = currentUser.uid;
    final chosenLocation = await locationServices.fetchLocation(userId, id);
    selectedLocation = chosenLocation;
    emit(LocationChosen(chosenLocation));
  }

  Future<void> confirmAddress() async {
    emit(ConfirmAddressLoading());
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(ConfirmAddressFailure('Not logged in'));
        return;
      }

      if (selectedLocation == null) {
        emit(ConfirmAddressFailure('Please select an address'));
        return;
      }

      final userId = currentUser.uid;
      var previousChosenLocations = await locationServices.fetchLocations(
        userId,
        true,
      );
      if (previousChosenLocations.isNotEmpty) {
        var previousLocation = previousChosenLocations.first;
        previousLocation = previousLocation.copyWith(isChosen: false);
        await locationServices.setLocation(previousLocation, userId);
      }
      selectedLocation = selectedLocation!.copyWith(isChosen: true);
      await locationServices.setLocation(selectedLocation!, userId);
      emit(ConfirmAddressLoaded());
    } catch (e) {
      emit(ConfirmAddressFailure(e.toString()));
    }
  }
}
