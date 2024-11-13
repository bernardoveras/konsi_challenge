import 'generic_failure.dart';

class NotFoundFailure extends GenericFailure {
  NotFoundFailure({
    super.title,
    super.message = 'Não encontrado.',
    super.error,
  });
}
