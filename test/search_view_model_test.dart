import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter/core/errors/api_exception.dart';
import 'package:responsi_flutter/data/models/location_model.dart';
import 'package:responsi_flutter/presentation/viewmodels/search_view_model.dart';

import 'helpers/fake_weather_repository.dart';

void main() {
  const bandung = LocationModel(
    name: 'Bandung',
    latitude: -6.9,
    longitude: 107.6,
    country: 'Indonesia',
  );

  test('pencarian berhasil mengisi results', () async {
    final vm = SearchViewModel(FakeWeatherRepository(locations: [bandung]));
    await vm.search('Bandung');

    expect(vm.results, [bandung]);
    expect(vm.hasSearched, isTrue);
    expect(vm.error, isNull);
  });

  test('hasil kosong dibedakan dari belum mencari', () async {
    final vm = SearchViewModel(FakeWeatherRepository());
    expect(vm.hasSearched, isFalse);

    await vm.search('zzzzzz');

    expect(vm.results, isEmpty);
    expect(vm.hasSearched, isTrue);
    expect(vm.error, isNull);
  });

  test('error API dipetakan ke pesan', () async {
    final vm = SearchViewModel(
      FakeWeatherRepository(error: const ApiException('Tidak ada internet')),
    );
    await vm.search('Bandung');

    expect(vm.error, 'Tidak ada internet');
    expect(vm.results, isEmpty);
  });

  test('input kosong mereset state', () async {
    final vm = SearchViewModel(FakeWeatherRepository(locations: [bandung]));
    await vm.search('Bandung');
    await vm.search('   ');

    expect(vm.results, isEmpty);
    expect(vm.hasSearched, isFalse);
  });
}
