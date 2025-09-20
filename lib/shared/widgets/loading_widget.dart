import 'package:flutter/material.dart';
import '../../core/styles/app_colors.dart';

enum LoadingSize {
  small,
  medium,
  large,
}

class LoadingWidget extends StatelessWidget {
  final LoadingSize size;
  final Color? color;
  final String? message;
  final bool isCentered;

  const LoadingWidget({
    super.key,
    this.size = LoadingSize.medium,
    this.color,
    this.message,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    final loadingIndicator = _buildLoadingIndicator();

    if (message != null) {
      final content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingIndicator,
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );

      return isCentered
          ? Center(child: content)
          : content;
    }

    return isCentered
        ? Center(child: loadingIndicator)
        : loadingIndicator;
  }

  Widget _buildLoadingIndicator() {
    double strokeWidth;
    double indicatorSize;

    switch (size) {
      case LoadingSize.small:
        strokeWidth = 2;
        indicatorSize = 16;
        break;
      case LoadingSize.medium:
        strokeWidth = 3;
        indicatorSize = 24;
        break;
      case LoadingSize.large:
        strokeWidth = 4;
        indicatorSize = 32;
        break;
    }

    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

// Convenience widgets for common loading scenarios
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;
  final Color? overlayColor;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withOpacity(0.3),
            child: LoadingWidget(
              message: loadingMessage,
              isCentered: true,
            ),
          ),
      ],
    );
  }
}

class LoadingButton extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadingButton({
    super.key,
    required this.child,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const LoadingWidget(
              size: LoadingSize.small,
              color: Colors.white,
              isCentered: false,
            )
          : child,
    );
  }
}

class LoadingListTile extends StatelessWidget {
  final String message;
  final bool isLoading;

  const LoadingListTile({
    super.key,
    this.message = 'Loading...',
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isLoading
          ? const LoadingWidget(
              size: LoadingSize.small,
              isCentered: false,
            )
          : null,
      title: Text(message),
    );
  }
}
