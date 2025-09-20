import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/add_expense/add_expense_bloc.dart';
import '../bloc/add_expense/add_expense_event.dart';
import '../widgets/add_expense_view.dart';

class AddExpenseScreen extends StatelessWidget {
  final String? expenseId;

  const AddExpenseScreen({super.key, this.expenseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddExpenseBloc>()
        ..add(LoadAddExpenseScreen(expenseId: expenseId)),
      child: AddExpenseView(expenseId: expenseId),
    );
  }
}