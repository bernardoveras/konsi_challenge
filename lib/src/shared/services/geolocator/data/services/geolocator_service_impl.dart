import 'package:geolocator/geolocator.dart';

import '../../../../dtos/lat_lng_dto.dart';
import '../../domain/enums/location_permission_status.dart';
import '../../domain/services/i_geolocator_service.dart';

class GeolocatorServiceImpl implements IGeolocatorService {
  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<LatLngDto> getCurrentLocation() async {
    final location = await Geolocator.getCurrentPosition();

    return LatLngDto(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  @override
  Future<LocationPermissionStatus> checkPermission() async {
    final permission = await Geolocator.checkPermission();

    return _parseLocationPermission(permission);
  }

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    final permission = await Geolocator.requestPermission();

    return _parseLocationPermission(permission);
  }

  LocationPermissionStatus _parseLocationPermission(
      LocationPermission permission) {
    return switch (permission) {
      LocationPermission.denied => LocationPermissionStatus.denied,
      LocationPermission.deniedForever =>
        LocationPermissionStatus.deniedForever,
      LocationPermission.whileInUse => LocationPermissionStatus.whileInUse,
      LocationPermission.always => LocationPermissionStatus.always,
      LocationPermission.unableToDetermine =>
        LocationPermissionStatus.unableToDetermine,
    };
  }
}
