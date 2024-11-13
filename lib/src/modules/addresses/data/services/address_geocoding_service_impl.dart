import 'package:geocoding/geocoding.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/dtos/lat_lng_dto.dart';
import '../../../../shared/errors/errors.dart';
import '../../domain/dtos/address_dto.dart';
import '../../domain/services/i_address_service.dart';

class AddressGeocodingServiceImpl implements IAddressService {
  @override
  AsyncResult<AddressDto, GenericFailure> getAddressByLocation(
    LatLngDto location,
  ) async {
    try {
      final addressesFound = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (addressesFound.isEmpty) {
        return Failure(
          NotFoundFailure(
            message:
                'Nenhum endereço encontrado com esta latitude e longitude.',
          ),
        );
      }

      final parsedAddress = _parsePlacemarkToAddressDto(addressesFound.first);

      return Success(parsedAddress);
    } catch (e) {
      return Failure(
        UnknownFailure(
          error: e,
          message:
              'Não foi possível obter o endereço através da latitude e longitude.',
        ),
      );
    }
  }

  @override
  AsyncResult<LatLngDto, GenericFailure> getLocationFromAddress(
    String address,
  ) async {
    try {
      final locationsFound = await locationFromAddress(address);

      if (locationsFound.isEmpty) {
        return Failure(
          NotFoundFailure(
            message:
                'Nenhum endereço encontrado com esta latitude e longitude.',
          ),
        );
      }

      final parsedLocation = _parseLocationToLatLngDto(locationsFound.first);

      return Success(parsedLocation);
    } catch (e) {
      return Failure(
        UnknownFailure(
          error: e,
          message:
              'Não foi possível obter o endereço através da latitude e longitude.',
        ),
      );
    }
  }

  AddressDto _parsePlacemarkToAddressDto(Placemark placemark) {
    return AddressDto(
      street: placemark.street,
      city: placemark.locality,
      state: placemark.administrativeArea,
      neighborhood: placemark.subLocality,
      country: placemark.country,
      postalCode: placemark.postalCode,
      number: placemark.name,
    );
  }

  LatLngDto _parseLocationToLatLngDto(Location location) {
    return LatLngDto(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }
}
