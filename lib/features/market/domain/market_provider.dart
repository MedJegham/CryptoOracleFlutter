import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_oracle/core/network/dio_client.dart';
import 'package:crypto_oracle/features/market/data/binance_market_repository.dart';
import 'package:crypto_oracle/models/market/coin_model.dart';
import 'package:crypto_oracle/models/market/market_chart_model.dart';
import 'package:dio/dio.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final binanceMarketRepositoryProvider = Provider<BinanceMarketRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return BinanceMarketRepository(dioClient);
});

final marketCoinsProvider = FutureProvider.autoDispose<List<CoinModel>>((ref) async {
  final repository = ref.watch(binanceMarketRepositoryProvider);
  return await repository.getMarketCoins();
});

final coinDetailProvider = FutureProvider.autoDispose.family<CoinModel, String>(
  (ref, coinId) async {
    final repository = ref.watch(binanceMarketRepositoryProvider);
    return await repository.getCoinDetail(coinId);
  },
);

final marketChartProvider = FutureProvider.autoDispose.family<MarketChartModel, String>(
  (ref, coinId) async {
    final repository = ref.watch(binanceMarketRepositoryProvider);
    return await repository.getMarketChart(coinId, days: 7);
  },
);

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose<List<CoinModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  
  if (query.isEmpty) {
    return [];
  }

  final repository = ref.watch(binanceMarketRepositoryProvider);
  return await repository.searchCoins(query);
});
