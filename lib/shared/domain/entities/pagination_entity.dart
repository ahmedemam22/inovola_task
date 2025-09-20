import 'package:equatable/equatable.dart';

class PaginationEntity<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginationEntity({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  @override
  List<Object?> get props => [
        items,
        currentPage,
        totalPages,
        totalItems,
        itemsPerPage,
        hasNextPage,
        hasPreviousPage,
      ];

  // Factory constructor for creating pagination from a list
  factory PaginationEntity.fromList(
    List<T> allItems,
    int page,
    int itemsPerPage,
  ) {
    final totalItems = allItems.length;
    final totalPages = (totalItems / itemsPerPage).ceil();
    final startIndex = (page - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);
    
    final items = startIndex < totalItems 
        ? allItems.sublist(startIndex, endIndex)
        : <T>[];

    return PaginationEntity(
      items: items,
      currentPage: page,
      totalPages: totalPages,
      totalItems: totalItems,
      itemsPerPage: itemsPerPage,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
    );
  }

  // Factory constructor for empty pagination
  factory PaginationEntity.empty(int page, int itemsPerPage) {
    return PaginationEntity(
      items: [],
      currentPage: page,
      totalPages: 0,
      totalItems: 0,
      itemsPerPage: itemsPerPage,
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }

  // Get the next page number
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  // Get the previous page number
  int? get previousPage => hasPreviousPage ? currentPage - 1 : null;

  // Check if this is the first page
  bool get isFirstPage => currentPage == 1;

  // Check if this is the last page
  bool get isLastPage => currentPage == totalPages || totalPages == 0;

  // Get the range of items being displayed
  String get itemRange {
    if (totalItems == 0) return '0 of 0';
    
    final startItem = ((currentPage - 1) * itemsPerPage) + 1;
    final endItem = (startItem + items.length - 1).clamp(1, totalItems);
    
    return '$startItem-$endItem of $totalItems';
  }

  PaginationEntity<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginationEntity(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }
}
