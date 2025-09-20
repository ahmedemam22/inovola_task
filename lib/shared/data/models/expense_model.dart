import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/expense_entity.dart';

part 'expense_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String currency;

  @HiveField(4)
  final double amountInUSD;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final DateTime date;

  @HiveField(7)
  final String? receiptPath;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  ExpenseModel({
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

  // Factory constructor from JSON
  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  // Method to convert to JSON
  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  // Factory constructor from Entity
  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      category: entity.category,
      amount: entity.amount,
      currency: entity.currency,
      amountInUSD: entity.amountInUSD,
      description: entity.description,
      date: entity.date,
      receiptPath: entity.receiptPath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Method to convert to Entity
  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      category: category,
      amount: amount,
      currency: currency,
      amountInUSD: amountInUSD,
      description: description,
      date: date,
      receiptPath: receiptPath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ExpenseModel copyWith({
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
    return ExpenseModel(
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

  @override
  String toString() {
    return 'ExpenseModel(id: $id, category: $category, amount: $amount, currency: $currency)';
  }
}
