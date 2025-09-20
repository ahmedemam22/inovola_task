import 'package:equatable/equatable.dart';

class CurrencyInfoEntity extends Equatable {
  final String code;
  final String name;
  final String symbol;
  final double exchangeRate; // Rate to USD

  const CurrencyInfoEntity({
    required this.code,
    required this.name,
    required this.symbol,
    required this.exchangeRate,
  });

  @override
  List<Object?> get props => [code, name, symbol, exchangeRate];

  // Convert amount to USD
  double convertToUSD(double amount) {
    return amount / exchangeRate;
  }

  // Convert amount from USD
  double convertFromUSD(double usdAmount) {
    return usdAmount * exchangeRate;
  }

  CurrencyInfoEntity copyWith({
    String? code,
    String? name,
    String? symbol,
    double? exchangeRate,
  }) {
    return CurrencyInfoEntity(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      exchangeRate: exchangeRate ?? this.exchangeRate,
    );
  }

  // Factory method for common currencies
  factory CurrencyInfoEntity.usd() {
    return const CurrencyInfoEntity(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      exchangeRate: 1.0,
    );
  }

  factory CurrencyInfoEntity.eur() {
    return const CurrencyInfoEntity(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      exchangeRate: 0.85,
    );
  }

  factory CurrencyInfoEntity.gbp() {
    return const CurrencyInfoEntity(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      exchangeRate: 0.73,
    );
  }
}
