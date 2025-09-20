import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/expense_entity.dart';
import '../entities/currency_info_entity.dart';
import '../entities/expense_form_entity.dart';

abstract class AddExpenseRepository {
  // Add a new expense
  Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseFormEntity expenseForm);

  // Update an existing expense
  Future<Either<Failure, ExpenseEntity>> updateExpense(ExpenseFormEntity expenseForm);

  // Get expense by ID for editing
  Future<Either<Failure, ExpenseEntity>> getExpenseById(String expenseId);

  // Get available currencies
  Future<Either<Failure, List<CurrencyInfoEntity>>> getAvailableCurrencies();

  // Convert currency amount
  Future<Either<Failure, double>> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  });

  // Convert any currency to USD
  Future<Either<Failure, double>> convertToUSD({
    required double amount,
    required String fromCurrency,
  });

  // Validate expense form
  Either<Failure, void> validateExpenseForm(ExpenseFormEntity expenseForm);

  // Save receipt image
  Future<Either<Failure, String>> saveReceiptImage(String imagePath);

  // Delete receipt image
  Future<Either<Failure, void>> deleteReceiptImage(String imagePath);
}
