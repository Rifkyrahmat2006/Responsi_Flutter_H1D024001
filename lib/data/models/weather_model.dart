/// Model hasil parsing JSON Open-Meteo Forecast API.
class WeatherModel {
  const WeatherModel({required this.current, required this.daily});

  final CurrentWeather current;
  final List<DailyWeather> daily;

  /// Peluang hujan maksimum hari ini (hari pertama pada data harian).
  int? get todayRainProbability =>
      daily.isEmpty ? null : daily.first.rainProbability;

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>?;
    final daily = json['daily'] as Map<String, dynamic>?;
    if (current == null || daily == null) {
      throw const FormatException('Data cuaca tidak lengkap');
    }

    final times = _listOf(daily, 'time');
    final codes = _listOf(daily, 'weather_code');
    final maxTemps = _listOf(daily, 'temperature_2m_max');
    final minTemps = _listOf(daily, 'temperature_2m_min');
    final rain = _listOf(daily, 'precipitation_probability_max');

    final days = <DailyWeather>[];
    for (var i = 0; i < times.length; i++) {
      final max = _numAt(maxTemps, i);
      final min = _numAt(minTemps, i);
      // Hari tanpa suhu tidak bisa ditampilkan, jadi dilewati.
      if (max == null || min == null) continue;
      days.add(
        DailyWeather(
          date: DateTime.parse(times[i] as String),
          weatherCode: _numAt(codes, i)?.toInt() ?? -1,
          maxTemperature: max.toDouble(),
          minTemperature: min.toDouble(),
          rainProbability: _numAt(rain, i)?.toInt() ?? 0,
        ),
      );
    }

    return WeatherModel(
      current: CurrentWeather(
        temperature: (current['temperature_2m'] as num).toDouble(),
        humidity: (current['relative_humidity_2m'] as num).toInt(),
        apparentTemperature: (current['apparent_temperature'] as num)
            .toDouble(),
        precipitation: (current['precipitation'] as num? ?? 0).toDouble(),
        weatherCode: (current['weather_code'] as num).toInt(),
        windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      ),
      daily: days,
    );
  }
}

List<dynamic> _listOf(Map<String, dynamic> source, String key) =>
    source[key] as List<dynamic>? ?? const [];

num? _numAt(List<dynamic> values, int index) =>
    index < values.length ? values[index] as num? : null;

class CurrentWeather {
  const CurrentWeather({
    required this.temperature,
    required this.humidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  final double temperature;
  final int humidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
}

class DailyWeather {
  const DailyWeather({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
    required this.rainProbability,
  });

  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;
  final int rainProbability;
}
