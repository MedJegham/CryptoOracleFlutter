import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_oracle/core/theme/app_colors.dart';
import 'package:crypto_oracle/features/auth/domain/auth_provider.dart';
import 'package:crypto_oracle/features/auth/domain/auth_state.dart';
import 'package:crypto_oracle/features/settings/domain/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeModeProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final priceAlertsEnabled = ref.watch(priceAlertsEnabledProvider);
    final currency = ref.watch(currencyProvider);
    final language = ref.watch(languageProvider);
    final biometricAuth = ref.watch(biometricAuthProvider);

    String userName = 'User';
    String userEmail = '';

    authState.maybeWhen(
      authenticated: (user) {
        userName = user.name;
        userEmail = user.email;
      },
      orElse: () {},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Profile Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Appearance
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
          ),
          const SizedBox(height: 12),

          _SettingsTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: themeMode == ThemeMode.dark ? 'Dark mode' : 'Light mode',
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
            onTap: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          const SizedBox(height: 24),

          // Notifications
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
          ),
          const SizedBox(height: 12),

          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: notificationsEnabled ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                ref.read(notificationsEnabledProvider.notifier).toggle();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'Notifications enabled'
                          : 'Notifications disabled',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            onTap: () {
              ref.read(notificationsEnabledProvider.notifier).toggle();
            },
          ),

          _SettingsTile(
            icon: Icons.price_change_outlined,
            title: 'Price Alerts',
            subtitle: priceAlertsEnabled ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: priceAlertsEnabled,
              onChanged: (value) {
                ref.read(priceAlertsEnabledProvider.notifier).toggle();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value ? 'Price alerts enabled' : 'Price alerts disabled',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            onTap: () {
              ref.read(priceAlertsEnabledProvider.notifier).toggle();
            },
          ),
          const SizedBox(height: 24),

          // Preferences
          Text(
            'Preferences',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
          ),
          const SizedBox(height: 12),

          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: language,
            onTap: () {
              _showLanguageDialog(context, ref, language);
            },
          ),

          _SettingsTile(
            icon: Icons.attach_money_outlined,
            title: 'Currency',
            subtitle: currency,
            onTap: () {
              _showCurrencyDialog(context, ref, currency);
            },
          ),
          const SizedBox(height: 24),

          // Security
          Text(
            'Security',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
          ),
          const SizedBox(height: 12),

          _SettingsTile(
            icon: Icons.fingerprint_outlined,
            title: 'Biometric Authentication',
            subtitle: biometricAuth ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: biometricAuth,
              onChanged: (value) {
                ref.read(biometricAuthProvider.notifier).toggle();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'Biometric auth enabled'
                          : 'Biometric auth disabled',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            onTap: () {
              ref.read(biometricAuthProvider.notifier).toggle();
            },
          ),

          _SettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Change password feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // About
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
          ),
          const SizedBox(height: 12),

          _SettingsTile(
            icon: Icons.info_outline,
            title: 'About CryptoOracle',
            subtitle: 'Version 1.0.0',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'CryptoOracle',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.currency_bitcoin,
                  size: 48,
                  color: AppColors.primary,
                ),
                children: [
                  const Text(
                    'AI-Powered Crypto Intelligence Platform\n\n'
                    'Built with Flutter and Riverpod\n'
                    'Powered by Binance API and Technical Analysis\n\n'
                    '© 2026 CryptoOracle. All rights reserved.',
                  ),
                ],
              );
            },
          ),

          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy policy feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Terms of service feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help & support feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Logout Button
          Card(
            color: AppColors.error.withOpacity(0.1),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).logout();
                          Navigator.pop(context);
                          context.go('/auth/login');
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, String currentLanguage) {
    final languages = ['English', 'Français', 'Español', 'Deutsch', '中文', '日本語'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  ref.read(languageProvider.notifier).setLanguage(value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language changed to $value'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, WidgetRef ref, String currentCurrency) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CNY', 'KRW'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((curr) {
            return RadioListTile<String>(
              title: Text(curr),
              value: curr,
              groupValue: currentCurrency,
              onChanged: (value) {
                if (value != null) {
                  ref.read(currencyProvider.notifier).setCurrency(value);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Currency changed to $value'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
