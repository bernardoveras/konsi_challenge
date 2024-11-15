import 'dart:io';

import 'package:equatable/equatable.dart';

class HttpResponseModel extends Equatable {
  final dynamic data;
  final int statusCode;
  final String? statusMessage;
  final Object? exception;

  const HttpResponseModel({
    this.data,
    required this.statusCode,
    this.statusMessage,
    this.exception,
  });

  bool get isSuccess {
    final successStatusCodes = [
      HttpStatus.ok,
      HttpStatus.created,
      HttpStatus.accepted,
      HttpStatus.noContent,
    ];

    return successStatusCodes.contains(statusCode);
  }

  bool get isError => !isSuccess;

  @override
  List<Object?> get props => [
        data,
        statusCode,
        statusMessage,
        exception,
      ];
}
