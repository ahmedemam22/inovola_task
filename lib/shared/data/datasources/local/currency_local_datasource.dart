import 'package:injectable/injectable.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../../models/currency_rate_model.dart';

abstract class CurrencyLocalDataSource {
  Future<void> cacheExchangeRates(CurrencyRateModel rates);
  Future<CurrencyRateModel?> getCachedExchangeRates();
  Future<void> clearCachedRates();
}

@LazySingleton(as: CurrencyLocalDataSource)
class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  const CurrencyLocalDataSourceImpl(this._hiveService);
  
  final HiveService _hiveService;
  static const String _ratesKey = 'current_rates';

  @override
  Future<void> cacheExchangeRates(CurrencyRateModel rates) async {
    try {
      await _hiveService.put(AppConstants.currencyRatesBoxKey, _ratesKey, rates);
    } catch (e) {
      throw CacheException(message: 'Failed to cache exchange rates: ${e.toString()}');
    }
  }

  @override
  Future<CurrencyRateModel?> getCachedExchangeRates() async {
    try {
      return await _hiveService.get<CurrencyRateModel>(AppConstants.currencyRatesBoxKey, _ratesKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get cached exchange rates: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCachedRates() async {
    try {
      await _hiveService.delete(AppConstants.currencyRatesBoxKey, _ratesKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached rates: ${e.toString()}');
    }
  }
}