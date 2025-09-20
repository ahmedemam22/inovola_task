import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_styles.dart';
import '../../../../../core/constants/category_config.dart';
import '../../bloc/add_expense/add_expense_bloc.dart';
import '../../bloc/add_expense/add_expense_event.dart';

class CategoryDropdownInput extends StatelessWidget {
  final String? selectedCategory;
  final String? errorText;

  const CategoryDropdownInput({
    super.key,
    this.selectedCategory,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory?.isEmpty == true ? null : selectedCategory,
              hint: Text(
                'Select Category',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              iconEnabledColor: AppColors.textSecondary,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              items: CategoryConfig.getDropdownItems(),
              onChanged: (value) {
                if (value != null) {
                  context.read<AddExpenseBloc>().add(
                    CategoryChanged(category: value),
                  );
                }
              },
            ),
          ),
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
}
