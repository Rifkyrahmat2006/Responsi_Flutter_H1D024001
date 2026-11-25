import 'package:flutter/material.dart';

import '../../core/utils/weather_code_mapper.dart';
import '../../data/models/weather_model.dart';

class HourlyForecastList extends StatelessWidget {
  const HourlyForecastList({super.key, required this.hours});
  final List<HourlyWeather> hours;

  @override
  Widget build(BuildContext context) {
    if (hours.isEmpty) return const Text('Prakiraan per jam tidak tersedia.');
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hours.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final hour = hours[index];
          final info = weatherCodeInfo(hour.weatherCode);
          final time = index == 0
              ? 'Sekarang'
              : '${hour.time.hour.toString().padLeft(2, '0')}:00';
          return SizedBox(
            width: 104,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(time, style: Theme.of(context).textTheme.labelMedium),
                    Icon(
                      info.icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      '${hour.temperature.toStringAsFixed(0)}°C',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Hujan ${hour.rainProbability}%',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
