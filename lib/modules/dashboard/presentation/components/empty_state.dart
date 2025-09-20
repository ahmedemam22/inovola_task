import 'package:flutter/material.dart';
import '../../../../../shared/widgets/widgets.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const EmptyState({
    super.key,
    this.title = 'No expenses yet',
    this.subtitle = 'Start tracking your expenses by adding your first expense',
    this.icon = Icons.receipt_long_outlined,
    this.onActionPressed,
    this.actionText = 'Add Expense',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: EmptyStateWidget(
        icon: icon,
        title: title,
        subtitle: subtitle,
        actionText: actionText,
        onActionPressed: onActionPressed,
      ),
    );
  }
}
