import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto_oracle/core/theme/app_theme.dart';
import 'package:crypto_oracle/core/router/app_router.dart';
import 'package:crypto_oracle/core/storage/local_storage_service.dart';
import 'package:crypto_oracle/features/watchlist/domain/watchlist_provider.dart';
import 'package:crypto_oracle/features/settings/domain/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Local Storage
  final localStorage = LocalStorageService();
  await localStorage.init();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(localStorage),
      ],
      child: const CryptoOracleApp(),
    ),
  );
}

class CryptoOracleApp extends ConsumerWidget {
  const CryptoOracleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'CryptoOracle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
