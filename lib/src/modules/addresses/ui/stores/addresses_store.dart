import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/errors/errors.dart';
import '../../domain/dtos/address_book_dto.dart';
import '../../domain/services/i_address_book_service.dart';

class AddressesStore extends ChangeNotifier {
  final IAddressBookService addressBookService;

  AddressesStore({
    required this.addressBookService,
  });

  List<AddressBookDto> addresses = [];

  void changeAddresses(List<AddressBookDto> value) {
    addresses = value;
    notifyListeners();
  }

  bool searching = false;

  void changeSearching(bool value) {
    searching = value;
    notifyListeners();
  }

  String? searchError;

  void changeSearchError(String? value) {
    searchError = value;
    notifyListeners();
  }

  AsyncResult<List<AddressBookDto>, GenericFailure> getAddresses({
    String? filter,
  }) async {
    try {
      changeSearchError(null);
      changeSearching(true);

      final result = await addressBookService.getAddressesBook(
        filter: filter,
      );

      if (result.isSuccess()) {
        changeAddresses(result.getOrDefault([]));
      } else {
        changeSearchError(result.exceptionOrNull()?.message);
      }

      return result;
    } on GenericFailure catch (e) {
      changeSearchError(e.message);
      return Failure(e);
    } catch (e) {
      changeSearchError(
        'Não foi possível obter os endereços.\n\n${e.toString()}',
      );
      return Failure(
        UnknownFailure(
          error: e,
          message: 'Não foi possível obter os endereços.',
        ),
      );
    } finally {
      changeSearching(false);
    }
  }

  void updateAddressBook(AddressBookDto address) {
    final index = addresses.indexWhere((x) => x.id == address.id);

    var newAddresses = [
      ...addresses,
    ];

    if (index == -1) {
      newAddresses.insert(0, address);
      changeAddresses(newAddresses);
      return;
    }

    newAddresses[index] = address;

    changeAddresses(newAddresses);
  }
}
