import 'package:flutter/material.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.textLight).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: iconColor ?? AppColors.textLight,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: AppTextStyles.h6.copyWith(
                color: titleColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Subtitle (optional)
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: subtitleColor ?? AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // Action Button (optional)
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionText!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Predefined empty states for common scenarios
class EmptyStateWidgets {
  static EmptyStateWidget noData({
    String title = 'No Data Available',
    String? subtitle = 'There are no items to display at the moment.',
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return EmptyStateWidget(
      icon: Icons.inbox_outlined,
      title: title,
      subtitle: subtitle,
      actionText: actionText,
      onActionPressed: onActionPressed,
    );
  }

  static EmptyStateWidget noExpenses({
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return EmptyStateWidget(
      icon: Icons.receipt_long_outlined,
      title: 'No Expenses Yet',
      subtitle: 'Start tracking your expenses by adding your first expense.',
      actionText: actionText ?? 'Add Expense',
      onActionPressed: onActionPressed,
    );
  }

  static EmptyStateWidget noResults({
    String title = 'No Results Found',
    String? subtitle = 'Try adjusting your search or filters.',
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: title,
      subtitle: subtitle,
      actionText: actionText,
      onActionPressed: onActionPressed,
    );
  }

  static EmptyStateWidget error({
    String title = 'Something Went Wrong',
    String? subtitle = 'We encountered an error. Please try again.',
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return EmptyStateWidget(
      icon: Icons.error_outline,
      title: title,
      subtitle: subtitle,
      actionText: actionText ?? 'Try Again',
      onActionPressed: onActionPressed,
      iconColor: AppColors.error,
    );
  }

  static EmptyStateWidget networkError({
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    return EmptyStateWidget(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      subtitle: 'Please check your internet connection and try again.',
      actionText: actionText ?? 'Retry',
      onActionPressed: onActionPressed,
      iconColor: AppColors.error,
    );
  }
}
