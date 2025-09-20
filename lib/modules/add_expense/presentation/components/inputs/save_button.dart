import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../bloc/add_expense/add_expense_bloc.dart';
import '../../bloc/add_expense/add_expense_event.dart';

class SaveButton extends StatelessWidget {
  final bool isSubmitting;
  final bool isEditing;

  const SaveButton({
    super.key,
    required this.isSubmitting,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: isEditing ? 'Update' : 'Save',
      isLoading: isSubmitting,
      size: AppButtonSize.large,
      onPressed: () {
        context.read<AddExpenseBloc>().add(const SubmitExpense());
      },
    );
  }
}
