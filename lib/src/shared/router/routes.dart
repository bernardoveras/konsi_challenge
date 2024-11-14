import '../../modules/addresses/domain/dtos/address_dto.dart';
import 'router.dart';

abstract class Routes {
  static const String root = '/maps';
  static const String addresses = '/addresses';
  static const String createAddress = '/addresses/new';
  static String editAddress({
    AddressDto? address,
  }) {
    return RoutePathBuilder.build(
      '$addresses/edit',
      queryParameters: address?.toMap(),
    );
  }
}
