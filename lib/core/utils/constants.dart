class AppConstants {
  AppConstants._();

  // API Constants
  static const String baseUrl = 'https://open.er-api.com/v6/latest';
  static const String baseCurrency = 'USD';
  
  // Local Storage Keys
  static const String expensesBoxKey = 'expenses_box';
  static const String userPrefsBoxKey = 'user_prefs_box';
  static const String currencyRatesBoxKey = 'currency_rates_box';
  
  // Pagination
  static const int itemsPerPage = 10;
  static const int maxRetryAttempts = 3;
  
  // Validation
  static const double maxExpenseAmount = 999999.99;
  static const double minExpenseAmount = 0.01;
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
  
  // Categories
  static const List<String> expenseCategories = [
    'Food',
    'Transportation',
    'Entertainment',
    'Bills',
    'Shopping',
    'Health',
    'Education',
    'Travel',
    'Other',
  ];
  
  // Category Icons (Material Icons)
  static const Map<String, String> categoryIcons = {
    'Food': 'restaurant',
    'Transportation': 'directions_car',
    'Entertainment': 'movie',
    'Bills': 'receipt',
    'Shopping': 'shopping_bag',
    'Health': 'local_hospital',
    'Education': 'school',
    'Travel': 'flight',
    'Other': 'category',
  };
  
  // Currencies
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'SEK',
    'NZD',
    'MXN',
    'SGD',
    'HKD',
    'NOK',
    'TRY',
    'RUB',
    'INR',
    'BRL',
    'ZAR',
    'KRW',
  ];
  
  // Time Periods for Filtering
  static const List<String> timePeriods = [
    'This Month',
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last 6 Months',
    'This Year',
    'All Time',
  ];
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection';
  static const String serverErrorMessage = 'Server error occurred. Please try again';
  static const String cacheErrorMessage = 'Local storage error occurred';
  static const String validationErrorMessage = 'Please check your input';
  static const String unexpectedErrorMessage = 'An unexpected error occurred';
  
  // Success Messages
  static const String expenseAddedMessage = 'Expense added successfully';
  static const String expenseUpdatedMessage = 'Expense updated successfully';
  static const String expenseDeletedMessage = 'Expense deleted successfully';
  
  // Image Picker
  static const double maxImageSizeMB = 5.0;
  static const int imageQuality = 80;
}
