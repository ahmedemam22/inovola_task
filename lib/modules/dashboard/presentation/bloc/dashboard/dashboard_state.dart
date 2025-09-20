import 'package:equatable/equatable.dart';
import '../../../domain/entities/expense_item_entity.dart';
import '../../../domain/entities/dashboard_summary_entity.dart';
import '../../../../../shared/domain/entities/pagination_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardSummaryEntity summary;
  final PaginationEntity<ExpenseItemEntity> expenses;
  final String? currentFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? currentCategory;
  final String sortBy;
  final bool ascending;

  const DashboardLoaded({
    required this.summary,
    required this.expenses,
    this.currentFilter,
    this.startDate,
    this.endDate,
    this.currentCategory,
    this.sortBy = 'date',
    this.ascending = false,
  });

  @override
  List<Object?> get props => [
        summary,
        expenses,
        currentFilter,
        startDate,
        endDate,
        currentCategory,
        sortBy,
        ascending,
      ];

  DashboardLoaded copyWith({
    DashboardSummaryEntity? summary,
    PaginationEntity<ExpenseItemEntity>? expenses,
    String? currentFilter,
    DateTime? startDate,
    DateTime? endDate,
    String? currentCategory,
    String? sortBy,
    bool? ascending,
  }) {
    return DashboardLoaded(
      summary: summary ?? this.summary,
      expenses: expenses ?? this.expenses,
      currentFilter: currentFilter ?? this.currentFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentCategory: currentCategory ?? this.currentCategory,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }
}

class DashboardLoadingMore extends DashboardState {
  final DashboardSummaryEntity summary;
  final PaginationEntity<ExpenseItemEntity> expenses;
  final String? currentFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? currentCategory;
  final String sortBy;
  final bool ascending;

  const DashboardLoadingMore({
    required this.summary,
    required this.expenses,
    this.currentFilter,
    this.startDate,
    this.endDate,
    this.currentCategory,
    this.sortBy = 'date',
    this.ascending = false,
  });

  @override
  List<Object?> get props => [
        summary,
        expenses,
        currentFilter,
        startDate,
        endDate,
        currentCategory,
        sortBy,
        ascending,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}

class ExpenseDeleted extends DashboardState {
  final String message;

  const ExpenseDeleted({required this.message});

  @override
  List<Object> get props => [message];
}