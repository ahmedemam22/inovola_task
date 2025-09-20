import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dashboard Filter Tests', () {
    // Helper function to test filter logic without creating full bloc
    Map<String, DateTime?> getDateRangeFromFilter(String filterType) {
      final now = DateTime.now();
      
      switch (filterType.toLowerCase()) {
        case 'this month':
          return {
            'start': DateTime(now.year, now.month, 1),
            'end': DateTime(now.year, now.month + 1, 0, 23, 59, 59),
          };
      case 'last 7 days':
        return {
          'start': now.subtract(const Duration(days: 7)),
          'end': DateTime(now.year, now.month, now.day, 23, 59, 59),
        };
        case 'this year':
          return {
            'start': DateTime(now.year, 1, 1),
            'end': DateTime(now.year, 12, 31, 23, 59, 59),
          };
        case 'all time':
          return {'start': null, 'end': null}; // Show all expenses
        default:
          return {'start': null, 'end': null};
      }
    }

    test('should handle This Month filter correctly', () {
      final dateRange = getDateRangeFromFilter('This Month');
      final now = DateTime.now();
      
      expect(dateRange['start'], isA<DateTime>());
      expect(dateRange['end'], isA<DateTime>());
      
      final startDate = dateRange['start'] as DateTime;
      final endDate = dateRange['end'] as DateTime;
      
      // Should start from the first day of current month
      expect(startDate.year, equals(now.year));
      expect(startDate.month, equals(now.month));
      expect(startDate.day, equals(1));
      
      // Should end at the last day of current month
      expect(endDate.year, equals(now.year));
      expect(endDate.month, equals(now.month));
      expect(endDate.hour, equals(23));
      expect(endDate.minute, equals(59));
      expect(endDate.second, equals(59));
    });

    test('should handle Last 7 Days filter correctly', () {
      final dateRange = getDateRangeFromFilter('Last 7 Days');
      final now = DateTime.now();
      
      expect(dateRange['start'], isA<DateTime>());
      expect(dateRange['end'], isA<DateTime>());
      
      final startDate = dateRange['start'] as DateTime;
      final endDate = dateRange['end'] as DateTime;
      
      // Should start 7 days ago
      final expectedStart = now.subtract(const Duration(days: 7));
      expect(startDate.day, equals(expectedStart.day));
      expect(startDate.month, equals(expectedStart.month));
      expect(startDate.year, equals(expectedStart.year));
      
      // Should end now
      expect(endDate.day, equals(now.day));
      expect(endDate.month, equals(now.month));
      expect(endDate.year, equals(now.year));
    });

    test('should handle This Year filter correctly', () {
      final dateRange = getDateRangeFromFilter('This Year');
      final now = DateTime.now();
      
      expect(dateRange['start'], isA<DateTime>());
      expect(dateRange['end'], isA<DateTime>());
      
      final startDate = dateRange['start'] as DateTime;
      final endDate = dateRange['end'] as DateTime;
      
      // Should start from January 1st
      expect(startDate.year, equals(now.year));
      expect(startDate.month, equals(1));
      expect(startDate.day, equals(1));
      
      // Should end at December 31st
      expect(endDate.year, equals(now.year));
      expect(endDate.month, equals(12));
      expect(endDate.day, equals(31));
      expect(endDate.hour, equals(23));
      expect(endDate.minute, equals(59));
      expect(endDate.second, equals(59));
    });

    test('should handle All Time filter correctly', () {
      final dateRange = getDateRangeFromFilter('All Time');
      
      expect(dateRange['start'], isNull);
      expect(dateRange['end'], isNull);
    });

    test('should handle case insensitive filter names', () {
      final thisMonth = getDateRangeFromFilter('this month');
      final THIS_MONTH = getDateRangeFromFilter('THIS MONTH');
      final ThisMonth = getDateRangeFromFilter('This Month');
      
      expect(thisMonth['start'], isA<DateTime>());
      expect(THIS_MONTH['start'], isA<DateTime>());
      expect(ThisMonth['start'], isA<DateTime>());
      
      // All should return the same result
      expect(thisMonth['start'], equals(THIS_MONTH['start']));
      expect(THIS_MONTH['start'], equals(ThisMonth['start']));
    });

    test('should return null dates for unknown filter types', () {
      final dateRange = getDateRangeFromFilter('Unknown Filter');
      
      expect(dateRange['start'], isNull);
      expect(dateRange['end'], isNull);
    });

    test('should handle empty filter type', () {
      final dateRange = getDateRangeFromFilter('');
      
      expect(dateRange['start'], isNull);
      expect(dateRange['end'], isNull);
    });
  });
}
