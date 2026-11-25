import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter/data/models/weather_model.dart';

void main() {
  const current = {
    'temperature_2m': 30,
    'relative_humidity_2m': 70,
    'apparent_temperature': 32,
    'precipitation': 0,
    'weather_code': 1,
    'wind_speed_10m': 10,
  };

  test('decodes required Open-Meteo fields', () {
    final model = WeatherModel.fromJson({
      'current': current,
      'daily': {
        'time': ['2026-11-25'],
        'weather_code': [1],
        'temperature_2m_max': [32],
        'temperature_2m_min': [25],
        'precipitation_probability_max': [20],
      },
    });
    expect(model.current.temperature, 30);
    expect(model.daily.single.rainProbability, 20);
    expect(model.todayRainProbability, 20);
  });

  test('tahan terhadap nilai null pada data harian', () {
    final model = WeatherModel.fromJson({
      'current': current,
      'daily': {
        'time': ['2026-11-25', '2026-11-26'],
        'weather_code': [1, null],
        'temperature_2m_max': [32, null],
        'temperature_2m_min': [25, null],
        'precipitation_probability_max': [null, null],
      },
    });
    expect(model.daily.length, 1);
    expect(model.daily.single.rainProbability, 0);
  });

  test('melempar FormatException jika data tidak lengkap', () {
    expect(
      () => WeatherModel.fromJson({'current': current}),
      throwsFormatException,
    );
  });
}
