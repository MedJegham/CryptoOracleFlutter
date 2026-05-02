import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_oracle/features/market/domain/market_provider.dart';
import 'package:crypto_oracle/widgets/common/loading_shimmer.dart';
import 'package:crypto_oracle/widgets/common/error_view.dart';
import 'package:crypto_oracle/widgets/cards/coin_card.dart';

class MarketListScreen extends ConsumerStatefulWidget {
  const MarketListScreen({super.key});

  @override
  ConsumerState<MarketListScreen> createState() => _MarketListScreenState();
}

class _MarketListScreenState extends ConsumerState<MarketListScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketCoinsAsync = ref.watch(marketCoinsProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search coins...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              )
            : const Text('Market'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                }
              });
            },
          ),
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(marketCoinsProvider);
              },
            ),
        ],
      ),
      body: _isSearching && searchQuery.isNotEmpty
          ? searchResultsAsync.when(
              data: (coins) {
                if (coins.isEmpty) {
                  return const EmptyView(
                    message: 'No coins found',
                    icon: Icons.search_off,
                  );
                }

                return ListView.builder(
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
                );
              },
              loading: () => const CoinListShimmer(),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(searchResultsProvider),
              ),
            )
          : marketCoinsAsync.when(
              data: (coins) {
                if (coins.isEmpty) {
                  return const EmptyView(
                    message: 'No market data available',
                    icon: Icons.show_chart,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(marketCoinsProvider);
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
                onRetry: () => ref.invalidate(marketCoinsProvider),
              ),
            ),
    );
  }
}
