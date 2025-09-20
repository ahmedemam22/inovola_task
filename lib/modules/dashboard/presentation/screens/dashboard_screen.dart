import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../components/navigation/bottom_nav_bar.dart';
import '../components/navigation/floating_add_button.dart';
import '../components/content/dashboard_content.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(const LoadDashboard()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DashboardContent(),
      floatingActionButton: const FloatingAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    
    // Handle navigation based on index
    switch (index) {
      case 0:
        // Home - already on dashboard
        break;
      case 1:
        // Analytics/Charts
        // TODO: Navigate to analytics screen
        break;
      case 2:
        // Calendar
        // TODO: Navigate to calendar screen
        break;
      case 3:
        // Profile
        // TODO: Navigate to profile screen
        break;
    }
  }
}