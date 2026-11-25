import '../../data/models/location_model.dart';
import '../../data/models/weather_model.dart';

abstract interface class WeatherRepository {
  Future<List<LocationModel>> searchLocations(String name);
  Future<WeatherModel> getWeather(LocationModel location);
}
