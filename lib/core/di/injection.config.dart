// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:expense_track/core/di/module.dart' as _i900;
import 'package:expense_track/core/network/network_info.dart' as _i352;
import 'package:expense_track/core/storage/hive_service.dart' as _i459;
import 'package:expense_track/modules/add_expense/data/repositories_impl/add_expense_repository_impl.dart'
    as _i21;
import 'package:expense_track/modules/add_expense/domain/repositories/add_expense_repository.dart'
    as _i1001;
import 'package:expense_track/modules/add_expense/domain/usecases/add_new_expense.dart'
    as _i689;
import 'package:expense_track/modules/add_expense/domain/usecases/get_currencies.dart'
    as _i192;
import 'package:expense_track/modules/add_expense/domain/usecases/load_expense_for_editing.dart'
    as _i289;
import 'package:expense_track/modules/add_expense/domain/usecases/update_existing_expense.dart'
    as _i753;
import 'package:expense_track/modules/add_expense/presentation/bloc/add_expense/add_expense_bloc.dart'
    as _i286;
import 'package:expense_track/modules/dashboard/data/repositories_impl/dashboard_repository_impl.dart'
    as _i140;
import 'package:expense_track/modules/dashboard/domain/repositories/dashboard_repository.dart'
    as _i77;
import 'package:expense_track/modules/dashboard/domain/usecases/delete_expense_from_dashboard.dart'
    as _i360;
import 'package:expense_track/modules/dashboard/domain/usecases/get_dashboard_expenses.dart'
    as _i624;
import 'package:expense_track/modules/dashboard/domain/usecases/get_dashboard_summary.dart'
    as _i41;
import 'package:expense_track/modules/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart'
    as _i577;
import 'package:expense_track/shared/data/datasources/local/currency_local_datasource.dart'
    as _i81;
import 'package:expense_track/shared/data/datasources/local/expense_local_datasource.dart'
    as _i104;
import 'package:expense_track/shared/data/datasources/remote/currency_remote_datasource.dart'
    as _i67;
import 'package:expense_track/shared/data/repositories_impl/currency_repository_impl.dart'
    as _i753;
import 'package:expense_track/shared/domain/repositories/currency_repository.dart'
    as _i31;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i352.NetworkInfo>(() => registerModule.networkInfo);
    gh.lazySingleton<_i459.HiveService>(() => registerModule.hiveService);
    gh.lazySingleton<_i67.CurrencyRemoteDataSource>(
        () => _i67.CurrencyRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i104.ExpenseLocalDataSource>(
        () => _i104.ExpenseLocalDataSourceImpl(gh<_i459.HiveService>()));
    gh.lazySingleton<_i81.CurrencyLocalDataSource>(
        () => _i81.CurrencyLocalDataSourceImpl(gh<_i459.HiveService>()));
    gh.lazySingleton<_i77.DashboardRepository>(() =>
        _i140.DashboardRepositoryImpl(gh<_i104.ExpenseLocalDataSource>()));
    gh.lazySingleton<_i624.GetDashboardExpenses>(
        () => _i624.GetDashboardExpenses(gh<_i77.DashboardRepository>()));
    gh.lazySingleton<_i41.GetDashboardSummary>(
        () => _i41.GetDashboardSummary(gh<_i77.DashboardRepository>()));
    gh.lazySingleton<_i360.DeleteExpenseFromDashboard>(
        () => _i360.DeleteExpenseFromDashboard(gh<_i77.DashboardRepository>()));
    gh.lazySingleton<_i31.CurrencyRepository>(
        () => _i753.CurrencyRepositoryImpl(
              gh<_i67.CurrencyRemoteDataSource>(),
              gh<_i81.CurrencyLocalDataSource>(),
              gh<_i352.NetworkInfo>(),
            ));
    gh.factory<_i577.DashboardBloc>(() => _i577.DashboardBloc(
          gh<_i624.GetDashboardExpenses>(),
          gh<_i41.GetDashboardSummary>(),
          gh<_i360.DeleteExpenseFromDashboard>(),
        )..init());
    gh.lazySingleton<_i1001.AddExpenseRepository>(
        () => _i21.AddExpenseRepositoryImpl(
              gh<_i104.ExpenseLocalDataSource>(),
              gh<_i31.CurrencyRepository>(),
            ));
    gh.lazySingleton<_i753.UpdateExistingExpense>(
        () => _i753.UpdateExistingExpense(gh<_i1001.AddExpenseRepository>()));
    gh.lazySingleton<_i689.AddNewExpense>(
        () => _i689.AddNewExpense(gh<_i1001.AddExpenseRepository>()));
    gh.lazySingleton<_i192.GetCurrencies>(
        () => _i192.GetCurrencies(gh<_i1001.AddExpenseRepository>()));
    gh.lazySingleton<_i289.LoadExpenseForEditing>(
        () => _i289.LoadExpenseForEditing(gh<_i1001.AddExpenseRepository>()));
    gh.factory<_i286.AddExpenseBloc>(() => _i286.AddExpenseBloc(
          gh<_i689.AddNewExpense>(),
          gh<_i753.UpdateExistingExpense>(),
          gh<_i192.GetCurrencies>(),
          gh<_i289.LoadExpenseForEditing>(),
        )..init());
    return this;
  }
}

class _$RegisterModule extends _i900.RegisterModule {}
