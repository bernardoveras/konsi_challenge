import 'package:result_dart/result_dart.dart';

import '../../../../shared/dtos/lat_lng_dto.dart';
import '../../../../shared/errors/errors.dart';
import '../dtos/address_dto.dart';

abstract interface class IAddressService {
  AsyncResult<List<AddressDto>, GenericFailure> getAddressByLocation(
    LatLngDto location,
  );
  AsyncResult<List<AddressDto>, GenericFailure> getAddressByText(String addressText);
  AsyncResult<LatLngDto, GenericFailure> getLocationFromAddress(String address);
}
