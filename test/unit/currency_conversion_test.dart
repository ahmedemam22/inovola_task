import 'package:flutter_test/flutter_test.dart';
import 'package:expense_track/shared/domain/entities/currency_rate_entity.dart';

void main() {
  group('Currency Conversion Tests', () {
    late CurrencyRateEntity currencyRates;

    setUp(() {
      currencyRates = CurrencyRateEntity(
        baseCurrency: 'USD',
        rates: {
          'USD': 1.0,
          'EUR': 0.85,
          'GBP': 0.73,
          'JPY': 110.0,
          'CAD': 1.25,
        },
        timestamp: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
    });

    test('should get correct rate for existing currency', () {
      expect(currencyRates.getRateFor('USD'), equals(1.0));
      expect(currencyRates.getRateFor('EUR'), equals(0.85));
      expect(currencyRates.getRateFor('GBP'), equals(0.73));
    });

    test('should return null for non-existing currency', () {
      expect(currencyRates.getRateFor('INVALID'), isNull);
    });

    test('should convert amount correctly between currencies', () {
      // Convert 100 USD to EUR
      final usdToEur = currencyRates.convertAmount(100, 'USD', 'EUR');
      expect(usdToEur, equals(85.0));

      // Convert 85 EUR to USD
      final eurToUsd = currencyRates.convertAmount(85, 'EUR', 'USD');
      expect(eurToUsd, equals(100.0));

      // Convert 100 USD to JPY
      final usdToJpy = currencyRates.convertAmount(100, 'USD', 'JPY');
      expect(usdToJpy, equals(11000.0));
    });

    test('should return same amount when converting to same currency', () {
      final result = currencyRates.convertAmount(100, 'USD', 'USD');
      expect(result, equals(100.0));
    });

    test('should return null for invalid currency conversion', () {
      final result = currencyRates.convertAmount(100, 'INVALID', 'USD');
      expect(result, isNull);
    });

    test('should convert to USD correctly', () {
      expect(currencyRates.convertToUSD(85, 'EUR'), equals(100.0));
      expect(currencyRates.convertToUSD(73, 'GBP'), equals(100.0));
      expect(currencyRates.convertToUSD(11000, 'JPY'), equals(100.0));
    });

    test('should detect outdated rates correctly', () {
      // Create rates that are 2 hours old
      final oldRates = CurrencyRateEntity(
        baseCurrency: 'USD',
        rates: {'EUR': 0.85},
        timestamp: DateTime.now(),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
      );

      expect(oldRates.isOutdated, isTrue);

      // Create fresh rates
      final freshRates = CurrencyRateEntity(
        baseCurrency: 'USD',
        rates: {'EUR': 0.85},
        timestamp: DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      expect(freshRates.isOutdated, isFalse);
    });
  });
}
