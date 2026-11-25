import 'package:flutter/material.dart';

import '../../core/utils/date_formatter.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../data/models/weather_model.dart';

/// Satu baris prakiraan cuaca harian.
class ForecastDayCard extends StatelessWidget {
  const ForecastDayCard({super.key, required this.day, this.isToday = false});

  final DailyWeather day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final info = weatherCodeInfo(day.weatherCode);
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isToday ? 'Hari ini' : dayName(day.date),
                    style: textTheme.titleSmall,
                  ),
                  Text(shortDate(day.date), style: textTheme.bodySmall),
                ],
              ),
            ),
            Icon(info.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(flex: 3, child: Text(info.label)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${day.maxTemperature.toStringAsFixed(0)}° / ${day.minTemperature.toStringAsFixed(0)}°',
                  style: textTheme.titleSmall,
                ),
                Text(
                  'Hujan ${day.rainProbability}%',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 92,
                  child: LinearProgressIndicator(
                    value: day.rainProbability.clamp(0, 100) / 100,
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
