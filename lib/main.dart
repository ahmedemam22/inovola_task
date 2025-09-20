import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/hive_service.dart';
import 'core/styles/app_theme.dart';
import 'shared/data/models/currency_rate_model.dart';
import 'shared/data/models/expense_model.dart';
import 'modules/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await HiveService.init();
  
  // Register Hive adapters
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(CurrencyRateModelAdapter());
  
  // Setup dependency injection
  await configureDependencies();
  
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<DashboardBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.dashboard,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}