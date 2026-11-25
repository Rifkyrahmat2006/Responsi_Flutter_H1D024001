/// Error yang sudah dipetakan ke pesan ramah pengguna (Bahasa Indonesia).
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
