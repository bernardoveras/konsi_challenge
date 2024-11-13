import '../utils/utils.dart';

abstract class RoutePathBuilder {
  static String build(
    String route, {
    Map<String, dynamic>? queryParameters,
  }) {
    var routeBuilt = route;

    if (queryParameters?.isNotEmpty == true) {
      routeBuilt += '?${queryParametersToString(queryParameters!)}';
    }

    return routeBuilt;
  }
}
