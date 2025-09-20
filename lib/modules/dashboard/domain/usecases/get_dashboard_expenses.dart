import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/pagination_entity.dart';
import '../entities/expense_item_entity.dart';
import '../repositories/dashboard_repository.dart';

@lazySingleton
class GetDashboardExpenses {
  const GetDashboardExpenses(this._repository);
  
  final DashboardRepository _repository;

  Future<Either<Failure, PaginationEntity<ExpenseItemEntity>>> call(
    GetDashboardExpensesParams params,
  ) async {
    return await _repository.getExpenses(
      page: params.page,
      itemsPerPage: params.itemsPerPage,
      category: params.category,
      startDate: params.startDate,
      endDate: params.endDate,
      sortBy: params.sortBy,
      ascending: params.ascending,
    );
  }
}

class GetDashboardExpensesParams {
  final int page;
  final int itemsPerPage;
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final String sortBy;
  final bool ascending;

  GetDashboardExpensesParams({
    this.page = 1,
    this.itemsPerPage = 10,
    this.category,
    this.startDate,
    this.endDate,
    this.sortBy = 'date',
    this.ascending = false,
  });

  GetDashboardExpensesParams copyWith({
    int? page,
    int? itemsPerPage,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool? ascending,
  }) {
    return GetDashboardExpensesParams(
      page: page ?? this.page,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }
}