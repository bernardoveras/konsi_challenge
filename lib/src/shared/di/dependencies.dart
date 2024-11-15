import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/addresses/data/services/address_book_local_storage_service_impl.dart';
import '../../modules/addresses/data/services/address_geocoding_service_impl.dart';
import '../../modules/addresses/domain/services/i_address_book_service.dart';
import '../../modules/addresses/domain/services/i_address_service.dart';
import '../services/cep/data/services/cep_locator_http_service_impl.dart';
import '../services/cep/domain/services/i_cep_locator_service.dart';
import '../services/geolocator/data/services/geolocator_service_impl.dart';
import '../services/geolocator/domain/services/i_geolocator_service.dart';
import '../services/geolocator/ui/stores/geolocator_store.dart';
import '../services/http_client/data/adapters/dio_http_client_adapter.dart';
import '../services/http_client/domain/services/i_http_client.dart';
import '../services/local_storage/data/adapters/adapters.dart';
import '../services/local_storage/domain/services/local_storage_service.dart';

abstract class Dependencies {
  static final _getIt = GetIt.instance;

  static T resolve<T extends Object>({String? instanceName}) =>
      _getIt.get<T>(instanceName: instanceName);

  static Future<T> resolveAsync<T extends Object>({String? instanceName}) =>
      _getIt.getAsync<T>(instanceName: instanceName);

  static Future<void> allReady() => _getIt.allReady();

  static void _registerGeolocator() {
    _getIt.registerSingleton<IGeolocatorService>(
      GeolocatorServiceImpl(),
    );
    _getIt.registerSingleton<GeolocatorStore>(
      GeolocatorStore(
        geolocatorService: resolve(),
      ),
    );
  }

  static void _registerLocalStorage() {
    _getIt.registerSingletonAsync<ILocalStorageService>(
      () async => SharedPreferencesLocalStorageAdapter(
        await SharedPreferences.getInstance(),
      ),
    );
  }

  static void _registerAddressService() {
    _getIt.registerSingleton<IAddressService>(
      AddressGeocodingServiceImpl(),
    );
    _getIt.registerSingletonWithDependencies<IAddressBookService>(
      () => AddressBookLocalStorageServiceImpl(
        localStorageService: Dependencies.resolve(),
      ),
      dependsOn: [
        ILocalStorageService,
      ],
    );
  }

  static void _registerCepLocatorService() {
    // Descomente para utilizar o package "search_cep".
    // _getIt.registerSingleton<ICepLocatorService>(
    //   CepLocatorViaCepServiceImpl(),
    // );
    _getIt.registerSingleton<ICepLocatorService>(
      CepLocatorHttpServiceImpl(
        httpClient: Dependencies.resolve(),
      ),
    );
  }

  static void _registerHttpService() {
    final dio = Dio();

    _getIt.registerSingleton<IHttpClient>(
      DioHttpClientAdapter(
        dio: dio,
      ),
    );
  }

  static void registerInstances() {
    _registerHttpService();
    _registerLocalStorage();
    _registerGeolocator();
    _registerCepLocatorService();
    _registerAddressService();
  }
}
