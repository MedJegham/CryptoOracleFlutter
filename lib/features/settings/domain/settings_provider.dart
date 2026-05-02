import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_oracle/core/storage/local_storage_service.dart';
import 'package:crypto_oracle/features/watchlist/domain/watchlist_provider.dart';

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return ThemeModeNotifier(localStorage);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final LocalStorageService _localStorage;

  ThemeModeNotifier(this._localStorage) : super(ThemeMode.dark) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final savedTheme = _localStorage.getString('theme_mode');
    if (savedTheme != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.dark,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _localStorage.setString('theme_mode', mode.toString());
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}

// Notifications Provider
final notificationsEnabledProvider = StateNotifierProvider<NotificationsNotifier, bool>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return NotificationsNotifier(localStorage);
});

class NotificationsNotifier extends StateNotifier<bool> {
  final LocalStorageService _localStorage;

  NotificationsNotifier(this._localStorage) : super(true) {
    _loadNotificationsSetting();
  }

  Future<void> _loadNotificationsSetting() async {
    final enabled = _localStorage.getBool('notifications_enabled');
    if (enabled != null) {
      state = enabled;
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = enabled;
    await _localStorage.setBool('notifications_enabled', enabled);
  }

  Future<void> toggle() async {
    await setNotificationsEnabled(!state);
  }
}

// Price Alerts Provider
final priceAlertsEnabledProvider = StateNotifierProvider<PriceAlertsNotifier, bool>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return PriceAlertsNotifier(localStorage);
});

class PriceAlertsNotifier extends StateNotifier<bool> {
  final LocalStorageService _localStorage;

  PriceAlertsNotifier(this._localStorage) : super(true) {
    _loadPriceAlertsSetting();
  }

  Future<void> _loadPriceAlertsSetting() async {
    final enabled = _localStorage.getBool('price_alerts_enabled');
    if (enabled != null) {
      state = enabled;
    }
  }

  Future<void> setPriceAlertsEnabled(bool enabled) async {
    state = enabled;
    await _localStorage.setBool('price_alerts_enabled', enabled);
  }

  Future<void> toggle() async {
    await setPriceAlertsEnabled(!state);
  }
}

// Currency Provider
final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return CurrencyNotifier(localStorage);
});

class CurrencyNotifier extends StateNotifier<String> {
  final LocalStorageService _localStorage;

  CurrencyNotifier(this._localStorage) : super('USD') {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final currency = _localStorage.getString('currency');
    if (currency != null) {
      state = currency;
    }
  }

  Future<void> setCurrency(String currency) async {
    state = currency;
    await _localStorage.setString('currency', currency);
  }
}

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return LanguageNotifier(localStorage);
});

class LanguageNotifier extends StateNotifier<String> {
  final LocalStorageService _localStorage;

  LanguageNotifier(this._localStorage) : super('English') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final language = _localStorage.getString('language');
    if (language != null) {
      state = language;
    }
  }

  Future<void> setLanguage(String language) async {
    state = language;
    await _localStorage.setString('language', language);
  }
}

// Biometric Auth Provider
final biometricAuthProvider = StateNotifierProvider<BiometricAuthNotifier, bool>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return BiometricAuthNotifier(localStorage);
});

class BiometricAuthNotifier extends StateNotifier<bool> {
  final LocalStorageService _localStorage;

  BiometricAuthNotifier(this._localStorage) : super(false) {
    _loadBiometricSetting();
  }

  Future<void> _loadBiometricSetting() async {
    final enabled = _localStorage.getBool('biometric_auth_enabled');
    if (enabled != null) {
      state = enabled;
    }
  }

  Future<void> setBiometricAuth(bool enabled) async {
    state = enabled;
    await _localStorage.setBool('biometric_auth_enabled', enabled);
  }

  Future<void> toggle() async {
    await setBiometricAuth(!state);
  }
}
