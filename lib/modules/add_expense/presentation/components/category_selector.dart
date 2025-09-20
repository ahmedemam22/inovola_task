import 'package:flutter/material.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/constants/category_config.dart';
import '../../../../core/styles/app_text_styles.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final String? errorText;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final categoriesForGrid = CategoryConfig.getAllCategoriesForGrid();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTextStyles.h6.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        // First row - 4 main categories
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 4 && i < categoriesForGrid.length; i++)
              _buildCategoryItemFromConfig(categoriesForGrid[i])
          ],
        ),
        const SizedBox(height: 16),
        // Second row - 4 more categories  
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 4; i < 8 && i < categoriesForGrid.length; i++)
              _buildCategoryItemFromConfig(categoriesForGrid[i]),
            _buildCategoryItem('Add Category', false, Icons.add, const Color(0xFF8F92A1)),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryItemFromConfig(CategoryDisplayItem category) {
    return _buildCategoryItem(
      category.displayName,
      selectedCategory == category.internalKey,
      category.icon,
      category.color,
    );
  }

  Widget _buildCategoryItem(String category, bool isSelected, IconData icon, Color color) {
    return GestureDetector(
        onTap: () {
          if (category == 'Add Category') {
            // Handle add category functionality
            return;
          }
          
          // Find the internal key for this display name
          String? internalKey;
          for (final entry in CategoryConfig.categories.entries) {
            if (entry.value.displayName == category) {
              internalKey = entry.key;
              break;
            }
          }
          
          if (internalKey != null) {
            onCategorySelected(internalKey);
          }
        },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: color, width: 2)
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
