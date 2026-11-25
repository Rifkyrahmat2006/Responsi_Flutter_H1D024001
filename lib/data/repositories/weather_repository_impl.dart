import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/open_meteo_service.dart';
import '../../domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this._service);
  final OpenMeteoService _service;

  @override
  Future<List<LocationModel>> searchLocations(String name) =>
      _service.searchLocations(name);

  @override
  Future<WeatherModel> getWeather(LocationModel location) =>
      _service.getWeather(location);
}
