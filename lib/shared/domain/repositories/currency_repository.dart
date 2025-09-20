import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/currency_rate_entity.dart';

abstract class CurrencyRepository {
  // Get current exchange rates
  Future<Either<Failure, CurrencyRateEntity>> getExchangeRates({
    String baseCurrency = 'USD',
    bool forceRefresh = false,
  });

  // Convert currency amount
  Future<Either<Failure, double>> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  });

  // Convert any currency to USD
  Future<Either<Failure, double>> convertToUSD({
    required double amount,
    required String fromCurrency,
  });

  // Get cached exchange rates
  Future<Either<Failure, CurrencyRateEntity?>> getCachedExchangeRates();

  // Cache exchange rates
  Future<Either<Failure, void>> cacheExchangeRates(CurrencyRateEntity rates);

  // Check if cached rates are outdated
  Future<Either<Failure, bool>> areCachedRatesOutdated();

  // Get supported currencies
  Future<Either<Failure, List<String>>> getSupportedCurrencies();

  // Clear cached rates
  Future<Either<Failure, void>> clearCachedRates();
}
