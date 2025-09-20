import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../../../../shared/domain/entities/expense_entity.dart';
import '../../../../shared/data/datasources/local/expense_local_datasource.dart';
import '../../../../shared/data/models/expense_model.dart';
import '../../../../shared/domain/repositories/currency_repository.dart';
import '../../domain/entities/currency_info_entity.dart';
import '../../domain/entities/expense_form_entity.dart';
import '../../domain/repositories/add_expense_repository.dart';

@LazySingleton(as: AddExpenseRepository)
class AddExpenseRepositoryImpl implements AddExpenseRepository {
  const AddExpenseRepositoryImpl(
    this._expenseLocalDataSource,
    this._currencyRepository,
  );

  final ExpenseLocalDataSource _expenseLocalDataSource;
  final CurrencyRepository _currencyRepository;

  @override
  Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseFormEntity expenseForm) async {
    try {
      // Convert amount to USD if not already in USD
      double amountInUSD = expenseForm.amount;
      if (expenseForm.currency.toUpperCase() != 'USD') {
        final conversionResult = await _currencyRepository.convertToUSD(
          amount: expenseForm.amount,
          fromCurrency: expenseForm.currency,
        );

        if (conversionResult.isLeft()) {
          return Left(conversionResult.fold((l) => l, (r) => throw Exception()));
        }

        amountInUSD = conversionResult.fold((l) => 0.0, (r) => r);
      }

      // Create expense model
      final now = DateTime.now();
      final expenseModel = ExpenseModel(
        id: expenseForm.id ?? now.millisecondsSinceEpoch.toString(),
        category: expenseForm.category,
        amount: expenseForm.amount,
        currency: expenseForm.currency,
        amountInUSD: amountInUSD,
        description: expenseForm.description,
        date: expenseForm.date,
        receiptPath: expenseForm.receiptPath,
        createdAt: now,
        updatedAt: now,
      );

      // Save to local storage
      await _expenseLocalDataSource.addExpense(expenseModel);

      return Right(expenseModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> updateExpense(ExpenseFormEntity expenseForm) async {
    try {
      if (expenseForm.id == null) {
        return const Left(ValidationFailure('Expense ID is required for update'));
      }

      // Get existing expense
      final existingExpense = await _expenseLocalDataSource.getExpenseById(expenseForm.id!);
      if (existingExpense == null) {
        return const Left(CacheFailure('Expense not found'));
      }

      // Convert amount to USD if not already in USD
      double amountInUSD = expenseForm.amount;
      if (expenseForm.currency.toUpperCase() != 'USD') {
        final conversionResult = await _currencyRepository.convertToUSD(
          amount: expenseForm.amount,
          fromCurrency: expenseForm.currency,
        );

        if (conversionResult.isLeft()) {
          return Left(conversionResult.fold((l) => l, (r) => throw Exception()));
        }

        amountInUSD = conversionResult.fold((l) => 0.0, (r) => r);
      }

      // Update expense model
      final updatedExpenseModel = existingExpense.copyWith(
        category: expenseForm.category,
        amount: expenseForm.amount,
        currency: expenseForm.currency,
        amountInUSD: amountInUSD,
        description: expenseForm.description,
        date: expenseForm.date,
        receiptPath: expenseForm.receiptPath,
        updatedAt: DateTime.now(),
      );

      // Save to local storage
      await _expenseLocalDataSource.updateExpense(updatedExpenseModel);

      return Right(updatedExpenseModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> getExpenseById(String expenseId) async {
    try {
      final expenseModel = await _expenseLocalDataSource.getExpenseById(expenseId);
      if (expenseModel == null) {
        return const Left(CacheFailure('Expense not found'));
      }
      return Right(expenseModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CurrencyInfoEntity>>> getAvailableCurrencies() async {
    try {
      // Get exchange rates
      final ratesResult = await _currencyRepository.getExchangeRates();
      
      if (ratesResult.isRight()) {
        final rates = ratesResult.fold((l) => null, (r) => r);
        if (rates != null) {
          final currencies = rates.rates.entries.map((entry) {
            return CurrencyInfoEntity(
              code: entry.key,
              name: _getCurrencyName(entry.key),
              symbol: _getCurrencySymbol(entry.key),
              exchangeRate: entry.value,
            );
          }).toList();
          
          currencies.sort((a, b) => a.code.compareTo(b.code));
          return Right(currencies);
        }
      }

      // Fallback to default currencies
      final defaultCurrencies = AppConstants.supportedCurrencies.map((code) {
        return CurrencyInfoEntity(
          code: code,
          name: _getCurrencyName(code),
          symbol: _getCurrencySymbol(code),
          exchangeRate: 1.0, // Default rate
        );
      }).toList();

      return Right(defaultCurrencies);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    return await _currencyRepository.convertCurrency(
      amount: amount,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
  }

  @override
  Future<Either<Failure, double>> convertToUSD({
    required double amount,
    required String fromCurrency,
  }) async {
    return await _currencyRepository.convertToUSD(
      amount: amount,
      fromCurrency: fromCurrency,
    );
  }

  @override
  Either<Failure, void> validateExpenseForm(ExpenseFormEntity expenseForm) {
    final errors = expenseForm.validationErrors;
    
    if (errors.isNotEmpty) {
      final errorMessage = errors.values.first;
      return Left(ValidationFailure(errorMessage));
    }

    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> saveReceiptImage(String imagePath) async {
    try {
      // In a real app, you might want to copy the image to app's documents directory
      // For now, we'll just return the path as is
      return Right(imagePath);
    } catch (e) {
      return Left(UnexpectedFailure('Failed to save receipt image: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReceiptImage(String imagePath) async {
    try {
      // In a real app, you might want to delete the image file
      // For now, we'll just return success
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure('Failed to delete receipt image: ${e.toString()}'));
    }
  }

  String _getCurrencyName(String code) {
    const currencyNames = {
      'USD': 'US Dollar',
      'EUR': 'Euro',
      'GBP': 'British Pound',
      'JPY': 'Japanese Yen',
      'AUD': 'Australian Dollar',
      'CAD': 'Canadian Dollar',
      'CHF': 'Swiss Franc',
      'CNY': 'Chinese Yuan',
      'SEK': 'Swedish Krona',
      'NZD': 'New Zealand Dollar',
      'MXN': 'Mexican Peso',
      'SGD': 'Singapore Dollar',
      'HKD': 'Hong Kong Dollar',
      'NOK': 'Norwegian Krone',
      'TRY': 'Turkish Lira',
      'RUB': 'Russian Ruble',
      'INR': 'Indian Rupee',
      'BRL': 'Brazilian Real',
      'ZAR': 'South African Rand',
      'KRW': 'South Korean Won',
    };
    return currencyNames[code] ?? code;
  }

  String _getCurrencySymbol(String code) {
    const currencySymbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'SEK': 'kr',
      'NZD': 'NZ\$',
      'MXN': 'MX\$',
      'SGD': 'S\$',
      'HKD': 'HK\$',
      'NOK': 'kr',
      'TRY': '₺',
      'RUB': '₽',
      'INR': '₹',
      'BRL': 'R\$',
      'ZAR': 'R',
      'KRW': '₩',
    };
    return currencySymbols[code] ?? code;
  }
}