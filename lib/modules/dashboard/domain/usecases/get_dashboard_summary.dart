import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_summary_entity.dart';
import '../repositories/dashboard_repository.dart';

@lazySingleton
class GetDashboardSummary {
  const GetDashboardSummary(this._repository);
  
  final DashboardRepository _repository;

  Future<Either<Failure, DashboardSummaryEntity>> call(
    GetDashboardSummaryParams params,
  ) async {
    return await _repository.getDashboardSummary(
      startDate: params.startDate,
      endDate: params.endDate,
      category: params.category,
    );
  }
}

class GetDashboardSummaryParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? category;

  GetDashboardSummaryParams({
    this.startDate,
    this.endDate,
    this.category,
  });

  // Helper factory methods for common time periods
  factory GetDashboardSummaryParams.thisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    
    return GetDashboardSummaryParams(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );
  }

  factory GetDashboardSummaryParams.lastSevenDays() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    
    return GetDashboardSummaryParams(
      startDate: sevenDaysAgo,
      endDate: now,
    );
  }

  factory GetDashboardSummaryParams.lastThirtyDays() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    return GetDashboardSummaryParams(
      startDate: thirtyDaysAgo,
      endDate: now,
    );
  }

  factory GetDashboardSummaryParams.thisYear() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);
    
    return GetDashboardSummaryParams(
      startDate: startOfYear,
      endDate: endOfYear,
    );
  }

  factory GetDashboardSummaryParams.allTime() {
    return GetDashboardSummaryParams();
  }

  GetDashboardSummaryParams copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  }) {
    return GetDashboardSummaryParams(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
    );
  }
}