import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_oracle/core/storage/local_storage_service.dart';
import 'package:crypto_oracle/features/auth/domain/auth_provider.dart';
import 'package:crypto_oracle/features/watchlist/data/watchlist_repository.dart';
import 'package:crypto_oracle/features/market/domain/market_provider.dart';
import 'package:crypto_oracle/models/market/coin_model.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository();
});

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, List<String>>((ref) {
  final repository = ref.watch(watchlistRepositoryProvider);
  final uid = ref.watch(authProvider).maybeWhen(
        authenticated: (user) => user.id,
        orElse: () => null,
      );
  return WatchlistNotifier(repository, uid);
});

class WatchlistNotifier extends StateNotifier<List<String>> {
  final WatchlistRepository _repository;
  final String? _uid;

  WatchlistNotifier(this._repository, this._uid) : super([]) {
    if (_uid != null) {
      _loadWatchlist();
    }
  }

  Future<void> _loadWatchlist() async {
    state = await _repository.getWatchlist(_uid!);
  }

  Future<void> addToWatchlist(String coinId) async {
    if (_uid == null) return;
    if (!state.contains(coinId)) {
      await _repository.addToWatchlist(_uid!, coinId);
      state = [...state, coinId];
    }
  }

  Future<void> removeFromWatchlist(String coinId) async {
    if (_uid == null) return;
    await _repository.removeFromWatchlist(_uid!, coinId);
    state = state.where((id) => id != coinId).toList();
  }

  Future<void> toggleWatchlist(String coinId) async {
    if (state.contains(coinId)) {
      await removeFromWatchlist(coinId);
    } else {
      await addToWatchlist(coinId);
    }
  }

  bool isInWatchlist(String coinId) {
    return state.contains(coinId);
  }

  Future<void> clearWatchlist() async {
    if (_uid == null) return;
    await _repository.clearWatchlist(_uid!);
    state = [];
  }
}

final watchlistCoinsProvider =
    FutureProvider.autoDispose<List<CoinModel>>((ref) async {
  final watchlist = ref.watch(watchlistProvider);

  if (watchlist.isEmpty) {
    return [];
  }

  final repository = ref.watch(binanceMarketRepositoryProvider);
  final ids = watchlist.join(',');

  return await repository.getMarketCoins(ids: ids);
});
