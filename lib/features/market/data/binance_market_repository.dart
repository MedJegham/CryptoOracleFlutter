import 'package:crypto_oracle/core/network/dio_client.dart';
import 'package:crypto_oracle/core/errors/app_exception.dart';
import 'package:crypto_oracle/core/constants/app_constants.dart';
import 'package:crypto_oracle/models/market/coin_model.dart';
import 'package:crypto_oracle/models/market/binance_ticker_model.dart';
import 'package:crypto_oracle/models/market/market_chart_model.dart';

class BinanceMarketRepository {
  final DioClient _dioClient;

  BinanceMarketRepository(this._dioClient);

  // Symbol name mapping
  final Map<String, String> _symbolNames = {
    'BTCUSDT': 'Bitcoin',
    'ETHUSDT': 'Ethereum',
    'BNBUSDT': 'BNB',
    'SOLUSDT': 'Solana',
    'XRPUSDT': 'XRP',
    'ADAUSDT': 'Cardano',
    'DOGEUSDT': 'Dogecoin',
    'MATICUSDT': 'Polygon',
    'DOTUSDT': 'Polkadot',
    'LTCUSDT': 'Litecoin',
    'AVAXUSDT': 'Avalanche',
    'LINKUSDT': 'Chainlink',
    'ATOMUSDT': 'Cosmos',
    'UNIUSDT': 'Uniswap',
    'ETCUSDT': 'Ethereum Classic',
    'XLMUSDT': 'Stellar',
    'NEARUSDT': 'NEAR Protocol',
    'ALGOUSDT': 'Algorand',
    'APTUSDT': 'Aptos',
    'ARBUSDT': 'Arbitrum',
  };

