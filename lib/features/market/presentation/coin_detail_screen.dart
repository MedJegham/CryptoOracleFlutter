import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_oracle/core/theme/app_colors.dart';
import 'package:crypto_oracle/core/utils/formatters.dart';
import 'package:crypto_oracle/features/market/domain/market_provider.dart';
import 'package:crypto_oracle/features/predictions/domain/prediction_provider.dart';
import 'package:crypto_oracle/features/watchlist/domain/watchlist_provider.dart';
import 'package:crypto_oracle/widgets/common/loading_shimmer.dart';
import 'package:crypto_oracle/widgets/common/error_view.dart';
import 'package:crypto_oracle/widgets/charts/price_chart.dart';
import 'package:crypto_oracle/widgets/cards/prediction_card.dart';

class CoinDetailScreen extends ConsumerWidget {
  final String coinId;

  const CoinDetailScreen({super.key, required this.coinId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinDetailAsync = ref.watch(coinDetailProvider(coinId));
    final marketChartAsync = ref.watch(marketChartProvider(coinId));
    final predictionAsync = ref.watch(predictionProvider(coinId));
    final isInWatchlist = ref.watch(watchlistProvider).contains(coinId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Details'),
        actions: [
          IconButton(
            icon: Icon(
              isInWatchlist ? Icons.star : Icons.star_border,
              color: isInWatchlist ? AppColors.accent : null,
            ),
            onPressed: () {
              ref.read(watchlistProvider.notifier).toggleWatchlist(coinId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isInWatchlist
                        ? 'Removed from watchlist'
                        : 'Added to watchlist',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: coinDetailAsync.when(
        data: (coin) {
          final currentPrice = coin.currentPrice;
          final priceChange24h = coin.priceChangePercentage24h ?? 0.0;
          final isPositive = priceChange24h >= 0;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(coinDetailProvider(coinId));
              ref.invalidate(marketChartProvider(coinId));
              ref.invalidate(predictionProvider(coinId));
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coin Header
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.currency_bitcoin, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.name,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            Text(
                              coin.symbol.toUpperCase(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Price Info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Price',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Formatters.formatPrice(currentPrice),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: (isPositive
                                          ? AppColors.bullish
                                          : AppColors.bearish)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  Formatters.formatPercentage(priceChange24h),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: isPositive
                                            ? AppColors.bullish
                                            : AppColors.bearish,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Market Stats
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Market Statistics',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _StatRow(
                            label: '24h Volume',
                            value: Formatters.formatCurrency(
                              coin.totalVolume ?? 0,
                            ),
                          ),
                          const Divider(height: 24),
                          _StatRow(
                            label: '24h High',
                            value: Formatters.formatPrice(
                              coin.high24h ?? 0,
                            ),
                          ),
                          const Divider(height: 24),
                          _StatRow(
                            label: '24h Low',
                            value: Formatters.formatPrice(
                              coin.low24h ?? 0,
                            ),
                          ),
                          const Divider(height: 24),
                          _StatRow(
                            label: '24h Change',
                            value: Formatters.formatPrice(
                              coin.priceChange24h ?? 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price Chart
                  marketChartAsync.when(
                    data: (chartData) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price Chart (7 Days)',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: PriceChart(chartData: chartData),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const LoadingShimmer(
                      width: double.infinity,
                      height: 250,
                    ),
                    error: (error, stack) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),

                  // AI Predictions
                  predictionAsync.when(
                    data: (prediction) {
                      return PredictionCard(prediction: prediction);
                    },
                    loading: () => const LoadingShimmer(
                      width: double.infinity,
                      height: 200,
                    ),
                    error: (error, stack) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              size: 48,
                              color: AppColors.warning,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Prediction unavailable',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Unable to fetch AI predictions at this time',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Predictions are short-term model estimations and not financial advice.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const DashboardShimmer(),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(coinDetailProvider(coinId)),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
