import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../shared/domain/entities/pagination_entity.dart';
import '../../../../shared/data/datasources/local/expense_local_datasource.dart';
import '../../../../shared/data/models/expense_model.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/expense_item_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._expenseLocalDataSource);

  final ExpenseLocalDataSource _expenseLocalDataSource;

  @override
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  }) async {
    try {
      List<ExpenseModel> expenses = await _expenseLocalDataSource.getAllExpenses();

      // Apply filters
      if (category != null && category.isNotEmpty) {
        expenses = expenses.where((e) => e.category == category).toList();
      }

      if (startDate != null && endDate != null) {
        expenses = expenses.where((e) {
          return e.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
                 e.date.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();
      }

      // Calculate summary
      double totalExpensesInUSD = expenses.fold(0, (sum, e) => sum + e.amountInUSD);
      double totalExpenses = expenses.fold(0, (sum, e) => sum + e.amount);

      // Group by category
      Map<String, double> expensesByCategory = {};
      for (final expense in expenses) {
        expensesByCategory[expense.category] = 
            (expensesByCategory[expense.category] ?? 0) + expense.amountInUSD;
      }

      // Group by currency
      Map<String, double> expensesByCurrency = {};
      for (final expense in expenses) {
        expensesByCurrency[expense.currency] = 
            (expensesByCurrency[expense.currency] ?? 0) + expense.amount;
      }

      final summary = DashboardSummaryEntity(
        totalBalance: 10000.0 - totalExpensesInUSD, // Mock income
        totalIncome: 10000.0, // Mock income
        totalExpenses: totalExpenses,
        totalExpensesInUSD: totalExpensesInUSD,
        expensesByCategory: expensesByCategory,
        expensesByCurrency: expensesByCurrency,
        periodStart: startDate ?? DateTime.now().subtract(const Duration(days: 30)),
        periodEnd: endDate ?? DateTime.now(),
        filterType: category ?? 'All',
      );

      return Right(summary);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginationEntity<ExpenseItemEntity>>> getExpenses({
    int page = 1,
    int itemsPerPage = 10,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String sortBy = 'date',
    bool ascending = false,
  }) async {
    try {
      List<ExpenseModel> expenses = await _expenseLocalDataSource.getAllExpenses();

      // Apply filters
      if (category != null && category.isNotEmpty) {
        expenses = expenses.where((e) => e.category == category).toList();
      }

      if (startDate != null && endDate != null) {
        expenses = expenses.where((e) {
          return e.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
                 e.date.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();
      }

      // Apply sorting
      expenses.sort((a, b) {
        int comparison;
        switch (sortBy.toLowerCase()) {
          case 'amount':
            comparison = a.amountInUSD.compareTo(b.amountInUSD);
            break;
          case 'category':
            comparison = a.category.compareTo(b.category);
            break;
          case 'date':
          default:
            comparison = a.date.compareTo(b.date);
            break;
        }
        return ascending ? comparison : -comparison;
      });

      // Convert to expense item entities
      final expenseEntities = expenses.map((e) => ExpenseItemEntity(
        id: e.id,
        category: e.category,
        amount: e.amount,
        currency: e.currency,
        amountInUSD: e.amountInUSD,
        description: e.description,
        date: e.date,
        receiptPath: e.receiptPath,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      )).toList();

      // Create pagination
      final pagination = PaginationEntity.fromList(expenseEntities, page, itemsPerPage);
      

      return Right(pagination);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String expenseId) async {
    try {
      await _expenseLocalDataSource.deleteExpense(expenseId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseItemEntity>>> searchExpenses(String query) async {
    try {
      final expenses = await _expenseLocalDataSource.getAllExpenses();
      final filteredExpenses = expenses.where((expense) {
        return expense.category.toLowerCase().contains(query.toLowerCase()) ||
               (expense.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();

      final entities = filteredExpenses.map((e) => ExpenseItemEntity(
        id: e.id,
        category: e.category,
        amount: e.amount,
        currency: e.currency,
        amountInUSD: e.amountInUSD,
        description: e.description,
        date: e.date,
        receiptPath: e.receiptPath,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      )).toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseItemEntity>>> getExpensesByCategory(
    String category, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      List<ExpenseModel> expenses = await _expenseLocalDataSource.getExpensesByCategory(category);

      if (startDate != null && endDate != null) {
        expenses = expenses.where((e) {
          return e.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
                 e.date.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();
      }

      final entities = expenses.map((e) => ExpenseItemEntity(
        id: e.id,
        category: e.category,
        amount: e.amount,
        currency: e.currency,
        amountInUSD: e.amountInUSD,
        description: e.description,
        date: e.date,
        receiptPath: e.receiptPath,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      )).toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}