  // Coin icon URLs using CoinGecko's CDN (coin-images subdomain, CORS-friendly)
  final Map<String, String> _symbolIcons = {
    'BTCUSDT': 'https://coin-images.coingecko.com/coins/images/1/small/bitcoin.png',
    'ETHUSDT': 'https://coin-images.coingecko.com/coins/images/279/small/ethereum.png',
    'BNBUSDT': 'https://coin-images.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
    'SOLUSDT': 'https://coin-images.coingecko.com/coins/images/4128/small/solana.png',
    'XRPUSDT': 'https://coin-images.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png',
    'ADAUSDT': 'https://coin-images.coingecko.com/coins/images/975/small/cardano.png',
    'DOGEUSDT': 'https://coin-images.coingecko.com/coins/images/5/small/dogecoin.png',
    'MATICUSDT': 'https://coin-images.coingecko.com/coins/images/4713/small/matic-token-icon.png',
    'DOTUSDT': 'https://coin-images.coingecko.com/coins/images/12171/small/polkadot.png',
    'LTCUSDT': 'https://coin-images.coingecko.com/coins/images/2/small/litecoin.png',
    'AVAXUSDT': 'https://coin-images.coingecko.com/coins/images/12559/small/Avalanche_Circle_RedWhite_Trans.png',
    'LINKUSDT': 'https://coin-images.coingecko.com/coins/images/877/small/chainlink-new-logo.png',
    'ATOMUSDT': 'https://coin-images.coingecko.com/coins/images/1481/small/cosmos_hub.png',
    'UNIUSDT': 'https://coin-images.coingecko.com/coins/images/12504/small/uniswap-uni.png',
    'ETCUSDT': 'https://coin-images.coingecko.com/coins/images/453/small/ethereum-classic-logo.png',
    'XLMUSDT': 'https://coin-images.coingecko.com/coins/images/100/small/Stellar_symbol_black_RGB.png',
    'NEARUSDT': 'https://coin-images.coingecko.com/coins/images/10365/small/near.jpg',
    'ALGOUSDT': 'https://coin-images.coingecko.com/coins/images/4380/small/download.png',
    'APTUSDT': 'https://coin-images.coingecko.com/coins/images/26455/small/aptos_round.png',
    'ARBUSDT': 'https://coin-images.coingecko.com/coins/images/16547/small/photo_2023-03-29_21.47.00.jpeg',
    'TRXUSDT': 'https://coin-images.coingecko.com/coins/images/1094/small/tron-logo.png',
    'SHIBUSDT': 'https://coin-images.coingecko.com/coins/images/11939/small/shiba.png',
    'BCHUSDT': 'https://coin-images.coingecko.com/coins/images/780/small/bitcoin-cash-circle.png',
    'SUIUSDT': 'https://coin-images.coingecko.com/coins/images/26375/small/sui_asset.jpeg',
    'INJUSDT': 'https://coin-images.coingecko.com/coins/images/12882/small/Secondary_Symbol.png',
    'FILUSDT': 'https://coin-images.coingecko.com/coins/images/12817/small/filecoin.png',
    'LDOUSDT': 'https://coin-images.coingecko.com/coins/images/13573/small/Lido_DAO.png',
    'MKRUSDT': 'https://coin-images.coingecko.com/coins/images/1364/small/Mark_Maker.png',
    'AAVEUSDT': 'https://coin-images.coingecko.com/coins/images/12645/small/AAVE.png',
    'SANDUSDT': 'https://coin-images.coingecko.com/coins/images/12129/small/sandbox_logo.jpg',
    'MANAUSDT': 'https://coin-images.coingecko.com/coins/images/878/small/decentraland-mana.png',
    'AXSUSDT': 'https://coin-images.coingecko.com/coins/images/13029/small/axie_infinity_logo.png',
    'ICPUSDT': 'https://coin-images.coingecko.com/coins/images/14495/small/Internet_Computer_logo.png',
    'VETUSDT': 'https://coin-images.coingecko.com/coins/images/1167/small/VET_Token_Icon.png',
    'OPUSDT': 'https://coin-images.coingecko.com/coins/images/25244/small/Optimism.png',
    'PEPEUSDT': 'https://coin-images.coingecko.com/coins/images/29850/small/pepe-token.jpeg',
    'WLDUSDT': 'https://coin-images.coingecko.com/coins/images/31069/small/worldcoin.jpeg',
    'ENAUSDT': 'https://coin-images.coingecko.com/coins/images/36530/small/ethena.png',
  };

  // Approximate circulating supply for market cap calculation
  final Map<String, double> _circulatingSupply = {
    'BTCUSDT': 19600000,
    'ETHUSDT': 120000000,
    'BNBUSDT': 157000000,
    'SOLUSDT': 420000000,
    'XRPUSDT': 54000000000,
    'ADAUSDT': 35000000000,
    'DOGEUSDT': 142000000000,
    'MATICUSDT': 9300000000,
    'DOTUSDT': 1300000000,
    'LTCUSDT': 73000000,
    'AVAXUSDT': 370000000,
    'LINKUSDT': 550000000,
    'ATOMUSDT': 390000000,
    'UNIUSDT': 750000000,
    'ETCUSDT': 143000000,
    'XLMUSDT': 28000000000,
    'NEARUSDT': 1100000000,
    'ALGOUSDT': 8200000000,
    'APTUSDT': 460000000,
    'ARBUSDT': 3200000000,
  };

  Future<List<CoinModel>> getMarketCoins({
    int page = 1,
    int perPage = 20,
    String? ids,
  }) async {
    try {
      final symbols = ids != null
          ? ids.split(',').map((id) => '${id.toUpperCase()}USDT').toList()
          : AppConstants.topSymbols;

      final List<CoinModel> coins = [];

      for (final symbol in symbols) {
        try {
          final response = await _dioClient.get(
            '/ticker/24hr',
            queryParameters: {'symbol': symbol},
          );

          final ticker = BinanceTickerModel.fromJson(response.data);
          final coin = _convertToCoinModel(ticker);
          coins.add(coin);
        } catch (e) {
          // Skip symbols that fail
          continue;
        }
      }

      // Sort by volume (market cap proxy)
      coins.sort((a, b) => (b.totalVolume ?? 0).compareTo(a.totalVolume ?? 0));

      return coins;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to fetch market data: $e');
    }
  }

