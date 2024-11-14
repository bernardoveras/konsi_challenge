import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/errors/errors.dart';
import '../../../../shared/services/cep/domain/services/i_cep_locator_service.dart';
import '../../domain/dtos/address_book_dto.dart';
import '../../domain/dtos/address_dto.dart';
import '../../domain/services/i_address_book_service.dart';
import '../../domain/services/i_address_service.dart';

class AddressStore extends ChangeNotifier {
  final IAddressService addressGeocodingService;
  final IAddressBookService addressBookService;
  final ICepLocatorService cepLocatorService;

  AddressStore({
    required this.addressGeocodingService,
    required this.addressBookService,
    required this.cepLocatorService,
  });

  bool searchingAddress = false;

  void changeSearchingAddress(bool value) {
    searchingAddress = value;
    notifyListeners();
  }

  bool saving = false;

  void changeSaving(bool value) {
    saving = value;
    notifyListeners();
  }

  AsyncResult<AddressDto, GenericFailure> getAddressByPostalCode(
    String postalCode,
  ) async {
    try {
      changeSearchingAddress(true);

      final result = await cepLocatorService.search(postalCode);

      if (result.isError()) {
        return Failure(result.exceptionOrNull()!);
      }

      final address = result.getOrThrow();

      final addressParsed = AddressDto(
        street: address.street,
        city: address.city,
        state: address.state,
        neighborhood: address.neighborhood,
        postalCode: address.cep,
      );

      return Success(addressParsed);
    } on GenericFailure catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        UnknownFailure(
          error: e,
          message: 'Não foi possível obter o endereço com o CEP $postalCode.',
        ),
      );
    } finally {
      changeSearchingAddress(false);
    }
  }

  AsyncResult<bool, GenericFailure> saveAddress(AddressBookDto address) async {
    try {
      changeSaving(true);

      final result = await addressBookService.save(address);

      if (result.isError()) {
        return Failure(result.exceptionOrNull()!);
      }

      return const Success(true);
    } on GenericFailure catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        UnknownFailure(
          error: e,
          message: 'Não foi possível salvar o endereço.',
        ),
      );
    } finally {
      changeSaving(false);
    }
  }
}
