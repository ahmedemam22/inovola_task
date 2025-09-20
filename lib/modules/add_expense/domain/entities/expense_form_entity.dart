import 'package:equatable/equatable.dart';

class ExpenseFormEntity extends Equatable {
  final String? id; // For editing existing expense
  final String category;
  final double amount;
  final String currency;
  final String? description;
  final DateTime date;
  final String? receiptPath;

  const ExpenseFormEntity({
    this.id,
    required this.category,
    required this.amount,
    required this.currency,
    this.description,
    required this.date,
    this.receiptPath,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        amount,
        currency,
        description,
        date,
        receiptPath,
      ];

  ExpenseFormEntity copyWith({
    String? id,
    String? category,
    double? amount,
    String? currency,
    String? description,
    DateTime? date,
    String? receiptPath,
    bool clearReceiptPath = false,
  }) {
    return ExpenseFormEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      date: date ?? this.date,
      receiptPath: clearReceiptPath ? null : (receiptPath ?? this.receiptPath),
    );
  }

  // Validation methods
  bool get isValid {
    return category.isNotEmpty &&
           amount > 0 &&
           amount <= 999999.99 &&
           currency.isNotEmpty &&
           !date.isAfter(DateTime.now());
  }

  Map<String, String> get validationErrors {
    final errors = <String, String>{};

    if (category.isEmpty) {
      errors['category'] = 'Category is required';
    }

    if (amount <= 0) {
      errors['amount'] = 'Amount must be greater than 0';
    } else if (amount > 999999.99) {
      errors['amount'] = 'Amount cannot exceed 999,999.99';
    }

    if (currency.isEmpty) {
      errors['currency'] = 'Currency is required';
    }

    if (date.isAfter(DateTime.now())) {
      errors['date'] = 'Date cannot be in the future';
    }

    final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    if (date.isBefore(oneYearAgo)) {
      errors['date'] = 'Date cannot be more than a year ago';
    }

    if (description != null && description!.length > 200) {
      errors['description'] = 'Description cannot exceed 200 characters';
    }

    return errors;
  }
}
