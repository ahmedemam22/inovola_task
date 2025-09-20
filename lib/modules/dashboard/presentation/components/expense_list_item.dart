import 'package:flutter/material.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/category_config.dart';
import '../../domain/entities/expense_item_entity.dart';

class ExpenseListItem extends StatelessWidget {
  final ExpenseItemEntity expense;
  final VoidCallback? onTap;

  const ExpenseListItem({
    super.key,
    required this.expense,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildCategoryIcon(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDisplayCategoryName(expense.category),
                        style: AppTextStyles.h6,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.formatRelativeDate(expense.date),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      if (expense.description != null && expense.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          expense.description!,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '- ${Formatters.formatCurrency(expense.amount, currency: expense.currency)}',
                      style: AppTextStyles.amountSmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (expense.currency != 'USD') ...[
                      const SizedBox(height: 4),
                      Text(
                        '≈ ${Formatters.formatCurrency(expense.amountInUSD)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (expense.receiptPath != null)
                      Icon(
                        Icons.receipt_outlined,
                        size: 16,
                        color: AppColors.textLight,
                      ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDisplayCategoryName(String internalCategory) {
    return CategoryConfig.getDisplayName(internalCategory);
  }

  Widget _buildCategoryIcon() {
    final color = CategoryConfig.getColor(expense.category);
    final icon = CategoryConfig.getIcon(expense.category);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }
}
