import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/domain/entities/pagination_entity.dart';
import '../../../domain/usecases/delete_expense_from_dashboard.dart';
import '../../../domain/usecases/get_dashboard_summary.dart';
import '../../../domain/usecases/get_dashboard_expenses.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(
    this._getDashboardExpenses,
    this._getDashboardSummary,
    this._deleteExpenseFromDashboard,
  ) : super(DashboardInitial());

  final GetDashboardExpenses _getDashboardExpenses;
  final GetDashboardSummary _getDashboardSummary;
  final DeleteExpenseFromDashboard _deleteExpenseFromDashboard;

  @override
  void add(DashboardEvent event) {
    if (!isClosed) {
      super.add(event);
    }
  }

  @postConstruct
  void init() {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<LoadExpenses>(_onLoadExpenses);
    on<LoadMoreExpenses>(_onLoadMoreExpenses);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<FilterExpenses>(_onFilterExpenses);
    on<SortExpenses>(_onSortExpenses);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      // Determine date range based on filter type
      DateTime? startDate = event.startDate;
      DateTime? endDate = event.endDate;

      if (event.filterType != null) {
        final dateRange = getDateRangeFromFilter(event.filterType!);
        startDate = dateRange['start'];
        endDate = dateRange['end'];
      }

      // Get summary
      final summaryParams = GetDashboardSummaryParams(
        startDate: startDate,
        endDate: endDate,
        category: event.category,
      );

      final summaryResult = await _getDashboardSummary(summaryParams);

      // Get expenses
      final expensesParams = GetDashboardExpensesParams(
        page: 1,
        itemsPerPage: 10,
        category: event.category,
        startDate: startDate,
        endDate: endDate,
        sortBy: 'date',
        ascending: false,
      );

      final expensesResult = await _getDashboardExpenses(expensesParams);

      if (summaryResult.isRight() && expensesResult.isRight()) {
        final summary = summaryResult.fold((l) => null, (r) => r)!;
        final expenses = expensesResult.fold((l) => null, (r) => r)!;

        emit(DashboardLoaded(
          summary: summary,
          expenses: expenses,
          currentFilter: event.filterType,
          startDate: startDate,
          endDate: endDate,
          currentCategory: event.category,
        ));
      } else {
        final failure = summaryResult.isLeft() 
            ? summaryResult.fold((l) => l, (r) => null)
            : expensesResult.fold((l) => l, (r) => null);
        
        emit(DashboardError(message: failure?.message ?? 'Unknown error occurred'));
      }
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      add(LoadDashboard(
        filterType: currentState.currentFilter,
        startDate: currentState.startDate,
        endDate: currentState.endDate,
        category: currentState.currentCategory,
      ));
    } else {
      add(const LoadDashboard());
    }
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<DashboardState> emit,
  ) async {
    // Store the current state before emitting loading state
    DashboardLoaded? currentState;
    if (state is DashboardLoaded && event.isLoadMore) {
      currentState = state as DashboardLoaded;
      emit(DashboardLoadingMore(
        summary: currentState.summary,
        expenses: currentState.expenses,
        currentFilter: currentState.currentFilter,
        startDate: currentState.startDate,
        endDate: currentState.endDate,
        currentCategory: currentState.currentCategory,
        sortBy: currentState.sortBy,
        ascending: currentState.ascending,
      ));
    }

    final params = GetDashboardExpensesParams(
      page: event.page,
      itemsPerPage: 10,
      category: event.category,
      startDate: event.startDate,
      endDate: event.endDate,
      sortBy: event.sortBy,
      ascending: event.ascending,
    );

    final result = await _getDashboardExpenses(params);

    if (result.isRight()) {
      final newExpenses = result.fold((l) => null, (r) => r)!;
      
      if (event.isLoadMore && currentState != null) {
        // Load more case - append new items to existing ones
        final allItems = [...currentState.expenses.items, ...newExpenses.items];
        
        final updatedPagination = PaginationEntity(
          items: allItems,
          currentPage: newExpenses.currentPage,
          totalPages: newExpenses.totalPages,
          totalItems: newExpenses.totalItems,
          itemsPerPage: newExpenses.itemsPerPage,
          hasNextPage: newExpenses.hasNextPage,
          hasPreviousPage: newExpenses.hasPreviousPage,
        );

        emit(currentState.copyWith(expenses: updatedPagination));
      } else if (state is DashboardLoaded) {
        // Regular load case - replace expenses
        final currentState = state as DashboardLoaded;
        emit(currentState.copyWith(
          expenses: newExpenses,
          sortBy: event.sortBy,
          ascending: event.ascending,
        ));
      }
    } else {
      final failure = result.fold((l) => l, (r) => null);
      emit(DashboardError(message: failure?.message ?? 'Failed to load expenses'));
    }
  }

  Future<void> _onLoadMoreExpenses(
    LoadMoreExpenses event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;

      if (currentState.expenses.hasNextPage) {
        add(LoadExpenses(
          page: currentState.expenses.currentPage + 1,
          category: currentState.currentCategory,
          startDate: currentState.startDate,
          endDate: currentState.endDate,
          sortBy: currentState.sortBy,
          ascending: currentState.ascending,
          isLoadMore: true,
        ));
      } else {
      }
    } else {
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final params = DeleteExpenseFromDashboardParams(expenseId: event.expenseId);
    final result = await _deleteExpenseFromDashboard(params);

    if (result.isRight()) {
      emit(const ExpenseDeleted(message: 'Expense deleted successfully'));
      // Refresh dashboard
      add(const RefreshDashboard());
    } else {
      final failure = result.fold((l) => l, (r) => null);
      emit(DashboardError(message: failure?.message ?? 'Failed to delete expense'));
    }
  }

  Future<void> _onFilterExpenses(
    FilterExpenses event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      add(LoadDashboard(
        category: event.category,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    }
  }

  Future<void> _onSortExpenses(
    SortExpenses event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      add(LoadExpenses(
        page: 1,
        category: currentState.currentCategory,
        startDate: currentState.startDate,
        endDate: currentState.endDate,
        sortBy: event.sortBy,
        ascending: event.ascending,
      ));
    }
  }

  Map<String, DateTime?> getDateRangeFromFilter(String filterType) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // Normalize to today at midnight
    
    switch (filterType.toLowerCase()) {
      case 'this month':
        return {
          'start': DateTime(now.year, now.month, 1),
          'end': DateTime(now.year, now.month + 1, 0, 23, 59, 59),
        };
      case 'last 7 days':
        return {
          'start': today.subtract(const Duration(days: 7)),
          'end': DateTime(now.year, now.month, now.day, 23, 59, 59), // End of today
        };
      case 'this year':
        return {
          'start': DateTime(now.year, 1, 1),
          'end': DateTime(now.year, 12, 31, 23, 59, 59),
        };
      case 'all time':
        return {'start': null, 'end': null}; // Show all expenses
      default:
        return {'start': null, 'end': null};
    }
  }
}