import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter/app.dart';
import 'package:responsi_flutter/data/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_weather_repository.dart';

void main() {
  testWidgets('home screen menampilkan data cuaca dari repository', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      WeatherApp(
        storage: LocalStorageService(preferences),
        repository: FakeWeatherRepository(),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Jakarta'), findsOneWidget);
    expect(find.text('30.0°C'), findsOneWidget);
    expect(find.text('Cerah'), findsWidgets);
    expect(find.text('Kelembapan'), findsOneWidget);
    expect(find.text('Peluang hujan'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('home screen menampilkan error dan tombol coba lagi', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      WeatherApp(
        storage: LocalStorageService(preferences),
        repository: FakeWeatherRepository(error: Exception('gagal')),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Coba lagi'), findsOneWidget);
  });
}
