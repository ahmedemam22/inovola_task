import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/pagination_entity.dart';
import '../entities/dashboard_summary_entity.dart';
import '../entities/expense_item_entity.dart';

abstract class DashboardRepository {
  // Get dashboard summary
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  });

  // Get expenses with pagination for dashboard
  Future<Either<Failure, PaginationEntity<ExpenseItemEntity>>> getExpenses({
    int page = 1,
    int itemsPerPage = 10,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String sortBy = 'date',
    bool ascending = false,
  });

  // Delete an expense from dashboard
  Future<Either<Failure, void>> deleteExpense(String expenseId);

  // Search expenses from dashboard
  Future<Either<Failure, List<ExpenseItemEntity>>> searchExpenses(String query);

  // Get expenses by category for dashboard
  Future<Either<Failure, List<ExpenseItemEntity>>> getExpensesByCategory(
    String category, {
    DateTime? startDate,
    DateTime? endDate,
  });
}
