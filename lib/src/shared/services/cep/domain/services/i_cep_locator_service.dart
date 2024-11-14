import 'package:result_dart/result_dart.dart';

import '../../../../errors/errors.dart';
import '../dto/cep_locator_dto.dart';

abstract interface class ICepLocatorService {
  AsyncResult<CepLocatorDto, GenericFailure> search(String cep);
}
