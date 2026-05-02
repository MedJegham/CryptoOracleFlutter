import 'package:flutter/material.dart';
import 'package:crypto_oracle/core/theme/app_colors.dart';
import 'package:crypto_oracle/core/utils/formatters.dart';
import 'package:crypto_oracle/models/prediction/prediction_model.dart';

class PredictionCard extends StatelessWidget {
  final PredictionModel prediction;

  const PredictionCard({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.accent,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI Predictions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // H+1 Prediction
            _PredictionRow(
              horizon: 'H+1 (1 Hour)',
              direction: prediction.directionH1,
              predictedPrice: prediction.predictionH1,
              changePercentage: prediction.changePercentageH1 ?? 0,
              confidence: prediction.confidenceH1,
            ),
            const Divider(height: 32),

            // H+4 Prediction
            _PredictionRow(
              horizon: 'H+4 (4 Hours)',
              direction: prediction.directionH4,
              predictedPrice: prediction.predictionH4,
              changePercentage: prediction.changePercentageH4 ?? 0,
              confidence: prediction.confidenceH4,
            ),
            const SizedBox(height: 20),

            // Model Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.psychology,
                    size: 16,
                    color: AppColors.textSecondaryDark,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Model: ${prediction.model ?? "LSTM-v1"}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    'Generated ${Formatters.formatRelativeTime(prediction.generatedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PredictionRow extends StatelessWidget {
  final String horizon;
  final PredictionDirection direction;
  final double predictedPrice;
  final double changePercentage;
  final double confidence;

  const _PredictionRow({
    required this.horizon,
    required this.direction,
    required this.predictedPrice,
    required this.changePercentage,
    required this.confidence,
  });

  Color _getDirectionColor() {
    switch (direction) {
      case PredictionDirection.bullish:
        return AppColors.bullish;
      case PredictionDirection.bearish:
        return AppColors.bearish;
      case PredictionDirection.neutral:
        return AppColors.neutral;
    }
  }

  IconData _getDirectionIcon() {
    switch (direction) {
      case PredictionDirection.bullish:
        return Icons.trending_up;
      case PredictionDirection.bearish:
        return Icons.trending_down;
      case PredictionDirection.neutral:
        return Icons.trending_flat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final directionColor = _getDirectionColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          horizon,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Direction',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _getDirectionIcon(),
                        color: directionColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        direction.displayName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: directionColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Predicted Price',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatPrice(predictedPrice),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expected Change',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatPercentage(changePercentage),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: directionColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confidence',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: confidence,
                            backgroundColor: AppColors.borderDark,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              directionColor,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(confidence * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
