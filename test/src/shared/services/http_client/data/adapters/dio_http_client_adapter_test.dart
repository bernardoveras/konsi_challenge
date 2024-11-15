import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konsi_challenge/src/shared/services/http_client/data/adapters/dio_http_client_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dio_http_client_adapter_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late final DioHttpClientAdapter httpClientAdapter;
  late final MockDio dio;

  const baseUrl = 'https://api.konsichallenge.com/v1';

  setUpAll(() {
    dio = MockDio()
      ..options = BaseOptions(
        baseUrl: baseUrl,
      );

    httpClientAdapter = DioHttpClientAdapter(dio: dio);
  });

  void mockGetRequest({
    required String path,
    required int statusCode,
    String? statusMessage,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    when(
      dio.get(
        path,
        queryParameters: queryParameters ?? anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        data: anyNamed('data'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).thenAnswer((_) async {
      return Response(
        data: data,
        requestOptions: RequestOptions(
          queryParameters: queryParameters,
          headers: headers,
        ),
        statusCode: statusCode,
        statusMessage: statusMessage,
      );
    });
  }

  test('(Success) GET | With data', () async {
    final queryParameters = {'key': 'random_value'};
    final headers = {'key': 'random_value'};

    final expectedData = <String, dynamic>{
      'value': 'success',
      'value2': 100.0,
    };

    mockGetRequest(
      path: 'random',
      statusCode: 200,
      data: expectedData,
      headers: headers,
      queryParameters: queryParameters,
      statusMessage: null,
    );

    final response = await httpClientAdapter.get(
      path: 'random',
      headers: headers,
      queryParameters: queryParameters,
    );

    expect(response.data, expectedData);
    expect(response.statusCode, 200);
    expect(response.statusMessage, null);
    expect(response.isSuccess, true);
    expect(response.exception, null);

    verify(
      dio.get(
        'random',
        queryParameters: queryParameters,
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        data: anyNamed('data'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).called(1);
  });

  test('(Success) GET | Without data', () async {
    final queryParameters = {'key': 'random_value'};
    final headers = {'key': 'random_value'};

    mockGetRequest(
      path: 'random',
      statusCode: 200,
      data: null,
      headers: headers,
      queryParameters: queryParameters,
      statusMessage: null,
    );

    final response = await httpClientAdapter.get(
      path: 'random',
      headers: headers,
      queryParameters: queryParameters,
    );

    expect(response.data, null);
    expect(response.statusCode, 200);
    expect(response.statusMessage, null);
    expect(response.isSuccess, true);
    expect(response.exception, null);

    verify(
      dio.get(
        'random',
        queryParameters: queryParameters,
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        data: anyNamed('data'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).called(1);
  });

  test('(Fail) GET | With data', () async {
    final queryParameters = {'key': 'random_value'};
    final headers = {'key': 'random_value'};

    final expectedData = <String, dynamic>{
      'value': 'failed',
      'value2': 100.0,
    };

    mockGetRequest(
      path: 'random',
      statusCode: 400,
      data: expectedData,
      headers: headers,
      queryParameters: queryParameters,
      statusMessage: 'Failed',
    );

    final response = await httpClientAdapter.get(
      path: 'random',
      headers: headers,
      queryParameters: queryParameters,
    );

    expect(response.data, expectedData);
    expect(response.statusCode, 400);
    expect(response.statusMessage, 'Failed');
    expect(response.isSuccess, false);
    expect(response.exception, null);

    verify(
      dio.get(
        'random',
        queryParameters: queryParameters,
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        data: anyNamed('data'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).called(1);
  });

  test('(Fail) GET | Without data', () async {
    final queryParameters = {'key': 'random_value'};
    final headers = {'key': 'random_value'};

    mockGetRequest(
      path: 'random',
      statusCode: 400,
      data: null,
      headers: headers,
      queryParameters: queryParameters,
      statusMessage: 'Failed',
    );

    final response = await httpClientAdapter.get(
      path: 'random',
      headers: headers,
      queryParameters: queryParameters,
    );

    expect(response.data, null);
    expect(response.statusCode, 400);
    expect(response.statusMessage, 'Failed');
    expect(response.isSuccess, false);
    expect(response.exception, null);

    verify(
      dio.get(
        'random',
        queryParameters: queryParameters,
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        data: anyNamed('data'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      ),
    ).called(1);
  });
}
