import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/currency_info_entity.dart';
import '../repositories/add_expense_repository.dart';

@lazySingleton
class GetCurrencies {
  const GetCurrencies(this._repository);
  
  final AddExpenseRepository _repository;

  Future<Either<Failure, List<CurrencyInfoEntity>>> call() async {
    return await _repository.getAvailableCurrencies();
  }
}