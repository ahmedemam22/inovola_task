import 'package:equatable/equatable.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddExpenseScreen extends AddExpenseEvent {
  final String? expenseId; // For editing existing expense

  const LoadAddExpenseScreen({this.expenseId});

  @override
  List<Object?> get props => [expenseId];
}

class CategoryChanged extends AddExpenseEvent {
  final String category;

  const CategoryChanged({required this.category});

  @override
  List<Object> get props => [category];
}

class AmountChanged extends AddExpenseEvent {
  final String amount;

  const AmountChanged({required this.amount});

  @override
  List<Object> get props => [amount];
}

class CurrencyChanged extends AddExpenseEvent {
  final String currency;

  const CurrencyChanged({required this.currency});

  @override
  List<Object> get props => [currency];
}

class DescriptionChanged extends AddExpenseEvent {
  final String description;

  const DescriptionChanged({required this.description});

  @override
  List<Object> get props => [description];
}

class DateChanged extends AddExpenseEvent {
  final DateTime date;

  const DateChanged({required this.date});

  @override
  List<Object> get props => [date];
}

class ReceiptAdded extends AddExpenseEvent {
  final String receiptPath;

  const ReceiptAdded({required this.receiptPath});

  @override
  List<Object> get props => [receiptPath];
}

class ReceiptRemoved extends AddExpenseEvent {
  const ReceiptRemoved();
}

class LoadCurrencies extends AddExpenseEvent {
  const LoadCurrencies();
}

class ConvertCurrency extends AddExpenseEvent {
  const ConvertCurrency();
}

class ValidateForm extends AddExpenseEvent {
  const ValidateForm();
}

class SubmitExpense extends AddExpenseEvent {
  const SubmitExpense();
}

class ResetForm extends AddExpenseEvent {
  const ResetForm();
}
