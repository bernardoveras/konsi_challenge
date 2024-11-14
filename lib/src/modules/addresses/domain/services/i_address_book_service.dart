import 'package:result_dart/result_dart.dart';

import '../../../../shared/errors/errors.dart';
import '../dtos/address_book_dto.dart';

abstract interface class IAddressBookService {
  AsyncResult<AddressBookDto, GenericFailure> save(AddressBookDto address);
  AsyncResult<List<AddressBookDto>, GenericFailure> getAddressesBook({
    String? filter,
  });
}
