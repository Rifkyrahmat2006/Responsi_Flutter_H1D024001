import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/weather_repository_impl.dart';
import 'data/services/local_storage_service.dart';
import 'data/services/open_meteo_service.dart';
import 'domain/repositories/weather_repository.dart';
import 'presentation/screens/weather_screen.dart';
import 'presentation/viewmodels/search_view_model.dart';
import 'presentation/viewmodels/weather_view_model.dart';

class WeatherApp extends StatelessWidget {
  /// [repository] bersifat opsional; default-nya memakai API Open-Meteo asli.
  /// Parameter ini hanya dipakai agar ViewModel dapat diuji (unit/widget test).
  const WeatherApp({super.key, required this.storage, this.repository});

  final LocalStorageService storage;
  final WeatherRepository? repository;

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? WeatherRepositoryImpl(OpenMeteoService());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(repo, storage)..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => SearchViewModel(repo)),
      ],
      child: MaterialApp(
        title: 'Cuaca',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        home: const WeatherScreen(),
      ),
    );
  }
}
