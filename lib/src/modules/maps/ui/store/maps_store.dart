import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/dtos/lat_lng_dto.dart';
import '../../../../shared/errors/errors.dart';
import '../../../../shared/services/geolocator/domain/services/i_geolocator_service.dart';
import '../../../../shared/services/geolocator/ui/mixins/geolocator_store_mixin.dart';
import '../../../addresses/domain/dtos/address_dto.dart';
import '../../../addresses/domain/services/i_address_service.dart';

class MapsStore extends ChangeNotifier with GeolocatorStoreMixin {
  @override
  final IGeolocatorService geolocatorService;
  final IAddressService addressService;

  MapsStore({
    required this.geolocatorService,
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
          await addressService.getAddressByLocation(latLng);

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
          await addressService.getAddressByText(addressText);

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
