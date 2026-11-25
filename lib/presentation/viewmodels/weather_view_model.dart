import 'package:flutter/foundation.dart';

import '../../core/errors/api_exception.dart';
import '../../data/models/location_model.dart';
import '../../data/models/weather_model.dart';
import '../../data/services/local_storage_service.dart';
import '../../domain/repositories/weather_repository.dart';

/// ViewModel layar cuaca: lokasi terpilih, data cuaca, dan lokasi favorit.
class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(this._repository, this._storage);

  final WeatherRepository _repository;
  final LocalStorageService _storage;

  LocationModel? location;
  WeatherModel? weather;
  List<LocationModel> favorites = [];
  bool loading = false;
  String? error;

  Future<void> initialize() async {
    // Data lokal (favorit & lokasi terakhir) dimuat kembali saat aplikasi dibuka.
    favorites = _storage.getFavorites();
    location =
        _storage.getSelected() ??
        const LocationModel(
          name: 'Jakarta',
          latitude: -6.2,
          longitude: 106.816,
          country: 'Indonesia',
        );
    await loadWeather();
  }

  Future<void> loadWeather() async {
    final target = location;
    if (target == null) return;

    loading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _repository.getWeather(target);
      if (target != location) return; // lokasi sudah berganti, abaikan
      weather = data;
    } on ApiException catch (e) {
      if (target != location) return;
      error = e.message;
    } catch (_) {
      if (target != location) return;
      error = 'Terjadi kesalahan saat memuat data cuaca.';
    }

    loading = false;
    notifyListeners();
  }

  Future<void> select(LocationModel value) async {
    location = value;
    weather = null; // jangan tampilkan cuaca kota sebelumnya
    await _storage.saveSelected(value);
    await loadWeather();
  }

  bool isFavorite(LocationModel value) => favorites.contains(value);

  Future<void> toggleFavorite(LocationModel value) async {
    if (isFavorite(value)) {
      favorites.remove(value);
    } else {
      favorites.add(value);
    }
    await _storage.saveFavorites(favorites);
    notifyListeners();
  }
}
