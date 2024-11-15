import '../../../../errors/errors.dart';

class HttpFailure extends GenericFailure {
  HttpFailure({
    String? message,
    super.error,
    this.statusCode,
  }) : super(message: message ?? 'Ocorreu um erro. Tente novamente.');

  final int? statusCode;
}
