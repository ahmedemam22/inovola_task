import 'package:equatable/equatable.dart';
import '../../../../../shared/domain/entities/expense_entity.dart';

class AddExpenseState extends Equatable {
  final bool isLoading;
  final bool isEditing;
  final String? expenseId;
  final String category;
  final String amount;
  final String currency;
  final String? selectedCurrency;
  final double? convertedAmountInUSD;
  final String description;
  final DateTime date;
  final String? receiptPath;
  final List<String> availableCurrencies;
  final Map<String, String?> fieldErrors;
  final String? generalError;
  final bool isFormValid;
  final bool isSubmitting;
  final ExpenseEntity? submittedExpense;

  AddExpenseState({
    this.isLoading = false,
    this.isEditing = false,
    this.expenseId,
    this.category = '',
    this.amount = '',
    this.currency = 'USD',
    this.selectedCurrency = 'USD',
    this.convertedAmountInUSD,
    this.description = '',
    DateTime? date,
    this.receiptPath,
    this.availableCurrencies = const [],
    this.fieldErrors = const {},
    this.generalError,
    this.isFormValid = false,
    this.isSubmitting = false,
    this.submittedExpense,
  }) : date = date ?? DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  @override
  List<Object?> get props => [
        isLoading,
        isEditing,
        expenseId,
        category,
        amount,
        currency,
        selectedCurrency,
        convertedAmountInUSD,
        description,
        date,
        receiptPath,
        availableCurrencies,
        fieldErrors,
        generalError,
        isFormValid,
        isSubmitting,
        submittedExpense,
      ];

  AddExpenseState copyWith({
    bool? isLoading,
    bool? isEditing,
    String? expenseId,
    String? category,
    String? amount,
    String? currency,
    String? selectedCurrency,
    double? convertedAmountInUSD,
    String? description,
    DateTime? date,
    String? receiptPath,
    List<String>? availableCurrencies,
    Map<String, String?>? fieldErrors,
    String? generalError,
    bool? isFormValid,
    bool? isSubmitting,
    ExpenseEntity? submittedExpense,
    bool clearReceiptPath = false,
    bool clearGeneralError = false,
    bool clearSubmittedExpense = false,
  }) {
    return AddExpenseState(
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      expenseId: expenseId ?? this.expenseId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      convertedAmountInUSD: convertedAmountInUSD ?? this.convertedAmountInUSD,
      description: description ?? this.description,
      date: date ?? this.date,
      receiptPath: clearReceiptPath ? null : (receiptPath ?? this.receiptPath),
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      generalError: clearGeneralError ? null : (generalError ?? this.generalError),
      isFormValid: isFormValid ?? this.isFormValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submittedExpense: clearSubmittedExpense ? null : (submittedExpense ?? this.submittedExpense),
    );
  }

  // Helper methods
  bool get hasCategory => category.isNotEmpty;
  bool get hasAmount => amount.isNotEmpty;
  bool get hasValidAmount {
    final parsed = double.tryParse(amount);
    return parsed != null && parsed > 0 && parsed <= 999999.99;
  }
  bool get hasCurrency => currency.isNotEmpty;
  bool get hasReceipt => receiptPath != null && receiptPath!.isNotEmpty;
  
  String? get categoryError => fieldErrors['category'];
  String? get amountError => fieldErrors['amount'];
  String? get currencyError => fieldErrors['currency'];
  String? get descriptionError => fieldErrors['description'];
  String? get dateError => fieldErrors['date'];

  // Factory constructors for common states
  factory AddExpenseState.initial() {
    return AddExpenseState(
      date: DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
      availableCurrencies: ['USD', 'EUR', 'GBP', 'JPY', 'CAD'],
    );
  }

  factory AddExpenseState.loading() {
    return AddExpenseState(isLoading: true);
  }

  factory AddExpenseState.fromExpense(ExpenseEntity expense) {
    return AddExpenseState(
      isEditing: true,
      expenseId: expense.id,
      category: expense.category,
      amount: expense.amount.toString(),
      currency: expense.currency,
      selectedCurrency: expense.currency,
      convertedAmountInUSD: expense.amountInUSD,
      description: expense.description ?? '',
      date: expense.date,
      receiptPath: expense.receiptPath,
      availableCurrencies: ['USD', 'EUR', 'GBP', 'JPY', 'CAD'],
    );
  }
}