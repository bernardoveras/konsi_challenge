import 'package:flutter/material.dart';

enum SnackbarType {
  info(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blueAccent,
  ),
  success(
    foregroundColor: Colors.white,
    backgroundColor: Colors.green,
  ),
  error(
    foregroundColor: Colors.white,
    backgroundColor: Colors.red,
  );

  final Color foregroundColor;
  final Color backgroundColor;

  const SnackbarType({
    required this.foregroundColor,
    required this.backgroundColor,
  });
}
