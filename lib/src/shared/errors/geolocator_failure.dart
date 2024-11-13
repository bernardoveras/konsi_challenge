import 'errors.dart';

class GeolocatorFailure extends GenericFailure {
  GeolocatorFailure({
    super.title = 'Ops, algo deu errado',
    super.message = 'No momento, não foi possível obter a sua localização.',
    super.error,
  });
}
