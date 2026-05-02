import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double value, {String symbol = '\$'}) {
    if (value.abs() >= 1000000000) {
      return '$symbol${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value.abs() >= 1000000) {
      return '$symbol${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value.abs() >= 1000) {
      return '$symbol${(value / 1000).toStringAsFixed(2)}K';
    } else if (value.abs() >= 1) {
      return '$symbol${value.toStringAsFixed(2)}';
    } else {
      return '$symbol${value.toStringAsFixed(6)}';
    }
  }

  static String formatPrice(double value, {String symbol = '\$'}) {
    if (value >= 1) {
      return '$symbol${NumberFormat('#,##0.00').format(value)}';
    } else {
      return '$symbol${value.toStringAsFixed(6)}';
    }
  }

  static String formatPercentage(double value, {bool showSign = true}) {
    final sign = showSign && value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  static String formatLargeNumber(double value) {
    if (value.abs() >= 1000000000000) {
      return '${(value / 1000000000000).toStringAsFixed(2)}T';
    } else if (value.abs() >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K';
    } else {
      return value.toStringAsFixed(2);
    }
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(date);
    }
  }

  static String formatVolume(double value) {
    return formatLargeNumber(value);
  }

  static String formatMarketCap(double value) {
    return formatCurrency(value);
  }
}
