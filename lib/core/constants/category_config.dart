import 'package:flutter/material.dart';

class CategoryConfig {
  // Private constructor to prevent instantiation
  CategoryConfig._();

  /// Category data model
  static const Map<String, CategoryData> categories = {
    'Food': CategoryData(
      displayName: 'Groceries',
      icon: Icons.shopping_cart,
      color: Color(0xFF4A90E2), // Blue
    ),
    'Entertainment': CategoryData(
      displayName: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFF6C5CE7), // Purple
    ),
    'Gas': CategoryData(
      displayName: 'Gas',
      icon: Icons.local_gas_station,
      color: Color(0xFFFF7675), // Red
    ),
    'Transport': CategoryData(
      displayName: 'Transport',
      icon: Icons.directions_bus,
      color: Color(0xFF6C5CE7), // Purple
    ),
    'News Paper': CategoryData(
      displayName: 'News Paper',
      icon: Icons.newspaper,
      color: Color(0xFFE17055), // Orange
    ),
    'Rent': CategoryData(
      displayName: 'Rent',
      icon: Icons.home,
      color: Color(0xFFE17055), // Orange
    ),
    'Shopping': CategoryData(
      displayName: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFFDCB6E), // Yellow
    ),
    'Health': CategoryData(
      displayName: 'Health',
      icon: Icons.local_hospital,
      color: Color(0xFF00B894), // Green
    ),
    'Education': CategoryData(
      displayName: 'Education',
      icon: Icons.school,
      color: Color(0xFF74B9FF), // Light Blue
    ),
    'Travel': CategoryData(
      displayName: 'Travel',
      icon: Icons.flight,
      color: Color(0xFFE17055), // Orange
    ),
    'Other': CategoryData(
      displayName: 'Other',
      icon: Icons.category,
      color: Color(0xFF8F92A1), // Gray
    ),
  };

  /// Get category data by internal key
  static CategoryData? getCategoryData(String internalKey) {
    return categories[internalKey];
  }

  /// Get display name by internal key
  static String getDisplayName(String internalKey) {
    return categories[internalKey]?.displayName ?? internalKey;
  }

  /// Get icon by internal key
  static IconData getIcon(String internalKey) {
    return categories[internalKey]?.icon ?? Icons.category;
  }

  /// Get color by internal key
  static Color getColor(String internalKey) {
    return categories[internalKey]?.color ?? const Color(0xFF8F92A1);
  }

  /// Get all internal keys (for dropdown, etc.)
  static List<String> getAllInternalKeys() {
    return categories.keys.toList();
  }

  /// Get all category data for grid display
  static List<CategoryDisplayItem> getAllCategoriesForGrid() {
    return categories.entries.map((entry) {
      return CategoryDisplayItem(
        internalKey: entry.key,
        displayName: entry.value.displayName,
        icon: entry.value.icon,
        color: entry.value.color,
      );
    }).toList();
  }

  /// Get categories for dropdown (internal key -> display name mapping)
  static List<DropdownMenuItem<String>> getDropdownItems() {
    return categories.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key, // Internal key
        child: Text(entry.value.displayName), // Display name
      );
    }).toList();
  }
}

/// Category data model
class CategoryData {
  final String displayName;
  final IconData icon;
  final Color color;

  const CategoryData({
    required this.displayName,
    required this.icon,
    required this.color,
  });
}

/// Category display item for grid
class CategoryDisplayItem {
  final String internalKey;
  final String displayName;
  final IconData icon;
  final Color color;

  const CategoryDisplayItem({
    required this.internalKey,
    required this.displayName,
    required this.icon,
    required this.color,
  });
}
