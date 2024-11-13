import '../extensions/extensions.dart';
import 'router.dart';

abstract class Routes {
  static const String root = '/maps';
  static const String addresses = '/addresses';
  static const String createAddress = '/addresses/new';
  static String editAddress({
    String cep = ':cep',
    String? address,
  }) {
    if (cep != ':cep') cep = cep.removeSpecialCharacters()!;

    return RoutePathBuilder.build(
      '$addresses/$cep',
      queryParameters: address.isNotBlank
          ? {
              'address': address,
            }
          : null,
    );
  }
}
