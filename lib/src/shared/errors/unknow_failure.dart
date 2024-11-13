import 'errors.dart';

class UnknownFailure extends GenericFailure {
  UnknownFailure({
    super.title,
    required super.message,
    super.error,
  });
}
