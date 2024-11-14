import 'package:geocoding/geocoding.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/dtos/lat_lng_dto.dart';
import '../../../../shared/errors/errors.dart';
import '../../domain/dtos/address_dto.dart';
import '../../domain/services/i_address_service.dart';

class AddressGeocodingServiceImpl implements IAddressService {
  @override
  AsyncResult<List<AddressDto>, GenericFailure> getAddressByLocation(
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

      final parsedAddresses = addressesFound
          .map(
            (x) => _parsePlacemarkToAddressDto(x).copyWith(
              latitude: location.latitude,
              longitude: location.longitude,
            ),
          )
          .toList();

      return Success(parsedAddresses);
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
  AsyncResult<List<AddressDto>, GenericFailure> getAddressByText(
    String addressText,
  ) async {
    try {
      final locationResult = await getLocationFromAddress(addressText);

      if (locationResult.isError()) {
        return Failure(locationResult.exceptionOrNull()!);
      }

      final location = locationResult.getOrThrow();

      final addressResult = await getAddressByLocation(location.first);

      return addressResult;
    } catch (e) {
      return Failure(
        UnknownFailure(
          error: e,
          message: 'Não foi possível obter o endereço.',
        ),
      );
    }
  }

  @override
  AsyncResult<List<LatLngDto>, GenericFailure> getLocationFromAddress(
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

      final parsedLocations =
          locationsFound.map((x) => _parseLocationToLatLngDto(x)).toList();

      return Success(parsedLocations);
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
