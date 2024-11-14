import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/services/services.dart';

class SharedPreferencesLocalStorageAdapter implements ILocalStorageService {
  SharedPreferencesLocalStorageAdapter(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<void> delete(String key) async => _sharedPreferences.remove(key);

  @override
  Future<T?> read<T>(String key, [T? defaultValue]) async {
    final result = _sharedPreferences.getString(key);

    if (result == null) {
      return defaultValue;
    }

    switch (T) {
      case const (String):
        return result as T;
      case const (double):
        return double.tryParse(result) as T;
      case const (int):
        return int.tryParse(result) as T;
      case const (bool):
        return (result == 'true') as T;
      case const (DateTime):
        return DateTime.tryParse(result) as T;
      case const (Map):
      case const (Map<String, dynamic>):
        {
          try {
            final jsonParsed = json.decode(result);
            if (jsonParsed is Map<String, dynamic>) {
              return jsonParsed as T;
            }
            return null;
          } catch (e) {
            return null;
          }
        }
      default:
        return result as T;
    }
  }

  @override
  Future<void> write<T>(String key, T? value) async {
    if (value == null) {
      return delete(key);
    }

    var valueParsed = value.toString();

    if (T is Map<String, dynamic>) {
      valueParsed = json.encode(value);
    }

    if (T is DateTime) {
      valueParsed = (value as DateTime).toIso8601String();
    }

    await _sharedPreferences.setString(key, valueParsed);
  }
}
