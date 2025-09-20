import 'package:flutter/material.dart';
import '../../core/styles/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final double borderRadius;
  final VoidCallback? onTap;
  final Border? border;
  final BoxShadow? shadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius = 12,
    this.onTap,
    this.border,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: shadow != null ? [shadow!] : (_getDefaultShadow() != null ? [_getDefaultShadow()!] : null),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardWidget,
      );
    }

    return cardWidget;
  }

  BoxShadow? _getDefaultShadow() {
    if (elevation != null && elevation! > 0) {
      return BoxShadow(
        color: AppColors.textSecondary.withOpacity(0.1),
        blurRadius: elevation! * 2,
        offset: Offset(0, elevation! / 2),
      );
    }
    return null;
  }
}

// Predefined card styles for common use cases
class AppCardStyles {
  static AppCard primary({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      elevation: 2,
      shadow: BoxShadow(
        color: AppColors.primary.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),

      ),
      child: child,

    );
  }

  static AppCard outlined({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      border: Border.all(
        color: AppColors.borderLight,
        width: 1,
      ),
      elevation: 0,
      child: child,

    );
  }

  static AppCard flat({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      elevation: 0,
      backgroundColor: AppColors.lightGrey,
      child: child,

    );
  }

  static AppCard elevated({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    double elevation = 4,
  }) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      elevation: elevation,
      child: child,

    );
  }
}
