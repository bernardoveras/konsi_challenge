import 'package:result_dart/result_dart.dart';

import '../../../../errors/errors.dart';
import '../../../http_client/domain/errors/http_failure.dart';
import '../../../http_client/domain/services/i_http_client.dart';
import '../../domain/dto/cep_locator_dto.dart';
import '../../domain/services/i_cep_locator_service.dart';

class CepLocatorHttpServiceImpl implements ICepLocatorService {
  final IHttpClient httpClient;

  CepLocatorHttpServiceImpl({
    required this.httpClient,
  });

  @override
  AsyncResult<CepLocatorDto, GenericFailure> search(String cep) async {
    try {
      final url = 'https://viacep.com.br/ws/$cep/json';

      final response = await httpClient.get(path: url);

      if (response.isError) {
        return Failure(
          HttpFailure(
            error: response,
            message: response.statusMessage,
            statusCode: response.statusCode,
          ),
        );
      }

      final data = response.data;

      if (data is! Map) {
        throw FormatException('', data);
      }

      if (data.containsKey('erro')) {
        return Failure(
          HttpFailure(
            message: 'CEP não encontrado.',
            statusCode: 404,
          ),
        );
      }

      return Success(
        CepLocatorDto(
          cep: data['cep'],
          street: data['logradouro'],
          city: data['localidade'],
          neighborhood: data['bairro'],
          state: data['estado'],
          complement: data['complemento'],
        ),
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
