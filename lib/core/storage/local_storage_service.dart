import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto_oracle/core/constants/app_constants.dart';

class LocalStorageService {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Watchlist
  Future<void> saveWatchlist(List<String> coinIds) async {
    await _prefs.setStringList(AppConstants.watchlistKey, coinIds);
  }

  List<String> getWatchlist() {
    return _prefs.getStringList(AppConstants.watchlistKey) ?? [];
  }

  Future<void> addToWatchlist(String coinId) async {
    final watchlist = getWatchlist();
    if (!watchlist.contains(coinId)) {
      watchlist.add(coinId);
      await saveWatchlist(watchlist);
    }
  }

  Future<void> removeFromWatchlist(String coinId) async {
    final watchlist = getWatchlist();
    watchlist.remove(coinId);
    await saveWatchlist(watchlist);
  }

  bool isInWatchlist(String coinId) {
    return getWatchlist().contains(coinId);
  }

  // Theme
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(AppConstants.themeKey, mode);
  }

  String? getThemeMode() {
    return _prefs.getString(AppConstants.themeKey);
  }

  // Last Sync
  Future<void> saveLastSync(DateTime dateTime) async {
    await _prefs.setString(
      AppConstants.lastSyncKey,
      dateTime.toIso8601String(),
    );
  }

  DateTime? getLastSync() {
    final dateString = _prefs.getString(AppConstants.lastSyncKey);
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  // Generic methods
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
