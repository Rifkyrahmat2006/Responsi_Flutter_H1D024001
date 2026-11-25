import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/errors/api_exception.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';

/// Akses REST API Open-Meteo (HTTP GET) dan konversi JSON ke model Dart.
class OpenMeteoService {
  OpenMeteoService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _timeout = Duration(seconds: 15);

  /// Geocoding API: mencari lokasi berdasarkan nama kota.
  Future<List<LocationModel>> searchLocations(String name) async {
    final uri = Uri.https(ApiConstants.geocodingHost, '/v1/search', {
      'name': name,
      'count': '10',
      'language': 'id',
      'format': 'json',
    });
    final body = await _get(uri);
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return (json['results'] as List? ?? const [])
          .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const ApiException('Format data lokasi tidak valid.');
    }
  }

  /// Weather Forecast API: cuaca terkini + prakiraan harian.
  Future<WeatherModel> getWeather(LocationModel location) async {
    final uri = Uri.https(ApiConstants.forecastHost, '/v1/forecast', {
      'latitude': '${location.latitude}',
      'longitude': '${location.longitude}',
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '7',
    });
    final body = await _get(uri);
    try {
      return WeatherModel.fromJson(jsonDecode(body) as Map<String, dynamic>);
    } catch (_) {
      throw const ApiException('Format data cuaca tidak valid.');
    }
  }

  Future<String> _get(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          'Server Open-Meteo mengembalikan kesalahan (kode ${response.statusCode}).',
        );
      }
      return response.body;
    } on TimeoutException {
      throw const ApiException('Koneksi terlalu lama. Silakan coba lagi.');
    } on http.ClientException {
      throw const ApiException(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda.',
      );
    }
  }
}
