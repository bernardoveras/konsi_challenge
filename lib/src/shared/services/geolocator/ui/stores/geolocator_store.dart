import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../dtos/lat_lng_dto.dart';
import '../../../../errors/errors.dart';
import '../../domain/enums/location_permission_status.dart';
import '../../domain/services/i_geolocator_service.dart';

class GeolocatorStore extends ChangeNotifier {
  final IGeolocatorService geolocatorService;

  GeolocatorStore({
    required this.geolocatorService,
  });

  LatLngDto? currentLocation;

  void changeCurrentLocation(LatLngDto? value) {
    currentLocation = value;
    notifyListeners();
  }

  bool searchingCurrentLocation = false;

  void changeSearchingCurrentLocation(bool value) {
    searchingCurrentLocation = value;
    notifyListeners();
  }

  bool hasPermission(LocationPermissionStatus permission) {
    if (permission == LocationPermissionStatus.always ||
        permission == LocationPermissionStatus.whileInUse) return true;

    return false;
  }

  AsyncResult<LatLngDto, GenericFailure> searchCurrentLocation() async {
    try {
      changeSearchingCurrentLocation(true);

      var permission = await geolocatorService.checkPermission();

      if (!hasPermission(permission)) {
        if (permission == LocationPermissionStatus.deniedForever) {
          return Failure(GeolocatorPermissionDeniedFailure());
        }

        permission = await geolocatorService.requestPermission();

        if (!hasPermission(permission)) {
          return Failure(GeolocatorPermissionDeniedFailure());
        }
      }

      await Future.delayed(const Duration(seconds: 2));

      final currentLocation = await geolocatorService.getCurrentLocation();

      changeCurrentLocation(currentLocation);

      return Success(currentLocation);
    } on GenericFailure catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        GeolocatorFailure(
          error: e,
        ),
      );
    } finally {
      changeSearchingCurrentLocation(false);
    }
  }
}
