import 'package:result_dart/result_dart.dart';
import 'package:search_cep/search_cep.dart';

import '../../../../errors/errors.dart';
import '../../../../extensions/extensions.dart';
import '../../domain/dto/cep_locator_dto.dart';
import '../../domain/services/i_cep_locator_service.dart';

class CepLocatorViaCepServiceImpl implements ICepLocatorService {
  final _viaCep = ViaCepSearchCep();

  @override
  AsyncResult<CepLocatorDto, GenericFailure> search(String cep) async {
    try {
      final result = await _viaCep.searchInfoByCep(
        cep: cep.removeSpecialCharacters()!,
      );

      return result.fold(
        (failure) {
          return Failure(
            UnknownFailure(
              error: failure,
              message: failure.errorMessage,
            ),
          );
        },
        (address) {
          return Success(
            CepLocatorDto(
              cep: address.cep,
              street: address.logradouro,
              neighborhood: address.bairro,
              city: address.localidade,
              state: address.uf,
            ),
          );
        },
      );
    } catch (e) {
      return Failure(
        UnknownFailure(
          error: e,
          message: 'Não foi possível obter o endereço através do CEP.',
        ),
      );
    }
  }
}
