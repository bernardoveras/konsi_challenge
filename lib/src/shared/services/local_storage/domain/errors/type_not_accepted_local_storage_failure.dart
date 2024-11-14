import 'local_storage_failure.dart';

class TypeNotAcceptedLocalStorageFailure extends LocalStorageFailure {
  TypeNotAcceptedLocalStorageFailure({
    super.title,
    super.message = 'Type not accepted.',
    super.error,
  });
}
