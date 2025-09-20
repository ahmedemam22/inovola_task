import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../bloc/dashboard/dashboard_state.dart';
import 'balance_card.dart';

class DashboardBalanceCard extends StatelessWidget {
  final DashboardState state;

  const DashboardBalanceCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is DashboardLoaded || state is DashboardLoadingMore) {
      final summary = _getSummary();
      return BalanceCard(summary: summary);
    }
    return const SizedBox.shrink();
  }

  DashboardSummaryEntity _getSummary() {
    if (state is DashboardLoaded) {
      return (state as DashboardLoaded).summary;
    } else if (state is DashboardLoadingMore) {
      return (state as DashboardLoadingMore).summary;
    }
    
    // Return default empty summary
    return DashboardSummaryEntity(
      totalBalance: 0.0,
      totalIncome: 0.0,
      totalExpenses: 0.0,
      totalExpensesInUSD: 0.0,
      expensesByCategory: {},
      expensesByCurrency: {},
      periodStart: DateTime.now().subtract(const Duration(days: 30)),
      periodEnd: DateTime.now(),
      filterType: 'This Month',
    );
  }
}
