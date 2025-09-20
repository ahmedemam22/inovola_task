import 'package:expense_track/core/extensions/media_query_extension.dart';
import 'package:flutter/material.dart';
import '../../../../../core/assets/assets.dart';
import '../bloc/dashboard/dashboard_state.dart';
import 'profile_header.dart';
import 'dashboard_filter_dropdown.dart';

class DashboardHeaderSection extends StatelessWidget {
  final DashboardState state;

  const DashboardHeaderSection({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height / 2.1,
      child: Stack(
        children: [
          _buildBackgroundImage(context),
          _buildHeaderContent(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    return Container(
      height: context.height / 3,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        image: DecorationImage(
          image: AssetImage(Assets.imagesInfoBg),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: ProfileHeader(),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: DashboardFilterDropdown(state: state),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
