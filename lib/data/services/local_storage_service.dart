import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_model.dart';

class LocalStorageService {
  LocalStorageService(this._preferences);
  final SharedPreferences _preferences;
  static const _favoritesKey = 'favorite_locations';
  static const _selectedKey = 'selected_location';
  static const _darkModeKey = 'dark_mode';
  static const _recentKey = 'recent_locations';

  List<LocationModel> getFavorites() {
    try {
      return (_preferences.getStringList(_favoritesKey) ?? const [])
          .map(
            (value) => LocationModel.fromJson(
              jsonDecode(value) as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavorites(List<LocationModel> locations) =>
      _preferences.setStringList(
        _favoritesKey,
        locations.map((location) => jsonEncode(location.toJson())).toList(),
      );

  LocationModel? getSelected() {
    final value = _preferences.getString(_selectedKey);
    if (value == null) return null;
    try {
      return LocationModel.fromJson(jsonDecode(value) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSelected(LocationModel location) =>
      _preferences.setString(_selectedKey, jsonEncode(location.toJson()));

  bool getDarkMode() => _preferences.getBool(_darkModeKey) ?? false;

  Future<void> saveDarkMode(bool enabled) =>
      _preferences.setBool(_darkModeKey, enabled);

  List<LocationModel> getRecentLocations() {
    try {
      return (_preferences.getStringList(_recentKey) ?? const [])
          .map(
            (value) => LocationModel.fromJson(
              jsonDecode(value) as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveRecentLocation(LocationModel location) async {
    final locations = [
      location,
      ...getRecentLocations().where((item) => item != location),
    ].take(5).toList();
    await _preferences.setStringList(
      _recentKey,
      locations.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }
}
