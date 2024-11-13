String queryParametersToString(Map<String, dynamic> queryParameters) {
  final parameters = <String>[];

  for (var item in queryParameters.entries) {
    final key = item.key;
    final value = item.value;

    if (value == null || value == '') {
      continue;
    }

    if (value is List) {
      for (var element in value) {
        parameters.add('$key=$element');
      }
      continue;
    }

    if (value is Map) {
      continue;
    }

    parameters.add('$key=$value');
  }

  if (parameters.isEmpty) return '';

  return parameters.join('&');
}
