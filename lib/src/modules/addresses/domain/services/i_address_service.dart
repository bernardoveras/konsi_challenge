import 'package:result_dart/result_dart.dart';

import '../../../../shared/dtos/lat_lng_dto.dart';
import '../../../../shared/errors/errors.dart';
import '../dtos/address_dto.dart';

abstract interface class IAddressService {
  AsyncResult<AddressDto, GenericFailure> getAddressByLocation(
    LatLngDto location,
  );
  AsyncResult<LatLngDto, GenericFailure> getLocationFromAddress(String address);
}
