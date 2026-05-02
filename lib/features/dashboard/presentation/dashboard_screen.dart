import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_oracle/core/theme/app_colors.dart';
import 'package:crypto_oracle/core/utils/formatters.dart';
import 'package:crypto_oracle/features/market/domain/market_provider.dart';
import 'package:crypto_oracle/features/watchlist/domain/watchlist_provider.dart';
import 'package:crypto_oracle/widgets/common/loading_shimmer.dart';
import 'package:crypto_oracle/widgets/common/error_view.dart';
import 'package:crypto_oracle/widgets/cards/stat_card.dart';
import 'package:crypto_oracle/widgets/cards/coin_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketCoinsAsync = ref.watch(marketCoinsProvider);
    final watchlist = ref.watch(watchlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(marketCoinsProvider);
            },
          ),
        ],
      ),
      body: marketCoinsAsync.when(
        data: (coins) {
          if (coins.isEmpty) {
            return const EmptyView(
              message: 'No market data available',
              icon: Icons.show_chart,
            );
          }

          final topGainer = coins.reduce((a, b) =>
              (a.priceChangePercentage24h ?? 0) >
                      (b.priceChangePercentage24h ?? 0)
                  ? a
                  : b);

          final topLoser = coins.reduce((a, b) =>
              (a.priceChangePercentage24h ?? 0) <
                      (b.priceChangePercentage24h ?? 0)
                  ? a
                  : b);

          final totalMarketCap = coins.fold<double>(
            0,
            (sum, coin) => sum + (coin.marketCap ?? 0),
          );

          final avgChange = coins.fold<double>(
                0,
                (sum, coin) => sum + (coin.priceChangePercentage24h ?? 0),
              ) /
              coins.length;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(marketCoinsProvider);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Market Overview
                  Text(
                    'Market Overview',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Market Cap',
                          value: Formatters.formatCurrency(totalMarketCap),
                          icon: Icons.account_balance_wallet,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Avg Change',
                          value: Formatters.formatPercentage(avgChange),
                          icon: Icons.trending_up,
                          color: avgChange >= 0
                              ? AppColors.bullish
                              : AppColors.bearish,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Watchlist',
                          value: watchlist.length.toString(),
                          subtitle: 'coins tracked',
                          icon: Icons.star,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Total Coins',
                          value: coins.length.toString(),
                          subtitle: 'available',
                          icon: Icons.show_chart,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Top Performers
                  Text(
                    'Top Performers',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  CoinCard(
                    coin: topGainer,
                    onTap: () => context.push('/coin/${topGainer.id}'),
                  ),
                  const SizedBox(height: 12),

                  CoinCard(
                    coin: topLoser,
                    onTap: () => context.push('/coin/${topLoser.id}'),
                  ),
                  const SizedBox(height: 24),

                  // Featured Coins
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Coins',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      TextButton(
                        onPressed: () => context.go('/market'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ...coins.take(5).map((coin) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CoinCard(
                          coin: coin,
                          onTap: () => context.push('/coin/${coin.id}'),
                        ),
                      )),
                ],
              ),
            ),
          );
        },
        loading: () => const DashboardShimmer(),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(marketCoinsProvider),
        ),
      ),
    );
  }
}
