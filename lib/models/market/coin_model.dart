import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_model.freezed.dart';
part 'coin_model.g.dart';

@freezed
class CoinModel with _$CoinModel {
  const factory CoinModel({
    required String id,
    required String symbol,
    required String name,
    String? image,
    @JsonKey(name: 'current_price') required double currentPrice,
    @JsonKey(name: 'market_cap') double? marketCap,
    @JsonKey(name: 'market_cap_rank') int? marketCapRank,
    @JsonKey(name: 'total_volume') double? totalVolume,
    @JsonKey(name: 'high_24h') double? high24h,
    @JsonKey(name: 'low_24h') double? low24h,
    @JsonKey(name: 'price_change_24h') double? priceChange24h,
    @JsonKey(name: 'price_change_percentage_24h')
    double? priceChangePercentage24h,
    @JsonKey(name: 'circulating_supply') double? circulatingSupply,
    @JsonKey(name: 'total_supply') double? totalSupply,
    @JsonKey(name: 'max_supply') double? maxSupply,
    @JsonKey(name: 'ath') double? ath,
    @JsonKey(name: 'ath_change_percentage') double? athChangePercentage,
    @JsonKey(name: 'ath_date') DateTime? athDate,
    @JsonKey(name: 'atl') double? atl,
    @JsonKey(name: 'atl_change_percentage') double? atlChangePercentage,
    @JsonKey(name: 'atl_date') DateTime? atlDate,
    @JsonKey(name: 'last_updated') DateTime? lastUpdated,
    @JsonKey(name: 'sparkline_in_7d') SparklineData? sparklineIn7d,
  }) = _CoinModel;

  factory CoinModel.fromJson(Map<String, dynamic> json) =>
      _$CoinModelFromJson(json);
}

@freezed
class SparklineData with _$SparklineData {
  const factory SparklineData({
    required List<double> price,
  }) = _SparklineData;

  factory SparklineData.fromJson(Map<String, dynamic> json) =>
      _$SparklineDataFromJson(json);
}
