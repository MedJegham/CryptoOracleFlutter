import 'package:crypto_oracle/core/network/dio_client.dart';
import 'package:crypto_oracle/core/errors/app_exception.dart';
import 'package:crypto_oracle/models/market/coin_model.dart';
import 'package:crypto_oracle/models/market/coin_detail_model.dart';
import 'package:crypto_oracle/models/market/market_chart_model.dart';

class MarketRepository {
  final DioClient _dioClient;

  MarketRepository(this._dioClient);

  Future<List<CoinModel>> getMarketCoins({
    String currency = 'usd',
    int page = 1,
    int perPage = 20,
    String? ids,
  }) async {
    try {
      final response = await _dioClient.get(
        '/coins/markets',
        queryParameters: {
          'vs_currency': currency,
          'order': 'market_cap_desc',
          'per_page': perPage,
          'page': page,
          'sparkline': true,
          if (ids != null) 'ids': ids,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => CoinModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(message: 'Invalid response format');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to fetch market data: $e');
    }
  }

  Future<CoinDetailModel> getCoinDetail(String coinId) async {
    try {
      final response = await _dioClient.get(
        '/coins/$coinId',
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': true,
          'developer_data': false,
          'sparkline': true,
        },
      );

      return CoinDetailModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to fetch coin details: $e');
    }
  }

  Future<MarketChartModel> getMarketChart(
    String coinId, {
    String currency = 'usd',
    int days = 7,
  }) async {
    try {
      final response = await _dioClient.get(
        '/coins/$coinId/market_chart',
        queryParameters: {
          'vs_currency': currency,
          'days': days,
        },
      );

      return MarketChartModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to fetch market chart: $e');
    }
  }

  Future<List<CoinModel>> searchCoins(String query) async {
    try {
      final response = await _dioClient.get(
        '/search',
        queryParameters: {
          'query': query,
        },
      );

      if (response.data['coins'] is List) {
        final coinIds = (response.data['coins'] as List)
            .take(10)
            .map((coin) => coin['id'] as String)
            .join(',');

        if (coinIds.isEmpty) return [];

        return await getMarketCoins(ids: coinIds);
      }

      return [];
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to search coins: $e');
    }
  }
}
