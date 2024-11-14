abstract interface class ILocalStorageService {
  Future<void> delete(String key);
  Future<T?> read<T>(String key);
  Future<void> write<T>(String key, T? value);
}
