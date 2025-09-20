import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_styles.dart';
import '../../bloc/add_expense/add_expense_bloc.dart';
import '../../bloc/add_expense/add_expense_event.dart';
import '../receipt_upload.dart';

class ReceiptInput extends StatelessWidget {
  final String? receiptPath;

  const ReceiptInput({
    super.key,
    this.receiptPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attach Receipt',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ReceiptUpload(
          receiptPath: receiptPath,
          onReceiptAdded: (path) {
            context.read<AddExpenseBloc>().add(
              ReceiptAdded(receiptPath: path),
            );
          },
          onReceiptRemoved: () {
            context.read<AddExpenseBloc>().add(
              const ReceiptRemoved(),
            );
          },
        ),
      ],
    );
  }
}
