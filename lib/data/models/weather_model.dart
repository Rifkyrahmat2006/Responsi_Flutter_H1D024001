/// Model hasil parsing JSON Open-Meteo Forecast API.
class WeatherModel {
  const WeatherModel({
    required this.current,
    required this.daily,
    this.hourly = const [],
  });
  final CurrentWeather current;
  final List<DailyWeather> daily;
  final List<HourlyWeather> hourly;

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
      hourly: _parseHourly(json['hourly'] as Map<String, dynamic>?),
    );
  }
}

List<dynamic> _listOf(Map<String, dynamic> source, String key) =>
    source[key] as List<dynamic>? ?? const [];
num? _numAt(List<dynamic> values, int index) =>
    index < values.length ? values[index] as num? : null;

List<HourlyWeather> _parseHourly(Map<String, dynamic>? source) {
  if (source == null) return [];
  final times = _listOf(source, 'time');
  final temperatures = _listOf(source, 'temperature_2m');
  final rain = _listOf(source, 'precipitation_probability');
  final codes = _listOf(source, 'weather_code');
  final result = <HourlyWeather>[];
  for (var i = 0; i < times.length; i++) {
    final temperature = _numAt(temperatures, i);
    if (temperature == null) {
      continue;
    }
    result.add(
      HourlyWeather(
        time: DateTime.parse(times[i] as String),
        temperature: temperature.toDouble(),
        rainProbability: _numAt(rain, i)?.toInt() ?? 0,
        weatherCode: _numAt(codes, i)?.toInt() ?? -1,
      ),
    );
  }
  return result;
}

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

class HourlyWeather {
  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.rainProbability,
    required this.weatherCode,
  });
  final DateTime time;
  final double temperature;
  final int rainProbability;
  final int weatherCode;
}
