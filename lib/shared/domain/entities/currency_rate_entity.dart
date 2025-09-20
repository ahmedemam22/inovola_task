import 'package:equatable/equatable.dart';

class CurrencyRateEntity extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime timestamp;
  final DateTime lastUpdated;

  const CurrencyRateEntity({
    required this.baseCurrency,
    required this.rates,
    required this.timestamp,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        baseCurrency,
        rates,
        timestamp,
        lastUpdated,
      ];

  // Get exchange rate for a specific currency
  double? getRateFor(String currency) {
    if (currency.toUpperCase() == baseCurrency.toUpperCase()) {
      return 1.0;
    }
    return rates[currency.toUpperCase()];
  }

  // Convert amount from one currency to another
  double? convertAmount(double amount, String fromCurrency, String toCurrency) {
    final fromRate = getRateFor(fromCurrency);
    final toRate = getRateFor(toCurrency);

    if (fromRate == null || toRate == null) {
      return null;
    }

    // Convert to base currency first, then to target currency
    final amountInBase = amount / fromRate;
    return amountInBase * toRate;
  }

  // Convert any currency to USD (assuming USD is base currency)
  double? convertToUSD(double amount, String fromCurrency) {
    return convertAmount(amount, fromCurrency, 'USD');
  }

  // Check if rates are outdated (older than 1 hour)
  bool get isOutdated {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    return difference.inHours >= 1;
  }

  CurrencyRateEntity copyWith({
    String? baseCurrency,
    Map<String, double>? rates,
    DateTime? timestamp,
    DateTime? lastUpdated,
  }) {
    return CurrencyRateEntity(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      rates: rates ?? this.rates,
      timestamp: timestamp ?? this.timestamp,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
