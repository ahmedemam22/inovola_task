import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors - Based on the Dribbble design
  static const Color primary = Color(0xFF1d54f3);
  static const Color primaryLight = Color(0xFF7BB3F0);
  static const Color primaryDark = Color(0xFF2E5A87);
  static const Color lightGrey = Color(0xFFf5f6fa);
  static const Color borderLight = Color(0xFFE5E7EB);

  // Background Colors
  static const Color background = Color(0xFFFffffff);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Accent Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Category Colors
  static const Color categoryFood = Color(0xFFFF6B6B);
  static const Color categoryTransport = Color(0xFF4ECDC4);
  static const Color categoryEntertainment = Color(0xFFFFE66D);
  static const Color categoryBills = Color(0xFF95E1D3);
  static const Color categoryOther = Color(0xFFB8A9C9);

  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static const Color shadowColor = Color(0x1A000000);
  static const Color cardShadow = Color(0x0F000000);

  // Border Colors
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color dividerColor = Color(0xFFF3F4F6);
}
