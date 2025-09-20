import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../bloc/add_expense/add_expense_bloc.dart';
import '../bloc/add_expense/add_expense_event.dart';
import '../bloc/add_expense/add_expense_state.dart';

class CurrencySelectorBottomSheet extends StatelessWidget {
  final AddExpenseState state;
  final AddExpenseBloc bloc;

  const CurrencySelectorBottomSheet({
    super.key,
    required this.state,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragHandle(),
            _buildTitle(),
            const SizedBox(height: 20),
            _buildCurrencyList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 12, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.borderLight,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Select Currency',
        style: AppTextStyles.h6.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCurrencyList() {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _getAvailableCurrencies().length,
        itemBuilder: (context, index) {
          final currency = _getAvailableCurrencies()[index];
          return _buildCurrencyItem(context, currency);
        },
      ),
    );
  }

  Widget _buildCurrencyItem(BuildContext context, String currency) {
    final isSelected = state.selectedCurrency == currency;

    return ListTile(
      leading: _buildCurrencyIcon(currency, isSelected),
      title: _buildCurrencyTitle(currency, isSelected),
      subtitle: _buildCurrencySubtitle(currency),
      trailing: isSelected ? _buildSelectedIcon() : null,
      onTap: () => _onCurrencySelected(context, currency),
    );
  }

  Widget _buildCurrencyIcon(String currency, bool isSelected) {
    return Container(
      width: 40,
      height: 30,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          Formatters.getCurrencySymbol(currency),
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyTitle(String currency, bool isSelected) {
    return Text(
      currency,
      style: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget _buildCurrencySubtitle(String currency) {
    return Text(
      _getCurrencyName(currency),
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildSelectedIcon() {
    return const Icon(
      Icons.check_circle,
      color: AppColors.primary,
    );
  }

  void _onCurrencySelected(BuildContext context, String currency) {
    context.read<AddExpenseBloc>().add(
      CurrencyChanged(currency: currency),
    );
    Navigator.pop(context);
  }

  List<String> _getAvailableCurrencies() {
    return [
      'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD',
      'CHF', 'CNY', 'SEK', 'NZD', 'MXN', 'SGD',
      'HKD', 'NOK', 'TRY', 'RUB', 'INR', 'BRL',
      'ZAR', 'KRW'
    ];
  }

  String _getCurrencyName(String currency) {
    const currencyNames = {
      'USD': 'US Dollar',
      'EUR': 'Euro',
      'GBP': 'British Pound',
      'JPY': 'Japanese Yen',
      'CAD': 'Canadian Dollar',
      'AUD': 'Australian Dollar',
      'CHF': 'Swiss Franc',
      'CNY': 'Chinese Yuan',
      'SEK': 'Swedish Krona',
      'NZD': 'New Zealand Dollar',
      'MXN': 'Mexican Peso',
      'SGD': 'Singapore Dollar',
      'HKD': 'Hong Kong Dollar',
      'NOK': 'Norwegian Krone',
      'TRY': 'Turkish Lira',
      'RUB': 'Russian Ruble',
      'INR': 'Indian Rupee',
      'BRL': 'Brazilian Real',
      'ZAR': 'South African Rand',
      'KRW': 'South Korean Won',
    };
    return currencyNames[currency] ?? currency;
  }
}
