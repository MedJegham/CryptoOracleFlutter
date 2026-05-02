import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_chart_model.freezed.dart';
part 'market_chart_model.g.dart';

@freezed
class MarketChartModel with _$MarketChartModel {
  const factory MarketChartModel({
    required List<List<double>> prices,
    @JsonKey(name: 'market_caps') List<List<double>>? marketCaps,
    @JsonKey(name: 'total_volumes') List<List<double>>? totalVolumes,
  }) = _MarketChartModel;

  factory MarketChartModel.fromJson(Map<String, dynamic> json) =>
      _$MarketChartModelFromJson(json);
}

@freezed
class ChartDataPoint with _$ChartDataPoint {
  const factory ChartDataPoint({
    required DateTime timestamp,
    required double value,
  }) = _ChartDataPoint;

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) =>
      _$ChartDataPointFromJson(json);
}
