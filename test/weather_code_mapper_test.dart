import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter/core/utils/weather_code_mapper.dart';

void main() {
  test('maps weather code and handles unknown code', () {
    expect(weatherCodeInfo(0).label, 'Cerah');
    expect(weatherCodeInfo(999).label, 'Kondisi tidak diketahui');
  });
}
