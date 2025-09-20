import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  final String? filterType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? category;

  const LoadDashboard({
    this.filterType,
    this.startDate,
    this.endDate,
    this.category,
  });

  @override
  List<Object?> get props => [filterType, startDate, endDate, category];
}

class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

class LoadExpenses extends DashboardEvent {
  final int page;
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final String sortBy;
  final bool ascending;
  final bool isLoadMore;

  const LoadExpenses({
    this.page = 1,
    this.category,
    this.startDate,
    this.endDate,
    this.sortBy = 'date',
    this.ascending = false,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [
        page,
        category,
        startDate,
        endDate,
        sortBy,
        ascending,
        isLoadMore,
      ];
}

class LoadMoreExpenses extends DashboardEvent {
  const LoadMoreExpenses();
}

class DeleteExpenseEvent extends DashboardEvent {
  final String expenseId;

  const DeleteExpenseEvent({required this.expenseId});

  @override
  List<Object> get props => [expenseId];
}

class FilterExpenses extends DashboardEvent {
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterExpenses({
    this.category,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [category, startDate, endDate];
}

class SortExpenses extends DashboardEvent {
  final String sortBy;
  final bool ascending;

  const SortExpenses({
    required this.sortBy,
    required this.ascending,
  });

  @override
  List<Object> get props => [sortBy, ascending];
}

class SearchExpenses extends DashboardEvent {
  final String query;

  const SearchExpenses({required this.query});

  @override
  List<Object> get props => [query];
}
