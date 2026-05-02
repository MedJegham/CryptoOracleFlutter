import 'package:freezed_annotation/freezed_annotation.dart';

part 'binance_ticker_model.freezed.dart';
part 'binance_ticker_model.g.dart';

@freezed
class BinanceTickerModel with _$BinanceTickerModel {
  const factory BinanceTickerModel({
    required String symbol,
    @JsonKey(name: 'priceChange') required String priceChange,
    @JsonKey(name: 'priceChangePercent') required String priceChangePercent,
    @JsonKey(name: 'lastPrice') required String lastPrice,
    @JsonKey(name: 'volume') required String volume,
    @JsonKey(name: 'quoteVolume') required String quoteVolume,
    @JsonKey(name: 'highPrice') required String highPrice,
    @JsonKey(name: 'lowPrice') required String lowPrice,
    @JsonKey(name: 'openPrice') required String openPrice,
  }) = _BinanceTickerModel;

  factory BinanceTickerModel.fromJson(Map<String, dynamic> json) =>
      _$BinanceTickerModelFromJson(json);
}

@freezed
class BinanceKlineModel with _$BinanceKlineModel {
  const factory BinanceKlineModel({
    required int openTime,
    required String open,
    required String high,
    required String low,
    required String close,
    required String volume,
    required int closeTime,
    required String quoteVolume,
    required int trades,
  }) = _BinanceKlineModel;

  factory BinanceKlineModel.fromList(List<dynamic> data) {
    return BinanceKlineModel(
      openTime: data[0] as int,
      open: data[1] as String,
      high: data[2] as String,
      low: data[3] as String,
      close: data[4] as String,
      volume: data[5] as String,
      closeTime: data[6] as int,
      quoteVolume: data[7] as String,
      trades: data[8] as int,
    );
  }
}
