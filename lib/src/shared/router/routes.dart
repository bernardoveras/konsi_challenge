import '../../modules/addresses/ui/parameters/address_view_parameter.dart';
import 'router.dart';

abstract class Routes {
  static const String root = '/maps';
  static const String addresses = '/addresses';
  static String createAddress({
    AddressViewParameter? parameter,
  }) {
    return RoutePathBuilder.build(
      '$addresses/new',
      queryParameters: parameter?.toQueryParameter(),
    );
  }

  static String editAddress({
    AddressViewParameter? parameter,
  }) {
    return RoutePathBuilder.build(
      '$addresses/edit',
      queryParameters: parameter?.toQueryParameter(),
    );
  }
}
