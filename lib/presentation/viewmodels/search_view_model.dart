import 'package:flutter/foundation.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/location_model.dart';
import '../../domain/repositories/weather_repository.dart';

/// ViewModel layar pencarian lokasi.
class SearchViewModel extends ChangeNotifier {
  SearchViewModel(this._repository);

  final WeatherRepository _repository;

  List<LocationModel> results = [];
  bool loading = false;
  String? error;

  /// True jika sudah ada pencarian yang selesai (membedakan "belum mencari"
  /// dengan "mencari tapi hasil kosong").
  bool hasSearched = false;
  String query = '';

  int _requestId = 0;

  Future<void> search(String input) async {
    final keyword = input.trim();
    final id = ++_requestId;

    if (keyword.isEmpty) {
      clear(notify: true);
      return;
    }

    query = keyword;
    loading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _repository.searchLocations(keyword);
      if (id != _requestId) return; // abaikan respons lama
      results = data;
    } on ApiException catch (e) {
      if (id != _requestId) return;
      results = [];
      error = e.message;
    } catch (_) {
      if (id != _requestId) return;
      results = [];
      error = 'Terjadi kesalahan saat mencari lokasi.';
    }

    hasSearched = true;
    loading = false;
    notifyListeners();
  }

  /// Mengosongkan state pencarian.
  void clear({bool notify = false}) {
    _requestId++;
    results = [];
    error = null;
    loading = false;
    hasSearched = false;
    query = '';
    if (notify) notifyListeners();
  }
}
