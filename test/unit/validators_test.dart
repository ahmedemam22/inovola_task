import 'package:flutter_test/flutter_test.dart';
import 'package:expense_track/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('validateAmount', () {
      test('should return null for valid amounts', () {
        expect(Validators.validateAmount('100.50'), isNull);
        expect(Validators.validateAmount('0.01'), isNull);
        expect(Validators.validateAmount('999999.99'), isNull);
      });

      test('should return error for invalid amounts', () {
        expect(Validators.validateAmount(''), isNotNull);
        expect(Validators.validateAmount('abc'), isNotNull);
        expect(Validators.validateAmount('0'), isNotNull);
        expect(Validators.validateAmount('-10'), isNotNull);
        expect(Validators.validateAmount('1000000'), isNotNull);
      });
    });

    group('validateCategory', () {
      test('should return null for valid categories', () {
        expect(Validators.validateCategory('Food'), isNull);
        expect(Validators.validateCategory('Transportation'), isNull);
      });

      test('should return error for invalid categories', () {
        expect(Validators.validateCategory(''), isNotNull);
        expect(Validators.validateCategory(null), isNotNull);
      });
    });

    group('validateDate', () {
      test('should return null for valid dates', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final lastWeek = DateTime.now().subtract(const Duration(days: 7));
        
        expect(Validators.validateDate(yesterday), isNull);
        expect(Validators.validateDate(lastWeek), isNull);
      });

      test('should return error for invalid dates', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final twoYearsAgo = DateTime.now().subtract(const Duration(days: 800));
        
        expect(Validators.validateDate(null), isNotNull);
        expect(Validators.validateDate(tomorrow), isNotNull);
        expect(Validators.validateDate(twoYearsAgo), isNotNull);
      });
    });

    group('validateCurrency', () {
      test('should return null for valid currencies', () {
        expect(Validators.validateCurrency('USD'), isNull);
        expect(Validators.validateCurrency('EUR'), isNull);
        expect(Validators.validateCurrency('GBP'), isNull);
      });

      test('should return error for invalid currencies', () {
        expect(Validators.validateCurrency(''), isNotNull);
        expect(Validators.validateCurrency(null), isNotNull);
        expect(Validators.validateCurrency('US'), isNotNull);
        expect(Validators.validateCurrency('INVALID'), isNotNull);
      });
    });
  });
}
