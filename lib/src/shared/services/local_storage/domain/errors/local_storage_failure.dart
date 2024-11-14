import '../../../../errors/errors.dart';

class LocalStorageFailure extends GenericFailure {
  LocalStorageFailure({
    super.title,
    required super.message,
    super.error,
  });
}
