import 'package:injectable/injectable.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String expenseId);
  Future<ExpenseModel?> getExpenseById(String expenseId);
  Future<List<ExpenseModel>> getAllExpenses();
  Future<List<ExpenseModel>> getExpensesByCategory(String category);
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime startDate, DateTime endDate);
  Future<void> clearAllExpenses();
}

@LazySingleton(as: ExpenseLocalDataSource)
class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  const ExpenseLocalDataSourceImpl(this._hiveService);
  
  final HiveService _hiveService;

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await _hiveService.put(AppConstants.expensesBoxKey, expense.id, expense);
    } catch (e) {
      throw CacheException(message: 'Failed to add expense: ${e.toString()}');
    }
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      final exists = await _hiveService.containsKey(AppConstants.expensesBoxKey, expense.id);
      if (!exists) {
        throw CacheException(message: 'Expense not found');
      }
      
      await _hiveService.put(AppConstants.expensesBoxKey, expense.id, expense);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to update expense: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      final exists = await _hiveService.containsKey(AppConstants.expensesBoxKey, expenseId);
      if (!exists) {
        throw CacheException(message: 'Expense not found');
      }
      
      await _hiveService.delete(AppConstants.expensesBoxKey, expenseId);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to delete expense: ${e.toString()}');
    }
  }

  @override
  Future<ExpenseModel?> getExpenseById(String expenseId) async {
    try {
      return await _hiveService.get<ExpenseModel>(AppConstants.expensesBoxKey, expenseId);
    } catch (e) {
      throw CacheException(message: 'Failed to get expense: ${e.toString()}');
    }
  }

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    try {
      return await _hiveService.getAll<ExpenseModel>(AppConstants.expensesBoxKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get expenses: ${e.toString()}');
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    try {
      final allExpenses = await getAllExpenses();
      return allExpenses.where((expense) => expense.category == category).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get expenses by category: ${e.toString()}');
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final allExpenses = await getAllExpenses();
      return allExpenses.where((expense) {
        return expense.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
               expense.date.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get expenses by date range: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAllExpenses() async {
    try {
      await _hiveService.clearBox(AppConstants.expensesBoxKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear expenses: ${e.toString()}');
    }
  }
}