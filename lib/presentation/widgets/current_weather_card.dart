import 'package:flutter/material.dart';

import '../../core/utils/weather_code_mapper.dart';
import '../../data/models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({super.key, required this.weather});
  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    final info = weatherCodeInfo(weather.current.weatherCode);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              info.icon,
              size: 58,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.current.temperature.toStringAsFixed(1)}°C',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  info.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
