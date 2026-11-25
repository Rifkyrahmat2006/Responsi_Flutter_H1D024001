import 'package:flutter/material.dart';

import '../../core/utils/weather_code_mapper.dart';
import '../../data/models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({super.key, required this.weather});
  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    final info = weatherCodeInfo(weather.current.weatherCode);
    final colors = _weatherColors(weather.current.weatherCode);
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(info.icon, size: 58, color: Colors.white),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.current.temperature.toStringAsFixed(1)}°C',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    info.label,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _weatherColors(int code) {
    if (code == 0) return [const Color(0xff1976d2), const Color(0xff64b5f6)];
    if ([1, 2, 3].contains(code)) {
      return [const Color(0xff455a64), const Color(0xff90a4ae)];
    }
    if ([95, 96, 99].contains(code)) {
      return [const Color(0xff283593), const Color(0xff5c6bc0)];
    }
    return [const Color(0xff1565c0), const Color(0xff42a5f5)];
  }
}
