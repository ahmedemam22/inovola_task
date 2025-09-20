import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/domain/entities/pagination_entity.dart';
import '../../domain/entities/expense_item_entity.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/dashboard/dashboard_state.dart';
import 'expense_list_item.dart';
import 'empty_state.dart';

class DashboardExpensesList extends StatelessWidget {
  final DashboardState state;

  const DashboardExpensesList({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is DashboardLoaded || state is DashboardLoadingMore) {
      final expenses = _getExpenses();
      final hasMore = _hasMoreExpenses();
      final isLoadingMore = state is DashboardLoadingMore;

      if (expenses.items.isEmpty) {
        return const SliverFillRemaining(
          child: EmptyState(),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Trigger load more when approaching the end
            if (index == expenses.items.length - 1 && hasMore && !isLoadingMore) {
              // Use a small delay to avoid multiple rapid calls
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    context.read<DashboardBloc>().add(LoadMoreExpenses());
                  }
                });
              });
            }
            return _buildExpenseItem(context, index, expenses, hasMore, isLoadingMore);
          },
          childCount: expenses.items.length + (hasMore ? 1 : 0),
        ),
      );
    }

    return const SliverFillRemaining(
      child: EmptyState(),
    );
  }

  PaginationEntity<ExpenseItemEntity> _getExpenses() {
    if (state is DashboardLoaded) {
      return (state as DashboardLoaded).expenses;
    } else if (state is DashboardLoadingMore) {
      return (state as DashboardLoadingMore).expenses;
    }
    return const PaginationEntity(
      items: [],
      currentPage: 1,
      totalPages: 0,
      totalItems: 0,
      itemsPerPage: 10,
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }

  bool _hasMoreExpenses() {
    if (state is DashboardLoaded) {
      return (state as DashboardLoaded).expenses.hasNextPage;
    } else if (state is DashboardLoadingMore) {
      return (state as DashboardLoadingMore).expenses.hasNextPage;
    }
    return false;
  }

  Widget _buildExpenseItem(
    BuildContext context,
    int index,
    PaginationEntity<ExpenseItemEntity> expenses,
    bool hasMore,
    bool isLoadingMore,
  ) {
    if (index == expenses.items.length) {
      return _buildLoadMoreIndicator(context, hasMore, isLoadingMore);
    }

    final expense = expenses.items[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: ExpenseListItem(
        expense: expense,
        onTap: () => _onExpenseTap(context, expense),
      ),
    );
  }

  Widget _buildLoadMoreIndicator(
    BuildContext context,
    bool hasMore,
    bool isLoadingMore,
  ) {
    return hasMore
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: isLoadingMore
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        context.read<DashboardBloc>().add(LoadMoreExpenses());
                      },
                      child: const Text('Load More'),
                    ),
            ),
          )
        : const SizedBox.shrink();
  }

  void _onExpenseTap(BuildContext context, ExpenseItemEntity expense) {
    // TODO: Handle expense tap (e.g., edit expense)
    // Navigator.pushNamed(context, AppRoutes.editExpense, arguments: expense.id);
  }
}
