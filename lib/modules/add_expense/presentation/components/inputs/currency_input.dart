import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_styles.dart';
import '../../../domain/entities/currency_info_entity.dart';
import '../../bloc/add_expense/add_expense_bloc.dart';
import '../../bloc/add_expense/add_expense_event.dart';

class CurrencyInput extends StatelessWidget {
  final String selectedCurrency;
  final List<CurrencyInfoEntity> currencies;
  final String? errorText;

  const CurrencyInput({
    super.key,
    required this.selectedCurrency,
    required this.currencies,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? AppColors.error : AppColors.borderColor,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCurrency,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconEnabledColor: AppColors.textSecondary,
              style: AppTextStyles.bodyMedium,
              dropdownColor: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              items: currencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency.code,
                  child: Row(
                    children: [
                      Text(
                        '🌍', // Generic globe emoji since flag property doesn't exist
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('${currency.code} - ${currency.name}'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<AddExpenseBloc>().add(
                    CurrencyChanged(currency: value),
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
