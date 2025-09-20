import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../bloc/dashboard/dashboard_event.dart';
import '../../bloc/dashboard/dashboard_state.dart';
import '../dashboard_expenses_list.dart';
import '../dashboard_balance_card.dart';
import '../dashboard_header_section.dart';
import '../dashboard_recent_expenses_header.dart';
import '../dashboard_snackbar_handler.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSnackBarHandler(
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(RefreshDashboard());
            },
            child: CustomScrollView(
              slivers: [
                // Profile Header with Filter Dropdown
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      DashboardHeaderSection(state: state),
                      Positioned(
                        top: 140, // overlaps halfway
                        left: 20,
                        right: 20,
                        child: DashboardBalanceCard(state: state),
                      ),
                    ],
                  ),
                ),
                
                // Recent Expenses Header
                const SliverToBoxAdapter(
                  child: DashboardRecentExpensesHeader(),
                ),
                
                // Expenses List
                DashboardExpensesList(state: state),
              ],
            ),
          );
        },
      ),
    );
  }

}
