import 'package:flutter_test/flutter_test.dart';
import 'package:konsi_challenge/src/shared/utils/query_parameters_to_string.dart';

void main() {
  test('Transform query parameters to query string', () {
    final queryParameters = {
      'id': 1,
      'name': 'test',
      'status': 'active',
      'description': null,
      'url': '',
      'type': ['a', 'b', 'c'],
      'map': {'test': 1},
    };

    final result = queryParametersToString(queryParameters);

    expect(
      result,
      'id=1&name=test&status=active&type=a&type=b&type=c',
    );
  });
}
