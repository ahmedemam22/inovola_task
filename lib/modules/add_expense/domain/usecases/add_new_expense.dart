import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/expense_entity.dart';
import '../entities/expense_form_entity.dart';
import '../repositories/add_expense_repository.dart';

@lazySingleton
class AddNewExpense {
  const AddNewExpense(this._repository);
  
  final AddExpenseRepository _repository;

  Future<Either<Failure, ExpenseEntity>> call(AddNewExpenseParams params) async {
    // Validate the expense form
    final validationResult = _repository.validateExpenseForm(params.expenseForm);
    if (validationResult.isLeft()) {
      return Left(validationResult.fold((l) => l, (r) => throw Exception()));
    }

    // Add the expense
    return await _repository.addExpense(params.expenseForm);
  }
}

class AddNewExpenseParams {
  final ExpenseFormEntity expenseForm;

  AddNewExpenseParams({required this.expenseForm});
}