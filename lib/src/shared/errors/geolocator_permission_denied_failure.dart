import 'errors.dart';

class GeolocatorPermissionDeniedFailure extends GeolocatorFailure {
  GeolocatorPermissionDeniedFailure({
    super.title = 'Ops, algo deu errado',
    super.message =
        'Você precisa habilitar a permissão de localização nas configurações do seu dispositivo.',
    super.error,
  });
}
