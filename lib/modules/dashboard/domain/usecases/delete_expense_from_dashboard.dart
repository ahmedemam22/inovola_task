import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/dashboard_repository.dart';

@lazySingleton
class DeleteExpenseFromDashboard {
  const DeleteExpenseFromDashboard(this._repository);
  
  final DashboardRepository _repository;

  Future<Either<Failure, void>> call(DeleteExpenseFromDashboardParams params) async {
    if (params.expenseId.isEmpty) {
      return const Left(ValidationFailure('Expense ID is required'));
    }

    return await _repository.deleteExpense(params.expenseId);
  }
}

class DeleteExpenseFromDashboardParams {
  final String expenseId;

  DeleteExpenseFromDashboardParams({required this.expenseId});
}