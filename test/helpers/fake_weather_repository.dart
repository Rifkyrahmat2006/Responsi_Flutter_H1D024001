import 'package:responsi_flutter/data/models/location_model.dart';
import 'package:responsi_flutter/data/models/weather_model.dart';
import 'package:responsi_flutter/domain/repositories/weather_repository.dart';

/// Repository palsu untuk pengujian (tanpa akses jaringan).
class FakeWeatherRepository implements WeatherRepository {
  FakeWeatherRepository({
    this.locations = const [],
    this.error,
  });

  final List<LocationModel> locations;
  final Object? error;

  @override
  Future<List<LocationModel>> searchLocations(String name) async {
    if (error != null) throw error!;
    return locations;
  }

  @override
  Future<WeatherModel> getWeather(LocationModel location) async {
    if (error != null) throw error!;
    return WeatherModel.fromJson({
      'current': {
        'temperature_2m': 30,
        'relative_humidity_2m': 70,
        'apparent_temperature': 32,
        'precipitation': 0,
        'weather_code': 0,
        'wind_speed_10m': 10,
      },
      'daily': {
        'time': ['2026-11-25', '2026-11-26'],
        'weather_code': [0, 61],
        'temperature_2m_max': [32, 31],
        'temperature_2m_min': [25, 24],
        'precipitation_probability_max': [20, 80],
      },
    });
  }
}
