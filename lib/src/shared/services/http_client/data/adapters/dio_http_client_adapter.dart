import 'dart:io';

import 'package:dio/dio.dart';

import '../../domain/models/http_response_model.dart';
import '../../domain/services/i_http_client.dart';

class DioHttpClientAdapter implements IHttpClient {
  final Dio dio;

  DioHttpClientAdapter({
    required this.dio,
  });

  @override
  Future<HttpResponseModel> get({
    required String path,
    Map<String, dynamic>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: headers == null
            ? null
            : Options(
                headers: headers,
              ),
      );

      return HttpResponseModel(
        data: response.data,
        statusCode: response.statusCode ?? HttpStatus.internalServerError,
        statusMessage: response.statusMessage,
      );
    } on DioException catch (e) {
      return HttpResponseModel(
        data: e.response?.data,
        statusCode: e.response?.statusCode ?? HttpStatus.internalServerError,
        statusMessage: e.message,
        exception: e,
      );
    } catch (e) {
      return HttpResponseModel(
        statusCode: HttpStatus.badRequest,
        statusMessage:
            'Não foi possível realizar a operação.\n\n${e.toString()}',
        exception: e,
      );
    }
  }
}
