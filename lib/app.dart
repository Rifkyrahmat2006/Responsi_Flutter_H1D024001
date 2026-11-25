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

class WeatherApp extends StatefulWidget {
  /// [repository] bersifat opsional; default-nya memakai API Open-Meteo asli.
  /// Parameter ini hanya dipakai agar ViewModel dapat diuji (unit/widget test).
  const WeatherApp({super.key, required this.storage, this.repository});

  final LocalStorageService storage;
  final WeatherRepository? repository;

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late bool darkMode;

  @override
  void initState() {
    super.initState();
    darkMode = widget.storage.getDarkMode();
  }

  Future<void> toggleTheme() async {
    setState(() => darkMode = !darkMode);
    await widget.storage.saveDarkMode(darkMode);
  }

  @override
  Widget build(BuildContext context) {
    final repo = widget.repository ?? WeatherRepositoryImpl(OpenMeteoService());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(repo, widget.storage)..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => SearchViewModel(repo)),
      ],
      child: MaterialApp(
        title: 'Cuaca',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        darkTheme: appDarkTheme(),
        themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
        home: WeatherScreen(darkMode: darkMode, onToggleTheme: toggleTheme),
      ),
    );
  }
}
