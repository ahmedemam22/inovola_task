import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/expense_entity.dart';
import '../entities/expense_form_entity.dart';
import '../repositories/add_expense_repository.dart';

@lazySingleton
class UpdateExistingExpense {
  const UpdateExistingExpense(this._repository);
  
  final AddExpenseRepository _repository;

  Future<Either<Failure, ExpenseEntity>> call(UpdateExistingExpenseParams params) async {
    // Validate the expense form
    final validationResult = _repository.validateExpenseForm(params.expenseForm);
    if (validationResult.isLeft()) {
      return Left(validationResult.fold((l) => l, (r) => throw Exception()));
    }

    // Ensure the expense form has an ID for updating
    if (params.expenseForm.id == null || params.expenseForm.id!.isEmpty) {
      return const Left(ValidationFailure('Expense ID is required for updating'));
    }

    // Update the expense
    return await _repository.updateExpense(params.expenseForm);
  }
}

class UpdateExistingExpenseParams {
  final ExpenseFormEntity expenseForm;

  UpdateExistingExpenseParams({required this.expenseForm});
}