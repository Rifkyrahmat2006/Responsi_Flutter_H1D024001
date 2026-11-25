import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/location_model.dart';
import '../viewmodels/search_view_model.dart';
import '../viewmodels/weather_view_model.dart';
import '../widgets/state_views.dart';

/// Search / Location Screen.
class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  final controller = TextEditingController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    // Mulai dari kondisi bersih agar hasil pencarian lama tidak muncul.
    context.read<SearchViewModel>().clear();
  }

  @override
  void dispose() {
    debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchViewModel>();
    final weather = context.watch<WeatherViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cari lokasi')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      debounce?.cancel();
                      debounce = Timer(
                        const Duration(milliseconds: 400),
                        () => search.search(value),
                      );
                    },
                    onSubmitted: search.search,
                    decoration: const InputDecoration(
                      labelText: 'Nama kota',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _buildResults(search, weather)),
                  if (weather.favorites.isNotEmpty) ...[
                    const Divider(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lokasi favorit',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 112),
                      child: SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              for (final location in weather.favorites)
                                InputChip(
                                  label: Text(location.name),
                                  onPressed: () => _select(weather, location),
                                  onDeleted: () =>
                                      weather.toggleFavorite(location),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(SearchViewModel search, WeatherViewModel weather) {
    if (search.loading) return const LoadingView();
    if (search.error != null) {
      return ErrorView(
        message: search.error!,
        onRetry: () => search.search(controller.text),
      );
    }
    if (!search.hasSearched) {
      return const EmptyView(
        message: 'Ketik nama kota untuk mencari',
        icon: Icons.travel_explore,
      );
    }
    if (search.results.isEmpty) {
      return EmptyView(
        message: 'Kota "${search.query}" tidak ditemukan. Coba kata kunci lain.',
        icon: Icons.location_off_outlined,
      );
    }
    return ListView.builder(
      itemCount: search.results.length,
      itemBuilder: (_, i) {
        final location = search.results[i];
        return ListTile(
          title: Text(location.name),
          subtitle: Text(location.subtitle),
          leading: const Icon(Icons.location_on_outlined),
          trailing: IconButton(
            tooltip: 'Favorit',
            icon: Icon(
              weather.isFavorite(location)
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () => weather.toggleFavorite(location),
          ),
          onTap: () => _select(weather, location),
        );
      },
    );
  }

  /// Menutup layar pencarian lebih dulu, lalu memuat cuaca lokasi terpilih
  /// (loading/error ditampilkan di Home Screen).
  void _select(WeatherViewModel weather, LocationModel location) {
    Navigator.of(context).pop();
    unawaited(weather.select(location));
  }
}
