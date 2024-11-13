import 'package:get_it/get_it.dart';

import '../../modules/addresses/data/services/address_geocoding_service_impl.dart';
import '../../modules/addresses/domain/services/i_address_service.dart';
import '../services/geolocator/data/services/geolocator_service_impl.dart';
import '../services/geolocator/domain/services/i_geolocator_service.dart';

abstract class Dependencies {
  static final _getIt = GetIt.instance;

  static T resolve<T extends Object>({String? instanceName}) =>
      _getIt.get<T>(instanceName: instanceName);

  static Future<T> resolveAsync<T extends Object>({String? instanceName}) =>
      _getIt.getAsync<T>(instanceName: instanceName);

  static Future<void> allReady() => _getIt.allReady();

  static void _registerGeolocatorService() {
    _getIt.registerSingleton<IGeolocatorService>(
      GeolocatorServiceImpl(),
    );
  }

  static void _registerAddressService() {
    _getIt.registerSingleton<IAddressService>(
      AddressGeocodingServiceImpl(),
    );
  }

  static void registerInstances() {
    _registerGeolocatorService();
    _registerAddressService();
  }
}
