import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_oracle/features/auth/domain/auth_provider.dart';
import 'package:crypto_oracle/features/auth/domain/auth_state.dart';
import 'package:crypto_oracle/features/auth/presentation/login_screen.dart';
import 'package:crypto_oracle/features/auth/presentation/register_screen.dart';
import 'package:crypto_oracle/features/dashboard/presentation/dashboard_screen.dart';
import 'package:crypto_oracle/features/market/presentation/market_list_screen.dart';
import 'package:crypto_oracle/features/market/presentation/coin_detail_screen.dart';
import 'package:crypto_oracle/features/watchlist/presentation/watchlist_screen.dart';
import 'package:crypto_oracle/features/settings/presentation/settings_screen.dart';
import 'package:crypto_oracle/core/router/main_navigation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !isAuthRoute && state.matchedLocation != '/splash') {
        return '/auth/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/market',
            builder: (context, state) => const MarketListScreen(),
          ),
          GoRoute(
            path: '/watchlist',
            builder: (context, state) => const WatchlistScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/coin/:id',
        builder: (context, state) {
          final coinId = state.pathParameters['id']!;
          return CoinDetailScreen(coinId: coinId);
        },
      ),
    ],
  );
});

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Give a small delay for initialization
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    final authState = ref.read(authProvider);
    
    authState.maybeWhen(
      authenticated: (_) => context.go('/'),
      unauthenticated: () => context.go('/auth/login'),
      orElse: () => context.go('/auth/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (previous != next) {
        next.maybeWhen(
          authenticated: (_) => context.go('/'),
          unauthenticated: () => context.go('/auth/login'),
          orElse: () {},
        );
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
