import 'package:get_it/get_it.dart';

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

  static void registerInstances() {
    _registerGeolocatorService();
  }
}
