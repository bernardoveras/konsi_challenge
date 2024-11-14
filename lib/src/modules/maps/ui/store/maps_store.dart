import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/dtos/lat_lng_dto.dart';
import '../../../../shared/errors/errors.dart';
import '../../../addresses/domain/dtos/address_dto.dart';
import '../../../addresses/domain/services/i_address_service.dart';

class MapsStore extends ChangeNotifier {
  final IAddressService addressService;

  MapsStore({
    required this.addressService,
  });

  bool searchingAddress = false;

  void changeSearchingAddress(bool value) {
    searchingAddress = value;
    notifyListeners();
  }

  List<AddressDto> addresses = [];
  void changeAddresses(List<AddressDto> value) {
    addresses = value;
    notifyListeners();
  }

  AsyncResult<List<AddressDto>, GenericFailure> getAddressByLocation(
    LatLngDto latLng,
  ) async {
    try {
      changeSearchingAddress(true);

      final addressFoundResult =
          await addressService.getAddressesByLocation(latLng);

      return addressFoundResult;
    } on GenericFailure catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        GeolocatorFailure(
          error: e,
        ),
      );
    } finally {
      changeSearchingAddress(false);
    }
  }

  AsyncResult<List<AddressDto>, GenericFailure> getAddressByText(
    String addressText,
  ) async {
    try {
      debugPrint('Searching address $addressText');

      changeSearchingAddress(true);

      final addressFoundResult =
          await addressService.getAddressesByText(addressText: addressText);

      changeAddresses(addressFoundResult.getOrDefault([]));

      return addressFoundResult;
    } on GenericFailure catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        GeolocatorFailure(
          error: e,
        ),
      );
    } finally {
      changeSearchingAddress(false);
    }
  }
}
