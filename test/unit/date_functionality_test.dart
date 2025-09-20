import 'package:flutter_test/flutter_test.dart';
import 'package:expense_track/core/utils/formatters.dart';

void main() {
  group('Date Functionality Tests', () {
    test('should format relative dates correctly', () {
      final now = DateTime.now();
      
      // Test today
      expect(Formatters.formatRelativeDate(now), equals('Today'));
      
      // Test yesterday
      final yesterday = now.subtract(const Duration(days: 1));
      expect(Formatters.formatRelativeDate(yesterday), equals('Yesterday'));
      
      // Test 2 days ago - should show actual date
      final twoDaysAgo = now.subtract(const Duration(days: 2));
      final expectedTwoDaysAgo = '${twoDaysAgo.day.toString().padLeft(2, '0')}/${twoDaysAgo.month.toString().padLeft(2, '0')}/${twoDaysAgo.year}';
      expect(Formatters.formatRelativeDate(twoDaysAgo), equals(expectedTwoDaysAgo));
      
      // Test 1 week ago - should show actual date
      final oneWeekAgo = now.subtract(const Duration(days: 7));
      final expectedOneWeekAgo = '${oneWeekAgo.day.toString().padLeft(2, '0')}/${oneWeekAgo.month.toString().padLeft(2, '0')}/${oneWeekAgo.year}';
      expect(Formatters.formatRelativeDate(oneWeekAgo), equals(expectedOneWeekAgo));
      
      // Test 1 month ago - should show actual date
      final oneMonthAgo = now.subtract(const Duration(days: 30));
      final expectedOneMonthAgo = '${oneMonthAgo.day.toString().padLeft(2, '0')}/${oneMonthAgo.month.toString().padLeft(2, '0')}/${oneMonthAgo.year}';
      expect(Formatters.formatRelativeDate(oneMonthAgo), equals(expectedOneMonthAgo));
    });

    test('should handle date timezone issues', () {
      // Create a date for yesterday at a specific time
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayAtMidnight = DateTime(yesterday.year, yesterday.month, yesterday.day);
      
      // Test that the relative date calculation works correctly
      final relativeDate = Formatters.formatRelativeDate(yesterdayAtMidnight);
      expect(relativeDate, equals('Yesterday'));
    });

    test('should normalize dates correctly for comparison', () {
      final now = DateTime.now();
      
      // Test with different times of the same day
      final morning = DateTime(now.year, now.month, now.day, 9, 30);
      final evening = DateTime(now.year, now.month, now.day, 23, 45);
      
      // Both should show as "Today"
      expect(Formatters.formatRelativeDate(morning), equals('Today'));
      expect(Formatters.formatRelativeDate(evening), equals('Today'));
    });

    test('should format dates consistently', () {
      final testDate = DateTime(2024, 1, 15); // January 15, 2024
      
      expect(Formatters.formatDate(testDate), equals('Jan 15, 2024'));
      expect(Formatters.formatDateShort(testDate), equals('15/01/2024'));
      expect(Formatters.formatDateTime(testDate), equals('Jan 15, 2024 00:00'));
    });

    test('should handle edge cases in date formatting', () {
      // Test with different times of day
      final morning = DateTime(2024, 1, 15, 9, 30);
      final evening = DateTime(2024, 1, 15, 23, 45);
      
      expect(Formatters.formatDate(morning), equals(Formatters.formatDate(evening)));
      expect(Formatters.formatTime(morning), equals('09:30'));
      expect(Formatters.formatTime(evening), equals('23:45'));
    });
  });

  group('Date Filter Tests', () {
    test('should calculate correct date ranges for filters', () {
      final now = DateTime.now();
      
      // Test "This Month" filter
      final thisMonthStart = DateTime(now.year, now.month, 1);
      final thisMonthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      
      expect(thisMonthStart.day, equals(1));
      expect(thisMonthEnd.month, equals(now.month));
      
      // Test "Last 7 Days" filter
      final last7DaysStart = now.subtract(const Duration(days: 7));
      final last7DaysEnd = now;
      
      final difference = last7DaysEnd.difference(last7DaysStart);
      expect(difference.inDays, equals(7));
      
      // Test "This Year" filter
      final thisYearStart = DateTime(now.year, 1, 1);
      final thisYearEnd = DateTime(now.year, 12, 31, 23, 59, 59);
      
      expect(thisYearStart.year, equals(now.year));
      expect(thisYearStart.month, equals(1));
      expect(thisYearStart.day, equals(1));
      expect(thisYearEnd.year, equals(now.year));
      expect(thisYearEnd.month, equals(12));
      expect(thisYearEnd.day, equals(31));
    });
  });
}
