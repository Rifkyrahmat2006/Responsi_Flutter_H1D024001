import 'package:flutter/material.dart';

import '../../data/models/weather_model.dart';
import 'forecast_day_card.dart';

/// Daftar prakiraan cuaca beberapa hari ke depan.
class DailyForecastList extends StatelessWidget {
  const DailyForecastList({super.key, required this.days});

  final List<DailyWeather> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('Prakiraan harian tidak tersedia.'),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < days.length; i++)
          ForecastDayCard(day: days[i], isToday: i == 0),
      ],
    );
  }
}
