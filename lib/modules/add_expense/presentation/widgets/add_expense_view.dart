import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/styles/app_colors.dart';
import '../bloc/add_expense/add_expense_bloc.dart';
import '../bloc/add_expense/add_expense_event.dart';
import '../bloc/add_expense/add_expense_state.dart';
import '../components/category_selector.dart';
import '../components/inputs/category_dropdown_input.dart';
import '../components/inputs/amount_input.dart';
import '../components/inputs/date_input.dart';
import '../components/inputs/receipt_input.dart';
import '../components/inputs/save_button.dart';

class AddExpenseView extends StatefulWidget {
  final String? expenseId;

  const AddExpenseView({super.key, this.expenseId});

  @override
  State<AddExpenseView> createState() => AddExpenseViewState();
}

class AddExpenseViewState extends State<AddExpenseView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocConsumer<AddExpenseBloc, AddExpenseState>(
        listener: _handleStateChanges,
        builder: _buildBody,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.expenseId != null ? 'Edit Expense' : 'Add Expense',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1D29),
        ),
      ),
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
    );
  }

  void _handleStateChanges(BuildContext context, AddExpenseState state) {
    _handleSubmissionSuccess(context, state);
    _handleGeneralError(context, state);
    _updateControllers(state);
  }

  void _handleSubmissionSuccess(BuildContext context, AddExpenseState state) {
    if (state.submittedExpense != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.isEditing
                ? 'Expense updated successfully'
                : 'Expense added successfully',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Return true to indicate data changed so dashboard can refresh
      Navigator.pop(context, true);
    }
  }

  void _handleGeneralError(BuildContext context, AddExpenseState state) {
    if (state.generalError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.generalError!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _updateControllers(AddExpenseState state) {
    if (_amountController.text != state.amount) {
      _amountController.text = state.amount;
    }
    if (_descriptionController.text != state.description) {
      _descriptionController.text = state.description;
    }
  }

  Widget _buildBody(BuildContext context, AddExpenseState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: _buildScrollableContent(state),
          ),
          _buildSaveButton(state),
        ],
      ),
    );
  }

  Widget _buildScrollableContent(AddExpenseState state) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryDropdown(state),
          const SizedBox(height: 15),
          _buildAmountInput(state),
          const SizedBox(height: 15),
          _buildDateInput(state),
          const SizedBox(height: 15),
          _buildReceiptInput(state),
          const SizedBox(height: 15),
          _buildCategorySelector(state),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(AddExpenseState state) {
    return CategoryDropdownInput(
      selectedCategory: state.category,
      errorText: state.categoryError,
    );
  }

  Widget _buildAmountInput(AddExpenseState state) {
    return AmountInput(
      controller: _amountController,
      errorText: state.amountError,
    );
  }

  Widget _buildDateInput(AddExpenseState state) {
    return DateInput(
      selectedDate: state.date,
      errorText: state.dateError,
    );
  }

  Widget _buildReceiptInput(AddExpenseState state) {
    return ReceiptInput(
      receiptPath: state.receiptPath,
    );
  }

  Widget _buildCategorySelector(AddExpenseState state) {
    return CategorySelector(
      selectedCategory: state.category.isEmpty ? null : state.category,
      onCategorySelected: (category) {
        context.read<AddExpenseBloc>().add(
          CategoryChanged(category: category),
        );
      },
      errorText: state.categoryError,
    );
  }

  Widget _buildSaveButton(AddExpenseState state) {
    return SaveButton(
      isSubmitting: state.isSubmitting,
      isEditing: state.isEditing,
    );
  }
}
