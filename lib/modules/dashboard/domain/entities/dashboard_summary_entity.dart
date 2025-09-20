import 'package:equatable/equatable.dart';

class DashboardSummaryEntity extends Equatable {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final double totalExpensesInUSD;
  final Map<String, double> expensesByCategory;
  final Map<String, double> expensesByCurrency;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String filterType;

  const DashboardSummaryEntity({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalExpensesInUSD,
    required this.expensesByCategory,
    required this.expensesByCurrency,
    required this.periodStart,
    required this.periodEnd,
    required this.filterType,
  });

  @override
  List<Object?> get props => [
        totalBalance,
        totalIncome,
        totalExpenses,
        totalExpensesInUSD,
        expensesByCategory,
        expensesByCurrency,
        periodStart,
        periodEnd,
        filterType,
      ];

  // Get percentage of expenses by category
  Map<String, double> get expensesByCategoryPercentage {
    if (totalExpensesInUSD == 0) return {};
    
    return expensesByCategory.map((category, amount) => 
        MapEntry(category, (amount / totalExpensesInUSD) * 100));
  }

  // Get top spending category
  String? get topSpendingCategory {
    if (expensesByCategory.isEmpty) return null;
    
    return expensesByCategory.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // Get average daily spending
  double get averageDailySpending {
    final days = periodEnd.difference(periodStart).inDays + 1;
    return days > 0 ? totalExpensesInUSD / days : 0;
  }

  DashboardSummaryEntity copyWith({
    double? totalBalance,
    double? totalIncome,
    double? totalExpenses,
    double? totalExpensesInUSD,
    Map<String, double>? expensesByCategory,
    Map<String, double>? expensesByCurrency,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? filterType,
  }) {
    return DashboardSummaryEntity(
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      totalExpensesInUSD: totalExpensesInUSD ?? this.totalExpensesInUSD,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
      expensesByCurrency: expensesByCurrency ?? this.expensesByCurrency,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      filterType: filterType ?? this.filterType,
    );
  }
}
