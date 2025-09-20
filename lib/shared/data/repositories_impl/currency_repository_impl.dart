import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/constants.dart';
import '../../domain/entities/currency_rate_entity.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/local/currency_local_datasource.dart';
import '../datasources/remote/currency_remote_datasource.dart';
import '../models/currency_rate_model.dart';

@LazySingleton(as: CurrencyRepository)
class CurrencyRepositoryImpl implements CurrencyRepository {
  const CurrencyRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  final CurrencyRemoteDataSource _remoteDataSource;
  final CurrencyLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, CurrencyRateEntity>> getExchangeRates({
    String baseCurrency = 'USD',
    bool forceRefresh = false,
  }) async {
    try {
      // Check if we should use cached data
      if (!forceRefresh) {
        final cachedRates = await _localDataSource.getCachedExchangeRates();
        if (cachedRates != null) {
          final entity = cachedRates.toEntity();
          if (!entity.isOutdated) {
            return Right(entity);
          }
        }
      }

      // Check network connectivity
      if (await _networkInfo.isConnected) {
        try {
          // Fetch from remote - clean API call without status checks
          final response = await _remoteDataSource.getExchangeRates(baseCurrency: baseCurrency);
          
          if (response.isSuccess && response.data != null) {
            // Cache the new rates
            await _localDataSource.cacheExchangeRates(response.data!);
            return Right(response.data!.toEntity());
          } else {
            // API returned error, try cached data
            final cachedRates = await _localDataSource.getCachedExchangeRates();
            if (cachedRates != null) {
              return Right(cachedRates.toEntity());
            }
            return Left(ServerFailure(response.message ?? 'Failed to fetch exchange rates'));
          }
        } catch (e) {
          // Network error, try cached data
          final cachedRates = await _localDataSource.getCachedExchangeRates();
          if (cachedRates != null) {
            return Right(cachedRates.toEntity());
          }
          return Left(NetworkFailure('Network error: ${e.toString()}'));
        }
      } else {
        // No network, use cached data
        final cachedRates = await _localDataSource.getCachedExchangeRates();
        if (cachedRates != null) {
          return Right(cachedRates.toEntity());
        }
        return const Left(NetworkFailure('No internet connection and no cached data available'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      final ratesResult = await getExchangeRates();
      if (ratesResult.isLeft()) {
        return Left(ratesResult.fold((l) => l, (r) => throw Exception()));
      }

      final rates = ratesResult.fold((l) => null, (r) => r);
      if (rates == null) {
        return const Left(ServerFailure('Failed to get exchange rates'));
      }

      final convertedAmount = rates.convertAmount(amount, fromCurrency, toCurrency);
      if (convertedAmount == null) {
        return Left(ValidationFailure('Unsupported currency: $fromCurrency or $toCurrency'));
      }

      return Right(convertedAmount);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> convertToUSD({
    required double amount,
    required String fromCurrency,
  }) async {
    return await convertCurrency(
      amount: amount,
      fromCurrency: fromCurrency,
      toCurrency: 'USD',
    );
  }

  @override
  Future<Either<Failure, CurrencyRateEntity?>> getCachedExchangeRates() async {
    try {
      final cachedRates = await _localDataSource.getCachedExchangeRates();
      return Right(cachedRates?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheExchangeRates(CurrencyRateEntity rates) async {
    try {
      final model = CurrencyRateModel.fromEntity(rates);
      await _localDataSource.cacheExchangeRates(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> areCachedRatesOutdated() async {
    try {
      final cachedRates = await _localDataSource.getCachedExchangeRates();
      if (cachedRates == null) {
        return const Right(true);
      }
      return Right(cachedRates.toEntity().isOutdated);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSupportedCurrencies() async {
    return const Right(AppConstants.supportedCurrencies);
  }

  @override
  Future<Either<Failure, void>> clearCachedRates() async {
    try {
      await _localDataSource.clearCachedRates();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}