import 'package:flutter/material.dart';
import '../../../../../core/styles/app_text_styles.dart';

class DashboardRecentExpensesHeader extends StatelessWidget {
  final VoidCallback? onSeeAllPressed;

  const DashboardRecentExpensesHeader({
    super.key,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Expenses',
            style: AppTextStyles.h6.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: onSeeAllPressed,
            child: Text(
              'See all',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
