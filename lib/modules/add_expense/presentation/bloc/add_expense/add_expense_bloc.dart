import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/expense_form_entity.dart';
import '../../../domain/usecases/add_new_expense.dart';
import '../../../domain/usecases/get_currencies.dart';
import '../../../domain/usecases/load_expense_for_editing.dart';
import '../../../domain/usecases/update_existing_expense.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';

@injectable
class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  AddExpenseBloc(
    this._addNewExpense,
    this._updateExistingExpense,
    this._getCurrencies,
    this._loadExpenseForEditing,
  ) : super(AddExpenseState.initial());

  final AddNewExpense _addNewExpense;
  final UpdateExistingExpense _updateExistingExpense;
  final GetCurrencies _getCurrencies;
  final LoadExpenseForEditing _loadExpenseForEditing;

  @postConstruct
  void init() {
    on<LoadAddExpenseScreen>(_onLoadAddExpenseScreen);
    on<CategoryChanged>(_onCategoryChanged);
    on<AmountChanged>(_onAmountChanged);
    on<CurrencyChanged>(_onCurrencyChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<DateChanged>(_onDateChanged);
    on<ReceiptAdded>(_onReceiptAdded);
    on<ReceiptRemoved>(_onReceiptRemoved);
    on<LoadCurrencies>(_onLoadCurrencies);
    on<ConvertCurrency>(_onConvertCurrency);
    on<ValidateForm>(_onValidateForm);
    on<SubmitExpense>(_onSubmitExpense);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onLoadAddExpenseScreen(
    LoadAddExpenseScreen event,
    Emitter<AddExpenseState> emit,
  ) async {
    emit(AddExpenseState.loading());

    try {
      // Load available currencies
      final currenciesResult = await _getCurrencies();

      List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD'];
      if (currenciesResult.isRight()) {
        final currencyInfoList = currenciesResult.fold((l) => null, (r) => r);
        if (currencyInfoList != null) {
          currencies = currencyInfoList.map((c) => c.code).toList();
          currencies.sort();
        }
      }

      // If editing, load the expense
      if (event.expenseId != null) {
        final expenseResult = await _loadExpenseForEditing(
          LoadExpenseForEditingParams(expenseId: event.expenseId!),
        );

        if (expenseResult.isRight()) {
          final expense = expenseResult.fold((l) => null, (r) => r)!;
          emit(AddExpenseState.fromExpense(expense).copyWith(
            availableCurrencies: currencies,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            generalError: 'Failed to load expense for editing',
            availableCurrencies: currencies,
          ));
        }
      } else {
        emit(state.copyWith(
          isLoading: false,
          availableCurrencies: currencies,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        generalError: e.toString(),
      ));
    }
  }

  void _onCategoryChanged(
    CategoryChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(
      category: event.category,
      clearGeneralError: true,
    ));
    add(const ValidateForm());
  }

  void _onAmountChanged(
    AmountChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(
      amount: event.amount,
      clearGeneralError: true,
    ));
    
    // Trigger currency conversion if amount is not empty and currency is not USD
    if (event.amount.isNotEmpty && state.selectedCurrency != null && state.selectedCurrency != 'USD') {
      add(const ConvertCurrency());
    } else if (state.selectedCurrency == 'USD' || event.amount.isEmpty) {
      // Clear converted amount if USD is selected or amount is empty
      emit(state.copyWith(
        convertedAmountInUSD: null,
      ));
    }
    
    add(const ValidateForm());
  }

  void _onCurrencyChanged(
    CurrencyChanged event,
    Emitter<AddExpenseState> emit,
  ) {

    // First emit the currency change
    emit(state.copyWith(
      selectedCurrency: event.currency,
      clearGeneralError: true,
    ));
    
    // Then trigger currency conversion if needed
    if (state.amount.isNotEmpty && event.currency != 'USD') {
      add(const ConvertCurrency());
    } else if (event.currency == 'USD') {
      // Clear converted amount if USD is selected
      emit(state.copyWith(
        convertedAmountInUSD: null,
      ));
    }
    
    add(const ValidateForm());
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(
      description: event.description,
      clearGeneralError: true,
    ));
    add(const ValidateForm());
  }

  void _onDateChanged(
    DateChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
      clearGeneralError: true,
    ));
    add(const ValidateForm());
  }

  void _onReceiptAdded(
    ReceiptAdded event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(
      receiptPath: event.receiptPath,
      clearGeneralError: true,
    ));
  }

  void _onReceiptRemoved(
    ReceiptRemoved event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(state.copyWith(
      clearReceiptPath: true,
      clearGeneralError: true,
    ));
  }

  Future<void> _onLoadCurrencies(
    LoadCurrencies event,
    Emitter<AddExpenseState> emit,
  ) async {
    try {
      final result = await _getCurrencies();

      if (result.isRight()) {
        final currencyInfoList = result.fold((l) => null, (r) => r);
        if (currencyInfoList != null) {
          final currencies = currencyInfoList.map((c) => c.code).toList();
          currencies.sort();
          emit(state.copyWith(availableCurrencies: currencies));
        }
      }
    } catch (e) {
      // Silently fail, use default currencies
    }
  }

  Future<void> _onConvertCurrency(
    ConvertCurrency event,
    Emitter<AddExpenseState> emit,
  ) async {

    if (state.amount.isEmpty || 
        state.selectedCurrency == null || 
        state.selectedCurrency == 'USD') {
      return;
    }

    try {
      final amount = double.tryParse(state.amount);
      if (amount == null) {
        return;
      }

      // For now, use a simple mock conversion for testing
      // TODO: Replace with actual API call
      double convertedAmount;
      switch (state.selectedCurrency!) {
        case 'EUR':
          convertedAmount = amount * 1.08; // Approximate EUR to USD
          break;
        case 'GBP':
          convertedAmount = amount * 1.27; // Approximate GBP to USD
          break;
        case 'JPY':
          convertedAmount = amount * 0.0067; // Approximate JPY to USD
          break;
        case 'CAD':
          convertedAmount = amount * 0.74; // Approximate CAD to USD
          break;
        case 'AUD':
          convertedAmount = amount * 0.65; // Approximate AUD to USD
          break;
        default:
          convertedAmount = amount; // Default to same amount
      }

      emit(state.copyWith(
        convertedAmountInUSD: convertedAmount,
      ));
    } catch (e) {
      // Silently fail, conversion will not be shown
    }
  }

  void _onValidateForm(
    ValidateForm event,
    Emitter<AddExpenseState> emit,
  ) {
    final expenseForm = ExpenseFormEntity(
      id: state.expenseId,
      category: state.category,
      amount: double.tryParse(state.amount) ?? 0,
      currency: state.currency,
      description: state.description.isEmpty ? null : state.description,
      date: state.date,
      receiptPath: state.receiptPath,
    );

    final errors = expenseForm.validationErrors;
    final isValid = errors.isEmpty;

    emit(state.copyWith(
      fieldErrors: errors,
      isFormValid: isValid,
    ));
  }

  Future<void> _onSubmitExpense(
    SubmitExpense event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (!state.isFormValid) {
      add(const ValidateForm());
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearGeneralError: true));

    try {
      final originalAmount = double.parse(state.amount);
      
      // Use converted USD amount if currency is not USD, otherwise use original amount
      final amountToSave = state.selectedCurrency != 'USD' && state.convertedAmountInUSD != null
          ? state.convertedAmountInUSD!
          : originalAmount;
      
      // Save with USD currency when converted, otherwise use selected currency
      final currencyToSave = state.selectedCurrency != 'USD' && state.convertedAmountInUSD != null
          ? 'USD'
          : (state.selectedCurrency ?? state.currency);


      final expenseForm = ExpenseFormEntity(
        id: state.expenseId,
        category: state.category,
        amount: amountToSave,
        currency: currencyToSave,
        description: state.description.isEmpty ? null : state.description,
        date: state.date,
        receiptPath: state.receiptPath,
      );

      if (state.isEditing && state.expenseId != null) {
        // Update existing expense
        final params = UpdateExistingExpenseParams(expenseForm: expenseForm);
        final result = await _updateExistingExpense(params);

        if (result.isRight()) {
          final expense = result.fold((l) => null, (r) => r)!;
          emit(state.copyWith(
            isSubmitting: false,
            submittedExpense: expense,
          ));
        } else {
          final failure = result.fold((l) => l, (r) => null);
          emit(state.copyWith(
            isSubmitting: false,
            generalError: failure?.message ?? 'Failed to update expense',
          ));
        }
      } else {
        // Add new expense
        final params = AddNewExpenseParams(expenseForm: expenseForm);
        final result = await _addNewExpense(params);

        if (result.isRight()) {
          final expense = result.fold((l) => null, (r) => r)!;
          emit(state.copyWith(
            isSubmitting: false,
            submittedExpense: expense,
          ));
        } else {
          final failure = result.fold((l) => l, (r) => null);
          emit(state.copyWith(
            isSubmitting: false,
            generalError: failure?.message ?? 'Failed to add expense',
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        generalError: e.toString(),
      ));
    }
  }

  void _onResetForm(
    ResetForm event,
    Emitter<AddExpenseState> emit,
  ) {
    emit(AddExpenseState.initial().copyWith(
      availableCurrencies: state.availableCurrencies,
    ));
  }
}