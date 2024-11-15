import '../models/http_response_model.dart';

abstract interface class IHttpClient {
  Future<HttpResponseModel> get({
    required String path,
    Map<String, dynamic>? headers,
    Map<String, String>? queryParameters,
  });
}
