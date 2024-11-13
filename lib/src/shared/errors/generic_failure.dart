abstract class GenericFailure implements Exception {
  /// Title of the error created.
  final String? title;

  /// Description of the error created.
  ///
  /// This message can be used to provide detailed information
  /// about the error to the end user or for debugging purposes.
  final String message;

  /// Created error details.
  ///
  /// This property can be used to access specific details about the error,
  /// such as a stack trace or error code, and can be used for debugging or
  /// to present detailed information to the end user.
  final dynamic error;

  GenericFailure({
    this.title,
    required this.message,
    this.error,
  });

  @override
  String toString() => message;
}
