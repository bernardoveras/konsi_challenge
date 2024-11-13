extension StringExtensions on String? {
  /// Checks if the `String` is Blank (null, empty or only white spaces).
  bool get isBlank => this?.trim().isEmpty ?? true;

  /// Checks if the `String` is not blank (null, empty or only white spaces).
  bool get isNotBlank => isBlank == false;

  String? removeSpecialCharacters() {
    if (isBlank) return this;

    final regex = RegExp('[^0-9a-zA-Z]+');
    final result = this?.replaceAll(regex, '');

    return result;
  }

  String? nullIfEmpty() => defaultIfEmpty(null);
  String? defaultIfEmpty(String? defaultValue) => isBlank ? defaultValue : this;

  String? capitalize() {
    if (isBlank) return this;

    var capitalized = this!.toLowerCase();
    capitalized = '${capitalized[0].toUpperCase()}${capitalized.substring(1)}';

    return capitalized;
  }

  String? titleCapitalize() {
    if (isBlank) return this;

    return this!.split(' ').map((word) => word.capitalize()).join(' ');
  }
}
