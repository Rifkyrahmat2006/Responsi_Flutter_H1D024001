# Dokumentasi Singkat – Responsi Flutter

## 1. Struktur Aplikasi

```
lib/
├── main.dart                         # entry point, inisialisasi SharedPreferences
├── app.dart                          # MultiProvider + MaterialApp + Theme
├── core/
│   ├── constants/api_constants.dart  # host Open-Meteo
│   ├── errors/api_exception.dart     # error dengan pesan ramah pengguna
│   ├── theme/app_theme.dart          # Theme & Typography
│   └── utils/                        # weather_code_mapper, date_formatter
├── data/                             # MODEL (data layer)
│   ├── models/                       # LocationModel, WeatherModel (fromJson/toJson)
│   ├── services/                     # OpenMeteoService (HTTP GET), LocalStorageService
│   └── repositories/                 # WeatherRepositoryImpl
├── domain/repositories/              # kontrak WeatherRepository
└── presentation/
    ├── viewmodels/                   # WeatherViewModel, SearchViewModel
    ├── screens/                      # WeatherScreen (Home), SearchLocationScreen
    └── widgets/                      # komponen UI (card, tile, state views)
test/                                 # unit test model/mapper/ViewModel + widget test
```

## 2. Implementasi API (Open-Meteo)

Semua request menggunakan **HTTP GET** (`package:http`) di `data/services/open_meteo_service.dart`.

| Fungsi | Endpoint | Parameter utama |
| --- | --- | --- |
| Cari kota | `https://geocoding-api.open-meteo.com/v1/search` | `name`, `count`, `language`, `format` |
| Cuaca | `https://api.open-meteo.com/v1/forecast` | `latitude`, `longitude`, `current`, `daily`, `timezone=auto` |

Field yang dipakai:

| Data | Field API |
| --- | --- |
| Suhu saat ini | `current.temperature_2m` |
| Kelembapan | `current.relative_humidity_2m` |
| Suhu terasa | `current.apparent_temperature` |
| Curah hujan | `current.precipitation` |
| Kode cuaca | `current.weather_code` |
| Kecepatan angin | `current.wind_speed_10m` |
| Suhu maks/min harian | `daily.temperature_2m_max` / `daily.temperature_2m_min` |
| Peluang hujan maks | `daily.precipitation_probability_max` |

Alur pengolahan: respons JSON → `jsonDecode` → `LocationModel.fromJson` / `WeatherModel.fromJson` → ditampilkan di UI.
Kegagalan jaringan, timeout (15 detik), status HTTP non-2xx, dan format JSON tidak valid dipetakan ke `ApiException`
sehingga UI menampilkan pesan error dan tombol **Coba lagi**. Pencarian kota selalu melakukan request ke Geocoding API
(dengan debounce 400 ms dan pengabaian respons lama).

## 3. Penerapan MVVM

| Lapisan | Peran | File |
| --- | --- | --- |
| **Model** | Data & akses data (API, penyimpanan lokal) | `data/models`, `data/services`, `data/repositories`, `domain/repositories` |
| **ViewModel** | Menyimpan state UI (`loading`, `error`, `weather`, `results`, `favorites`) dan logika; memanggil repository; `notifyListeners()` | `presentation/viewmodels` |
| **View** | Menampilkan state, meneruskan aksi pengguna ke ViewModel; tidak memanggil API langsung | `presentation/screens`, `presentation/widgets` |

Alur: `View` ──aksi──▶ `ViewModel` ──▶ `Repository` ──▶ `OpenMeteoService` / `LocalStorageService`,
lalu ViewModel memperbarui state dan `notifyListeners()` sehingga View yang memakai `context.watch<...>()` dibangun ulang (recomposition).

## 4. Local Storage

`LocalStorageService` (SharedPreferences) menyimpan **daftar lokasi favorit** dan **lokasi terakhir dipilih** dalam bentuk JSON.
Data dimuat kembali di `WeatherViewModel.initialize()` saat aplikasi dibuka.

## 5. Kesesuaian dengan Ketentuan Responsi

| Ketentuan | Status | Lokasi |
| --- | --- | --- |
| Flutter + Dart, Stateful/Stateless | ✅ | seluruh `lib/` |
| Flutter Widgets, Material Design, Theme, Typography | ✅ | `core/theme/app_theme.dart`, `presentation/` |
| UI responsif | ✅ | `LayoutBuilder` + `Wrap`, `ConstrainedBox`, daftar prakiraan vertikal |
| Local storage (favorit/riwayat) tampil kembali | ✅ | `local_storage_service.dart` |
| State management (Provider) | ✅ | `viewmodels/`, `app.dart` |
| Pencarian kota → cuaca kota terpilih | ✅ | `search_location_screen.dart` |
| REST API Open-Meteo, HTTP GET, JSON → model Dart | ✅ | `open_meteo_service.dart`, `data/models` |
| Loading, data kosong, error | ✅ | `state_views.dart` |
| MVVM | ✅ | lihat bagian 3 |
| Minimal 2 screen (Home & Search) | ✅ | `presentation/screens` |
| Data dari API, bukan hardcoded | ✅ | hanya lokasi awal (Jakarta) yang default; data cuaca selalu dari API |
