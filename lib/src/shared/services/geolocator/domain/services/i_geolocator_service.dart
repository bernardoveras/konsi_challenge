import '../../../../dtos/lat_lng_dto.dart';
import '../enums/location_permission_status.dart';

abstract interface class IGeolocatorService {
  Future<LatLngDto> getCurrentLocation();
  Future<LocationPermissionStatus> checkPermission();
  Future<LocationPermissionStatus> requestPermission();
  Future<bool> isLocationServiceEnabled();
}
