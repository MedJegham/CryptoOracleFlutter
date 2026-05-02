import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_oracle/core/theme/app_colors.dart';
import 'package:crypto_oracle/core/utils/formatters.dart';
import 'package:crypto_oracle/models/market/coin_model.dart';
import 'package:crypto_oracle/features/watchlist/domain/watchlist_provider.dart';

class CoinCard extends ConsumerWidget {
  final CoinModel coin;
  final VoidCallback onTap;
  final bool showWatchlistButton;

  const CoinCard({
    super.key,
    required this.coin,
    required this.onTap,
    this.showWatchlistButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInWatchlist = ref.watch(watchlistProvider).contains(coin.id);
    final priceChange = coin.priceChangePercentage24h ?? 0;
    final isPositive = priceChange >= 0;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Coin Icon
              if (coin.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    coin.image!,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.currency_bitcoin),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.currency_bitcoin),
                ),
              const SizedBox(width: 12),

              // Coin Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coin.symbol.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Price Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatPrice(coin.currentPrice),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isPositive ? AppColors.bullish : AppColors.bearish)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      Formatters.formatPercentage(priceChange),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isPositive
                                ? AppColors.bullish
                                : AppColors.bearish,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),

              // Watchlist Button
              if (showWatchlistButton) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    isInWatchlist ? Icons.star : Icons.star_border,
                    color: isInWatchlist ? AppColors.accent : null,
                  ),
                  onPressed: () {
                    ref.read(watchlistProvider.notifier).toggleWatchlist(coin.id);
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
            ],
          ),
        ),
      ),
    );
  }
}
