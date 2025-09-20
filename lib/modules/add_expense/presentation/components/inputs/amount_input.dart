import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_styles.dart';
import '../../../../../core/utils/formatters.dart';
import '../../bloc/add_expense/add_expense_bloc.dart';
import '../../bloc/add_expense/add_expense_event.dart';
import '../../bloc/add_expense/add_expense_state.dart';
import '../../widgets/currency_selector_bottom_sheet.dart';
import '../../widgets/converted_amount_preview.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const AmountInput({
    super.key,
    required this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount',
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
              child: Row(
                children: [
                  // Currency selector button

                  const SizedBox(width: 8),
                  // Amount textfield
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '50,000',
                        hintStyle: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isCollapsed: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onChanged: (value) {
                        context.read<AddExpenseBloc>().add(
                          AmountChanged(amount: value),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showCurrencySelector(context, state),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Formatters.getCurrencySymbol(state.selectedCurrency ?? 'USD'),
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Show converted amount if not USD
            if (state.selectedCurrency != null &&
                state.selectedCurrency != 'USD' &&
                state.convertedAmountInUSD != null &&
                controller.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              ConvertedAmountPreview(
                convertedAmountInUSD: state.convertedAmountInUSD!,
              ),
            ],
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
      },
    );
  }

  void _showCurrencySelector(BuildContext context, AddExpenseState state) {
    final bloc = context.read<AddExpenseBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => CurrencySelectorBottomSheet(
        state: state,
        bloc: bloc,
      ),
    );
  }
}

