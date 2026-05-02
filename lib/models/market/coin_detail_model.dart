import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_detail_model.freezed.dart';
part 'coin_detail_model.g.dart';

@freezed
class CoinDetailModel with _$CoinDetailModel {
  const factory CoinDetailModel({
    required String id,
    required String symbol,
    required String name,
    @JsonKey(name: 'asset_platform_id') String? assetPlatformId,
    Map<String, dynamic>? platforms,
    @JsonKey(name: 'block_time_in_minutes') int? blockTimeInMinutes,
    @JsonKey(name: 'hashing_algorithm') String? hashingAlgorithm,
    List<String>? categories,
    Map<String, dynamic>? description,
    Map<String, dynamic>? links,
    CoinDetailImage? image,
    @JsonKey(name: 'country_origin') String? countryOrigin,
    @JsonKey(name: 'genesis_date') String? genesisDate,
    @JsonKey(name: 'sentiment_votes_up_percentage')
    double? sentimentVotesUpPercentage,
    @JsonKey(name: 'sentiment_votes_down_percentage')
    double? sentimentVotesDownPercentage,
    @JsonKey(name: 'market_cap_rank') int? marketCapRank,
    @JsonKey(name: 'coingecko_rank') int? coingeckoRank,
    @JsonKey(name: 'coingecko_score') double? coingeckoScore,
    @JsonKey(name: 'developer_score') double? developerScore,
    @JsonKey(name: 'community_score') double? communityScore,
    @JsonKey(name: 'liquidity_score') double? liquidityScore,
    @JsonKey(name: 'public_interest_score') double? publicInterestScore,
    @JsonKey(name: 'market_data') CoinMarketData? marketData,
    @JsonKey(name: 'last_updated') DateTime? lastUpdated,
  }) = _CoinDetailModel;

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailModelFromJson(json);
}

@freezed
class CoinDetailImage with _$CoinDetailImage {
  const factory CoinDetailImage({
    String? thumb,
    String? small,
    String? large,
  }) = _CoinDetailImage;

  factory CoinDetailImage.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailImageFromJson(json);
}

@freezed
class CoinMarketData with _$CoinMarketData {
  const factory CoinMarketData({
    @JsonKey(name: 'current_price') Map<String, dynamic>? currentPrice,
    @JsonKey(name: 'market_cap') Map<String, dynamic>? marketCap,
    @JsonKey(name: 'total_volume') Map<String, dynamic>? totalVolume,
    @JsonKey(name: 'high_24h') Map<String, dynamic>? high24h,
    @JsonKey(name: 'low_24h') Map<String, dynamic>? low24h,
    @JsonKey(name: 'price_change_24h') double? priceChange24h,
    @JsonKey(name: 'price_change_percentage_24h')
    double? priceChangePercentage24h,
    @JsonKey(name: 'price_change_percentage_7d')
    double? priceChangePercentage7d,
    @JsonKey(name: 'price_change_percentage_14d')
    double? priceChangePercentage14d,
    @JsonKey(name: 'price_change_percentage_30d')
    double? priceChangePercentage30d,
    @JsonKey(name: 'price_change_percentage_60d')
    double? priceChangePercentage60d,
    @JsonKey(name: 'price_change_percentage_200d')
    double? priceChangePercentage200d,
    @JsonKey(name: 'price_change_percentage_1y')
    double? priceChangePercentage1y,
    @JsonKey(name: 'market_cap_change_24h') double? marketCapChange24h,
    @JsonKey(name: 'market_cap_change_percentage_24h')
    double? marketCapChangePercentage24h,
    @JsonKey(name: 'circulating_supply') double? circulatingSupply,
    @JsonKey(name: 'total_supply') double? totalSupply,
    @JsonKey(name: 'max_supply') double? maxSupply,
    Map<String, dynamic>? ath,
    @JsonKey(name: 'ath_change_percentage') Map<String, dynamic>? athChangePercentage,
    @JsonKey(name: 'ath_date') Map<String, dynamic>? athDate,
    Map<String, dynamic>? atl,
    @JsonKey(name: 'atl_change_percentage') Map<String, dynamic>? atlChangePercentage,
    @JsonKey(name: 'atl_date') Map<String, dynamic>? atlDate,
  }) = _CoinMarketData;

  factory CoinMarketData.fromJson(Map<String, dynamic> json) =>
      _$CoinMarketDataFromJson(json);
}
