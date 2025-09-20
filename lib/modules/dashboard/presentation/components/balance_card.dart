import 'package:flutter/material.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/dashboard_summary_entity.dart';

class BalanceCard extends StatelessWidget {
  final DashboardSummaryEntity summary;

  const BalanceCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF357ABD),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 20,
                ),

            ],
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatCurrency(summary.totalBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
               _buildBalanceItem(
                  icon: Icons.arrow_downward,
                  iconColor: Colors.green,
                  label: 'Income',
                  amount: summary.totalIncome,
                ),

              const SizedBox(width: 24),
              _buildBalanceItem(
                  icon: Icons.arrow_upward,
                  iconColor: Colors.red,
                  label: 'Expenses',
                  amount: summary.totalExpensesInUSD,
                ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required double amount,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color:  Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 5),

                  Column(
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                ],


        ),
        const SizedBox(height: 2),
        Text(
          Formatters.formatCurrency(amount),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

