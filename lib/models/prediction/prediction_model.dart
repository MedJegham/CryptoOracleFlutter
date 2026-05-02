import 'package:freezed_annotation/freezed_annotation.dart';

part 'prediction_model.freezed.dart';
part 'prediction_model.g.dart';

enum PredictionDirection {
  @JsonValue('bullish')
  bullish,
  @JsonValue('bearish')
  bearish,
  @JsonValue('neutral')
  neutral,
}

@freezed
class PredictionModel with _$PredictionModel {
  const factory PredictionModel({
    @JsonKey(name: 'coin_id') required String coinId,
    @JsonKey(name: 'current_price') required double currentPrice,
    @JsonKey(name: 'prediction_h1') required double predictionH1,
    @JsonKey(name: 'prediction_h4') required double predictionH4,
    @JsonKey(name: 'direction_h1') required PredictionDirection directionH1,
    @JsonKey(name: 'direction_h4') required PredictionDirection directionH4,
    @JsonKey(name: 'confidence_h1') required double confidenceH1,
    @JsonKey(name: 'confidence_h4') required double confidenceH4,
    @JsonKey(name: 'change_percentage_h1') double? changePercentageH1,
    @JsonKey(name: 'change_percentage_h4') double? changePercentageH4,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
    String? model,
    Map<String, dynamic>? metadata,
  }) = _PredictionModel;

  factory PredictionModel.fromJson(Map<String, dynamic> json) =>
      _$PredictionModelFromJson(json);
}

extension PredictionDirectionExtension on PredictionDirection {
  String get displayName {
    switch (this) {
      case PredictionDirection.bullish:
        return 'Bullish';
      case PredictionDirection.bearish:
        return 'Bearish';
      case PredictionDirection.neutral:
        return 'Neutral';
    }
  }

  String get emoji {
    switch (this) {
      case PredictionDirection.bullish:
        return '📈';
      case PredictionDirection.bearish:
        return '📉';
      case PredictionDirection.neutral:
        return '➡️';
    }
  }
}
