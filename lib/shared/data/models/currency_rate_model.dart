import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/currency_rate_entity.dart';

part 'currency_rate_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class CurrencyRateModel extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'base_code')
  final String baseCurrency;

  @HiveField(1)
  @JsonKey(name: 'conversion_rates')
  final Map<String, double> rates;

  @HiveField(2)
  @JsonKey(name: 'time_last_update_unix')
  final int timestampUnix;

  @HiveField(3)
  final DateTime lastUpdated;

  CurrencyRateModel({
    required this.baseCurrency,
    required this.rates,
    required this.timestampUnix,
    required this.lastUpdated,
  });

  // Factory constructor from JSON
  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyRateModelFromJson(json);

  // Method to convert to JSON
  Map<String, dynamic> toJson() => _$CurrencyRateModelToJson(this);

  // Factory constructor from Entity
  factory CurrencyRateModel.fromEntity(CurrencyRateEntity entity) {
    return CurrencyRateModel(
      baseCurrency: entity.baseCurrency,
      rates: entity.rates,
      timestampUnix: entity.timestamp.millisecondsSinceEpoch ~/ 1000,
      lastUpdated: entity.lastUpdated,
    );
  }

  // Method to convert to Entity
  CurrencyRateEntity toEntity() {
    return CurrencyRateEntity(
      baseCurrency: baseCurrency,
      rates: rates,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestampUnix * 1000),
      lastUpdated: lastUpdated,
    );
  }

  // Factory constructor for creating a model with current timestamp
  factory CurrencyRateModel.fromApiResponse(Map<String, dynamic> json) {
    return CurrencyRateModel(
      baseCurrency: json['base_code'] as String,
      rates: (json['rates'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      timestampUnix: (json['time_last_update_unix'] as num).toInt(),
      lastUpdated: DateTime.now(),
    );
  }

  CurrencyRateModel copyWith({
    String? baseCurrency,
    Map<String, double>? rates,
    int? timestampUnix,
    DateTime? lastUpdated,
  }) {
    return CurrencyRateModel(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      rates: rates ?? this.rates,
      timestampUnix: timestampUnix ?? this.timestampUnix,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'CurrencyRateModel(baseCurrency: $baseCurrency, ratesCount: ${rates.length})';
  }
}
