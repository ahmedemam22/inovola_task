import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../models/base_response.dart';
import '../../models/currency_rate_model.dart';

abstract class CurrencyRemoteDataSource {
  Future<BaseResponse<CurrencyRateModel>> getExchangeRates({String baseCurrency = 'USD'});
}

@LazySingleton(as: CurrencyRemoteDataSource)
class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  const CurrencyRemoteDataSourceImpl(this._dio);
  
  final Dio _dio;

  @override
  Future<BaseResponse<CurrencyRateModel>> getExchangeRates({String baseCurrency = 'USD'}) async {
    final response = await _dio.get('/$baseCurrency');
    
    return BaseResponse.fromCurrencyApi(
      response.data,
      (data) => CurrencyRateModel.fromApiResponse(data as Map<String, dynamic>),
    );
  }
}