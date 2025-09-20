import 'package:flutter_test/flutter_test.dart';
import 'package:expense_track/shared/domain/entities/pagination_entity.dart';

void main() {
  group('Pagination Integration Tests', () {
    test('should create pagination correctly with mock data', () {
      // Create mock expense data (more than 10 items to test pagination)
      final mockExpenses = List.generate(25, (index) => 'Expense $index');
      
      print('\n=== Pagination Test ===');
      print('Total items: ${mockExpenses.length}');
      
      // Test first page
      final firstPage = PaginationEntity.fromList(mockExpenses, 1, 10);
      print('First page:');
      print('  Items: ${firstPage.items.length}');
      print('  Current page: ${firstPage.currentPage}');
      print('  Total pages: ${firstPage.totalPages}');
      print('  Has next page: ${firstPage.hasNextPage}');
      print('  Has previous page: ${firstPage.hasPreviousPage}');
      
      expect(firstPage.items.length, equals(10));
      expect(firstPage.currentPage, equals(1));
      expect(firstPage.totalPages, equals(3)); // 25 items / 10 per page = 3 pages
      expect(firstPage.hasNextPage, isTrue);
      expect(firstPage.hasPreviousPage, isFalse);
      
      // Test second page
      final secondPage = PaginationEntity.fromList(mockExpenses, 2, 10);
      print('\nSecond page:');
      print('  Items: ${secondPage.items.length}');
      print('  Current page: ${secondPage.currentPage}');
      print('  Total pages: ${secondPage.totalPages}');
      print('  Has next page: ${secondPage.hasNextPage}');
      print('  Has previous page: ${secondPage.hasPreviousPage}');
      
      expect(secondPage.items.length, equals(10));
      expect(secondPage.currentPage, equals(2));
      expect(secondPage.hasNextPage, isTrue);
      expect(secondPage.hasPreviousPage, isTrue);
      
      // Test third page (last page)
      final thirdPage = PaginationEntity.fromList(mockExpenses, 3, 10);
      print('\nThird page:');
      print('  Items: ${thirdPage.items.length}');
      print('  Current page: ${thirdPage.currentPage}');
      print('  Total pages: ${thirdPage.totalPages}');
      print('  Has next page: ${thirdPage.hasNextPage}');
      print('  Has previous page: ${thirdPage.hasPreviousPage}');
      
      expect(thirdPage.items.length, equals(5)); // 25 - 20 = 5 remaining items
      expect(thirdPage.currentPage, equals(3));
      expect(thirdPage.hasNextPage, isFalse);
      expect(thirdPage.hasPreviousPage, isTrue);
    });

    test('should handle edge cases in pagination', () {
      // Test with exactly 10 items (should have only 1 page)
      final exactly10Items = List.generate(10, (index) => 'Item $index');
      final singlePage = PaginationEntity.fromList(exactly10Items, 1, 10);
      
      expect(singlePage.items.length, equals(10));
      expect(singlePage.totalPages, equals(1));
      expect(singlePage.hasNextPage, isFalse);
      expect(singlePage.hasPreviousPage, isFalse);
      
      // Test with empty list
      final emptyPage = PaginationEntity.fromList(<String>[], 1, 10);
      expect(emptyPage.items.length, equals(0));
      expect(emptyPage.totalPages, equals(0));
      expect(emptyPage.hasNextPage, isFalse);
      expect(emptyPage.hasPreviousPage, isFalse);
      
      // Test with 1 item
      final singleItem = ['Single Item'];
      final oneItemPage = PaginationEntity.fromList(singleItem, 1, 10);
      expect(oneItemPage.items.length, equals(1));
      expect(oneItemPage.totalPages, equals(1));
      expect(oneItemPage.hasNextPage, isFalse);
      expect(oneItemPage.hasPreviousPage, isFalse);
    });

    test('should simulate pagination workflow', () {
      final allItems = List.generate(15, (index) => 'Item $index');
      
      // Simulate loading first page
      final page1 = PaginationEntity.fromList(allItems, 1, 10);
      expect(page1.items.length, equals(10));
      expect(page1.hasNextPage, isTrue);
      
      // Simulate loading second page
      final page2 = PaginationEntity.fromList(allItems, 2, 10);
      expect(page2.items.length, equals(5));
      expect(page2.hasNextPage, isFalse);
      
      // Simulate combining both pages (what the UI should do)
      final combinedItems = [...page1.items, ...page2.items];
      expect(combinedItems.length, equals(15));
      expect(combinedItems, equals(allItems));
    });
  });
}
