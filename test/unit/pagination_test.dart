import 'package:flutter_test/flutter_test.dart';
import 'package:expense_track/shared/domain/entities/pagination_entity.dart';

void main() {
  group('Pagination Tests', () {
    test('should create pagination correctly from list', () {
      final items = List.generate(25, (index) => 'Item $index');
      final pagination = PaginationEntity.fromList(items, 1, 10);

      expect(pagination.items.length, equals(10));
      expect(pagination.currentPage, equals(1));
      expect(pagination.totalPages, equals(3));
      expect(pagination.totalItems, equals(25));
      expect(pagination.itemsPerPage, equals(10));
      expect(pagination.hasNextPage, isTrue);
      expect(pagination.hasPreviousPage, isFalse);
      expect(pagination.isFirstPage, isTrue);
      expect(pagination.isLastPage, isFalse);
    });

    test('should handle last page correctly', () {
      final items = List.generate(25, (index) => 'Item $index');
      final pagination = PaginationEntity.fromList(items, 3, 10);

      expect(pagination.items.length, equals(5)); // Only 5 items on last page
      expect(pagination.currentPage, equals(3));
      expect(pagination.totalPages, equals(3));
      expect(pagination.hasNextPage, isFalse);
      expect(pagination.hasPreviousPage, isTrue);
      expect(pagination.isFirstPage, isFalse);
      expect(pagination.isLastPage, isTrue);
    });

    test('should handle empty list', () {
      final pagination = PaginationEntity.fromList(<String>[], 1, 10);

      expect(pagination.items.length, equals(0));
      expect(pagination.currentPage, equals(1));
      expect(pagination.totalPages, equals(0));
      expect(pagination.totalItems, equals(0));
      expect(pagination.hasNextPage, isFalse);
      expect(pagination.hasPreviousPage, isFalse);
    });

    test('should create empty pagination', () {
      final pagination = PaginationEntity.empty(1, 10);

      expect(pagination.items.length, equals(0));
      expect(pagination.currentPage, equals(1));
      expect(pagination.totalPages, equals(0));
      expect(pagination.totalItems, equals(0));
      expect(pagination.hasNextPage, isFalse);
      expect(pagination.hasPreviousPage, isFalse);
    });

    test('should calculate next and previous page correctly', () {
      final items = List.generate(25, (index) => 'Item $index');
      final pagination = PaginationEntity.fromList(items, 2, 10);

      expect(pagination.nextPage, equals(3));
      expect(pagination.previousPage, equals(1));
    });

    test('should return null for next/previous page when not available', () {
      final items = List.generate(10, (index) => 'Item $index');
      
      // First page
      final firstPage = PaginationEntity.fromList(items, 1, 10);
      expect(firstPage.previousPage, isNull);
      expect(firstPage.nextPage, isNull); // Only one page

      // Test with multiple pages
      final items25 = List.generate(25, (index) => 'Item $index');
      final lastPage = PaginationEntity.fromList(items25, 3, 10);
      expect(lastPage.nextPage, isNull);
    });

    test('should format item range correctly', () {
      final items = List.generate(25, (index) => 'Item $index');
      
      final firstPage = PaginationEntity.fromList(items, 1, 10);
      expect(firstPage.itemRange, equals('1-10 of 25'));
      
      final secondPage = PaginationEntity.fromList(items, 2, 10);
      expect(secondPage.itemRange, equals('11-20 of 25'));
      
      final lastPage = PaginationEntity.fromList(items, 3, 10);
      expect(lastPage.itemRange, equals('21-25 of 25'));

      // Empty pagination
      final empty = PaginationEntity.empty(1, 10);
      expect(empty.itemRange, equals('0 of 0'));
    });
  });
}
