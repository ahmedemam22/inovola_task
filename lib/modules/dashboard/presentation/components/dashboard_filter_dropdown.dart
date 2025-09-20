import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_styles.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/dashboard/dashboard_state.dart';


class DashboardFilterDropdown extends StatelessWidget {
  final DashboardState state;

  const DashboardFilterDropdown({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _getCurrentFilter(),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          iconEnabledColor: AppColors.textSecondary,
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          items: _getFilterItems(),
          onChanged: (value) => _onFilterChanged(context, value),
        ),
      ),
    );
  }

  String _getCurrentFilter() {
    if (state is DashboardLoaded) {
      return (state as DashboardLoaded).currentFilter ?? 'This Month';
    } else if (state is DashboardLoadingMore) {
      return (state as DashboardLoadingMore).currentFilter ?? 'This Month';
    }
    return 'This Month'; // Default filter
  }

  List<DropdownMenuItem<String>> _getFilterItems() {
    const filters = ['This Month', 'Last 7 Days', 'This Year', 'All Time'];
    
    return filters.map((filter) {
      return DropdownMenuItem<String>(
        value: filter,
        child: Text(filter),
      );
    }).toList();
  }

  void _onFilterChanged(BuildContext context, String? value) {
    if (value != null) {
      context.read<DashboardBloc>().add(
        LoadDashboard(filterType: value),
      );
    }
  }
}
