import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_oracle/features/watchlist/domain/watchlist_provider.dart';
import 'package:crypto_oracle/widgets/common/loading_shimmer.dart';
import 'package:crypto_oracle/widgets/common/error_view.dart';
import 'package:crypto_oracle/widgets/cards/coin_card.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistCoinsAsync = ref.watch(watchlistCoinsProvider);
    final watchlist = ref.watch(watchlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          if (watchlist.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Watchlist'),
                    content: const Text(
                      'Are you sure you want to remove all coins from your watchlist?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(watchlistProvider.notifier).clearWatchlist();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Watchlist cleared'),
                            ),
                          );
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(watchlistCoinsProvider);
            },
          ),
        ],
      ),
      body: watchlist.isEmpty
          ? EmptyView(
              message: 'Your watchlist is empty',
              icon: Icons.star_border,
              actionText: 'Browse Market',
              onAction: () => context.go('/market'),
            )
          : watchlistCoinsAsync.when(
              data: (coins) {
                if (coins.isEmpty) {
                  return const EmptyView(
                    message: 'Unable to load watchlist coins',
                    icon: Icons.error_outline,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(watchlistCoinsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: coins.length,
                    itemBuilder: (context, index) {
                      final coin = coins[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CoinCard(
                          coin: coin,
                          onTap: () => context.push('/coin/${coin.id}'),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const CoinListShimmer(),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(watchlistCoinsProvider),
              ),
            ),
    );
  }
}