  Future<CoinModel> getCoinDetail(String coinId) async {
    try {
      final symbol = '${coinId.toUpperCase()}USDT';

      final response = await _dioClient.get(
        '/ticker/24hr',
        queryParameters: {'symbol': symbol},
      );

      final ticker = BinanceTickerModel.fromJson(response.data);
      return _convertToCoinModel(ticker);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to fetch coin details: $e');
    }
  }

  Future<MarketChartModel> getMarketChart(
    String coinId, {
    int days = 7,
  }) async {
    try {
      final symbol = '${coinId.toUpperCase()}USDT';
      final interval = days <= 1 ? '1h' : days <= 7 ? '4h' : '1d';
      final limit = days <= 1 ? 24 : days <= 7 ? 42 : days * 24;

      final response = await _dioClient.get(
        '/klines',
        queryParameters: {
          'symbol': symbol,
          'interval': interval,
          'limit': limit,
        },
      );

      final klines = (response.data as List)
          .map((k) => BinanceKlineModel.fromList(k))
          .toList();

      final prices = klines
          .map((k) => [
                k.closeTime.toDouble(),
                double.parse(k.close),
              ])
          .toList();

      return MarketChartModel(prices: prices);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to fetch market chart: $e');
    }
  }

  Future<List<CoinModel>> searchCoins(String query) async {
    try {
      if (query.isEmpty) return [];

      final lowerQuery = query.toLowerCase();
      final List<CoinModel> results = [];

      // Search through all available symbols
      for (final symbol in AppConstants.allSymbols) {
        final coinSymbol = symbol.replaceAll('USDT', '').toLowerCase();
        final coinName = (_symbolNames[symbol] ?? coinSymbol).toLowerCase();

        if (coinSymbol.contains(lowerQuery) || coinName.contains(lowerQuery)) {
          try {
            final response = await _dioClient.get(
              '/ticker/24hr',
              queryParameters: {'symbol': symbol},
            );

            final ticker = BinanceTickerModel.fromJson(response.data);
            final coin = _convertToCoinModel(ticker);
            results.add(coin);

            // Limit results to 20 for performance
            if (results.length >= 20) break;
          } catch (e) {
            // Skip symbols that fail
            continue;
          }
        }
      }

      return results;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'Failed to search coins: $e');
    }
  }

  CoinModel _convertToCoinModel(BinanceTickerModel ticker) {
    final symbol = ticker.symbol.replaceAll('USDT', '');
    final name = _symbolNames[ticker.symbol] ?? symbol;
    final iconUrl = _symbolIcons[ticker.symbol];
    final currentPrice = double.parse(ticker.lastPrice);
    final supply = _circulatingSupply[ticker.symbol] ?? 0;
    final marketCap = supply > 0 ? currentPrice * supply : null;

    return CoinModel(
      id: symbol.toLowerCase(),
      symbol: symbol,
      name: name,
      image: iconUrl,
      currentPrice: currentPrice,
      marketCap: marketCap,
      marketCapRank: null,
      totalVolume: double.parse(ticker.quoteVolume),
      high24h: double.parse(ticker.highPrice),
      low24h: double.parse(ticker.lowPrice),
      priceChange24h: double.parse(ticker.priceChange),
      priceChangePercentage24h: double.parse(ticker.priceChangePercent),
      circulatingSupply: supply,
      totalSupply: null,
      maxSupply: null,
      ath: null,
      athChangePercentage: null,
      athDate: null,
      atl: null,
      atlChangePercentage: null,
      atlDate: null,
      lastUpdated: DateTime.now(),
      sparklineIn7d: null,
    );
  }
}
