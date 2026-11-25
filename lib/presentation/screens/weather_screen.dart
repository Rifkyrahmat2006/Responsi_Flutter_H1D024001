import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/weather_view_model.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/state_views.dart';
import '../widgets/weather_detail_tile.dart';
import 'search_location_screen.dart';

/// Home / Weather Screen.
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({
    super.key,
    required this.darkMode,
    required this.onToggleTheme,
  });

  final bool darkMode;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(vm.location?.name ?? 'Cuaca'),
        actions: [
          IconButton(
            tooltip: darkMode ? 'Gunakan mode terang' : 'Gunakan mode gelap',
            onPressed: onToggleTheme,
            icon: Icon(
              darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
          IconButton(
            tooltip: 'Cari lokasi',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchLocationScreen()),
            ),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: vm.loading ? null : vm.loadWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(context, vm)),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel vm) {
    final weather = vm.weather;

    if (weather == null) {
      if (vm.loading) return const LoadingView();
      if (vm.error != null) {
        return ErrorView(message: vm.error!, onRetry: vm.loadWeather);
      }
      return EmptyView(
        message: 'Data cuaca belum tersedia',
        icon: Icons.cloud_off_outlined,
        actionLabel: 'Muat data',
        onAction: vm.loadWeather,
      );
    }

    final rain = weather.todayRainProbability;
    final tiles = [
      WeatherDetailTile(
        label: 'Kelembapan',
        value: '${weather.current.humidity}%',
        icon: Icons.water_drop_outlined,
      ),
      WeatherDetailTile(
        label: 'Kecepatan angin',
        value: '${weather.current.windSpeed.toStringAsFixed(1)} km/j',
        icon: Icons.air,
      ),
      WeatherDetailTile(
        label: 'Peluang hujan',
        value: rain == null ? '-' : '$rain%',
        icon: Icons.beach_access_outlined,
      ),
      WeatherDetailTile(
        label: 'Terasa seperti',
        value: '${weather.current.apparentTemperature.toStringAsFixed(1)}°C',
        icon: Icons.thermostat,
      ),
      WeatherDetailTile(
        label: 'Curah hujan',
        value: '${weather.current.precipitation} mm',
        icon: Icons.umbrella_outlined,
      ),
    ];

    return RefreshIndicator(
      onRefresh: vm.loadWeather,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              if ((vm.location?.subtitle ?? '').isNotEmpty) ...[
                Text(
                  vm.location!.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
              ],
              if (vm.error != null) ...[
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '${vm.error!} Menampilkan data terakhir.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              CurrentWeatherCard(weather: weather),
              const SizedBox(height: 12),
              Text(
                'Prakiraan per jam',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              HourlyForecastList(hours: weather.hourly),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  const spacing = 8.0;
                  final columns = constraints.maxWidth >= 560 ? 3 : 2;
                  final width =
                      (constraints.maxWidth - spacing * (columns - 1)) /
                      columns;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (final tile in tiles)
                        SizedBox(width: width, child: tile),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Prakiraan harian',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              DailyForecastList(days: weather.daily),
            ],
          ),
        ),
      ),
    );
  }
}
