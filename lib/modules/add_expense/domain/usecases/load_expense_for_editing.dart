import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/expense_entity.dart';
import '../repositories/add_expense_repository.dart';

@lazySingleton
class LoadExpenseForEditing {
  const LoadExpenseForEditing(this._repository);
  
  final AddExpenseRepository _repository;

  Future<Either<Failure, ExpenseEntity>> call(LoadExpenseForEditingParams params) async {
    if (params.expenseId.isEmpty) {
      return const Left(ValidationFailure('Expense ID is required'));
    }

    return await _repository.getExpenseById(params.expenseId);
  }
}

class LoadExpenseForEditingParams {
  final String expenseId;

  LoadExpenseForEditingParams({required this.expenseId});
}