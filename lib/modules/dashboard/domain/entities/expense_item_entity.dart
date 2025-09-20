import 'package:equatable/equatable.dart';

class ExpenseItemEntity extends Equatable {
  final String id;
  final String category;
  final double amount;
  final String currency;
  final double amountInUSD;
  final String? description;
  final DateTime date;
  final String? receiptPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExpenseItemEntity({
    required this.id,
    required this.category,
    required this.amount,
    required this.currency,
    required this.amountInUSD,
    this.description,
    required this.date,
    this.receiptPath,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        amount,
        currency,
        amountInUSD,
        description,
        date,
        receiptPath,
        createdAt,
        updatedAt,
      ];

  ExpenseItemEntity copyWith({
    String? id,
    String? category,
    double? amount,
    String? currency,
    double? amountInUSD,
    String? description,
    DateTime? date,
    String? receiptPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseItemEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      amountInUSD: amountInUSD ?? this.amountInUSD,
      description: description ?? this.description,
      date: date ?? this.date,
      receiptPath: receiptPath ?? this.receiptPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
