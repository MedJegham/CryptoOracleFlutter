import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_oracle/features/predictions/data/predictions_data.dart';
import 'package:crypto_oracle/features/market/domain/market_provider.dart';
import 'package:crypto_oracle/models/prediction/prediction_model.dart';

final technicalPredictionServiceProvider = Provider<TechnicalPredictionService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TechnicalPredictionService(dioClient);
});

final predictionProvider = FutureProvider.autoDispose.family<PredictionModel, String>(
  (ref, coinId) async {
    final service = ref.watch(technicalPredictionServiceProvider);
    return await service.getPrediction(coinId);
  },
);

final batchPredictionsProvider = FutureProvider.autoDispose.family<Map<String, PredictionModel>, List<String>>(
  (ref, coinIds) async {
    final service = ref.watch(technicalPredictionServiceProvider);
    final predictions = <String, PredictionModel>{};

    for (final coinId in coinIds) {
      try {
        predictions[coinId] = await service.getPrediction(coinId);
      } catch (e) {
        // Skip failed predictions
        continue;
      }
    }

    return predictions;
  },
);
