import 'package:flutter/material.dart';

class WeatherCodeInfo {
  const WeatherCodeInfo(this.label, this.icon);
  final String label;
  final IconData icon;
}

WeatherCodeInfo weatherCodeInfo(int code) {
  if (code == 0) return const WeatherCodeInfo('Cerah', Icons.wb_sunny_outlined);
  if ([1, 2].contains(code)) {
    return const WeatherCodeInfo('Sebagian berawan', Icons.cloud_outlined);
  }
  if (code == 3) return const WeatherCodeInfo('Mendung', Icons.cloud);
  if ([45, 48].contains(code)) {
    return const WeatherCodeInfo('Berkabut', Icons.foggy);
  }
  if ([51, 53, 55, 56, 57].contains(code)) {
    return const WeatherCodeInfo('Gerimis', Icons.grain);
  }
  if ([61, 63, 65, 66, 67, 80, 81, 82].contains(code)) {
    return const WeatherCodeInfo('Hujan', Icons.water_drop_outlined);
  }
  if ([71, 73, 75, 77, 85, 86].contains(code)) {
    return const WeatherCodeInfo('Salju', Icons.ac_unit);
  }
  if ([95, 96, 99].contains(code)) {
    return const WeatherCodeInfo('Badai petir', Icons.thunderstorm_outlined);
  }
  return const WeatherCodeInfo('Kondisi tidak diketahui', Icons.help_outline);
}
