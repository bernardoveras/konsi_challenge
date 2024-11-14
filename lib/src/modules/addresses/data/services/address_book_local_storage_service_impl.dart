import 'dart:convert';

import 'package:result_dart/result_dart.dart';

import '../../../../shared/constants/constants.dart';
import '../../../../shared/errors/errors.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/services/local_storage/domain/domain.dart';
import '../../domain/dtos/address_book_dto.dart';
import '../../domain/services/i_address_book_service.dart';

class AddressBookLocalStorageServiceImpl implements IAddressBookService {
  final ILocalStorageService localStorageService;

  AddressBookLocalStorageServiceImpl({
    required this.localStorageService,
  });

  @override
  AsyncResult<AddressBookDto, GenericFailure> save(
    AddressBookDto address,
  ) async {
    try {
      final addressesResult = await getAddressesBook();

      if (addressesResult.isError()) {
        return Failure(addressesResult.exceptionOrNull()!);
      }

      final oldAddresses = addressesResult.getOrDefault([]);

      final alreadyExists = oldAddresses.any((x) => x.id == address.id);

      var addresses = [
        if (!alreadyExists) address,
        ...oldAddresses,
      ];

      if (alreadyExists) {
        final index = addresses.indexWhere((x) => x.id == address.id);
        addresses[index] = address;
      }

      await localStorageService.write(
        LocalStorageKey.addresses,
        jsonEncode(addresses.map((x) => x.toMap()).toList()),
      );

      return Success(address);
    } catch (e) {
      return Failure(
        UnknownFailure(
          error: e,
          message: 'Não foi possível salvar o endereço.',
        ),
      );
    }
  }

  @override
  AsyncResult<List<AddressBookDto>, GenericFailure> getAddressesBook({
    String? filter,
  }) async {
    try {
      final addressesJson =
          await localStorageService.read(LocalStorageKey.addresses);

      var addresses = <AddressBookDto>[];

      if (addressesJson != null) {
        final addressesDecoded = jsonDecode(addressesJson);

        if (addressesDecoded is List) {
          addresses.addAll(
            (addressesDecoded).map((x) => AddressBookDto.fromMap(x)).toList(),
          );
        }
      }

      if (filter.isNotBlank) {
        addresses = addresses
            .where((x) =>
                x.postalCode
                    .removeSpecialCharacters()!
                    .contains(filter!.removeSpecialCharacters()!) ||
                x.address.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      }

      return Success(addresses);
    } catch (e) {
      return Failure(
        UnknownFailure(
          error: e,
          message: 'Não foi possível obter os endereços.',
        ),
      );
    }
  }
}
