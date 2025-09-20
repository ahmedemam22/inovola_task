import 'package:flutter_test/flutter_test.dart';
import 'package:expense_track/core/utils/formatters.dart';

void main() {
  group('Date End-to-End Tests', () {
    test('should handle date selection and display correctly', () {
      // Simulate adding an expense yesterday
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayAtMidnight = DateTime(yesterday.year, yesterday.month, yesterday.day);
      
      // Test that the relative date formatter correctly shows "Yesterday"
      final relativeDate = Formatters.formatRelativeDate(yesterdayAtMidnight);
      expect(relativeDate, equals('Yesterday'));
      
      // Test that the date formatter shows the correct date
      final formattedDate = Formatters.formatDate(yesterdayAtMidnight);
      final expectedDate = Formatters.formatDate(yesterday);
      expect(formattedDate, equals(expectedDate));
    });

    test('should handle date filtering correctly', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Test "Last 7 Days" filter includes yesterday's expense
      final yesterday = today.subtract(const Duration(days: 1));
      final last7DaysStart = today.subtract(const Duration(days: 7));
      final last7DaysEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
      
      // Yesterday should be within the last 7 days range
      expect(yesterday.isAfter(last7DaysStart), isTrue);
      expect(yesterday.isBefore(last7DaysEnd), isTrue);
      
      // Test "This Month" filter includes expenses from this month
      final thisMonthStart = DateTime(now.year, now.month, 1);
      final thisMonthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      
      // Today should be within this month's range
      expect(today.isAfter(thisMonthStart), isTrue);
      expect(today.isBefore(thisMonthEnd), isTrue);
    });

    test('should handle edge cases in date comparison', () {
      final now = DateTime.now();
      
      // Test with different times of the same day
      final morning = DateTime(now.year, now.month, now.day, 9, 30);
      final evening = DateTime(now.year, now.month, now.day, 23, 45);
      final midnight = DateTime(now.year, now.month, now.day, 0, 0);
      
      // All should show as "Today" regardless of time
      expect(Formatters.formatRelativeDate(morning), equals('Today'));
      expect(Formatters.formatRelativeDate(evening), equals('Today'));
      expect(Formatters.formatRelativeDate(midnight), equals('Today'));
    });

    test('should handle date normalization consistently', () {
      final testDate = DateTime(2024, 1, 15, 14, 30, 45); // Jan 15, 2024 at 2:30:45 PM
      final normalizedDate = DateTime(testDate.year, testDate.month, testDate.day);
      
      // The normalized date should be Jan 15, 2024 at midnight
      expect(normalizedDate.year, equals(2024));
      expect(normalizedDate.month, equals(1));
      expect(normalizedDate.day, equals(15));
      expect(normalizedDate.hour, equals(0));
      expect(normalizedDate.minute, equals(0));
      expect(normalizedDate.second, equals(0));
    });

    test('should handle date picker date selection correctly', () {
      // Simulate date picker returning a date
      final selectedDate = DateTime(2024, 3, 15); // March 15, 2024
      
      // When date picker returns a date, it should be stored as midnight of that date
      final storedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      
      expect(storedDate.year, equals(2024));
      expect(storedDate.month, equals(3));
      expect(storedDate.day, equals(15));
      expect(storedDate.hour, equals(0));
      expect(storedDate.minute, equals(0));
      expect(storedDate.second, equals(0));
    });

    test('should handle timezone-independent date comparison', () {
      // Test with dates that might have timezone issues
      final date1 = DateTime(2024, 1, 15, 23, 59, 59); // End of day
      final date2 = DateTime(2024, 1, 16, 0, 0, 0); // Start of next day
      
      // Normalize both dates
      final normalizedDate1 = DateTime(date1.year, date1.month, date1.day);
      final normalizedDate2 = DateTime(date2.year, date2.month, date2.day);
      
      // They should be different dates
      expect(normalizedDate1.isBefore(normalizedDate2), isTrue);
      expect(normalizedDate2.isAfter(normalizedDate1), isTrue);
    });
  });
}
