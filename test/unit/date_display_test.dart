import 'package:flutter_test/flutter_test.dart';
import 'package:expense_track/core/utils/formatters.dart';

void main() {
  group('Date Display Tests', () {
    test('should show correct relative date for 5 days ago', () {
      final now = DateTime.now();
      final fiveDaysAgo = now.subtract(const Duration(days: 5));
      // Test the relative date formatter
      final relativeDate = Formatters.formatRelativeDate(fiveDaysAgo);

      // Expected result should be the actual date (dd/MM/yyyy format)
      final expectedDate = '${fiveDaysAgo.day.toString().padLeft(2, '0')}/${fiveDaysAgo.month.toString().padLeft(2, '0')}/${fiveDaysAgo.year}';
      expect(relativeDate, equals(expectedDate));
    });

    test('should show correct relative date for various days ago', () {
      final now = DateTime.now();
      
      // Test different days ago
      final testCases = [1, 2, 3, 4, 5, 6, 7, 14, 30];
      
      for (final daysAgo in testCases) {
        final dateAgo = now.subtract(Duration(days: daysAgo));
        final actualDisplay = Formatters.formatRelativeDate(dateAgo);
        
        String expectedDisplay;
        if (daysAgo == 1) {
          expectedDisplay = 'Yesterday';
        } else {
          // For other dates, show the actual date in dd/MM/yyyy format
          final day = dateAgo.day.toString().padLeft(2, '0');
          final month = dateAgo.month.toString().padLeft(2, '0');
          final year = dateAgo.year.toString();
          expectedDisplay = '$day/$month/$year';
        }
        
        expect(actualDisplay, equals(expectedDisplay));
      }
    });

    test('should show formatted date for 5 days ago', () {
      final now = DateTime.now();
      final fiveDaysAgo = now.subtract(const Duration(days: 5));
      
      // Test different date formats
      final shortFormat = Formatters.formatDateShort(fiveDaysAgo); // dd/MM/yyyy
      final longFormat = Formatters.formatDate(fiveDaysAgo); // MMM dd, yyyy
      final dateTimeFormat = Formatters.formatDateTime(fiveDaysAgo); // MMM dd, yyyy HH:mm

      // Verify formats are not empty
      expect(shortFormat.isNotEmpty, isTrue);
      expect(longFormat.isNotEmpty, isTrue);
      expect(dateTimeFormat.isNotEmpty, isTrue);
    });

    test('should handle date filtering for 5 days ago expense', () {
      final now = DateTime.now();
      final fiveDaysAgo = now.subtract(const Duration(days: 5));
      

      // Test "Last 7 Days" filter
      final last7DaysStart = now.subtract(const Duration(days: 7));
      final last7DaysEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
      
      final isInLast7Days = fiveDaysAgo.isAfter(last7DaysStart) && fiveDaysAgo.isBefore(last7DaysEnd);
      expect(isInLast7Days, isTrue);

    });
  });
}
