import 'package:crypto_oracle/core/storage/local_storage_service.dart';

class WatchlistRepository {
  final LocalStorageService _localStorage;

  WatchlistRepository(this._localStorage);

  Future<List<String>> getWatchlist() async {
    return _localStorage.getWatchlist();
  }

  Future<void> addToWatchlist(String coinId) async {
    await _localStorage.addToWatchlist(coinId);
  }

  Future<void> removeFromWatchlist(String coinId) async {
    await _localStorage.removeFromWatchlist(coinId);
  }

  bool isInWatchlist(String coinId) {
    return _localStorage.isInWatchlist(coinId);
  }

  Future<void> clearWatchlist() async {
    await _localStorage.saveWatchlist([]);
  }
}
