import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/app_text_styles.dart';

enum AppTextFieldType {
  text,
  email,
  number,
  password,
  multiline,
}

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final AppTextFieldType type;
  final bool isEnabled;
  final bool isReadOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final bool isRequired;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.type = AppTextFieldType.text,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textInputAction,
    this.inputFormatters,
    this.contentPadding,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Row(
            children: [
              Text(
                labelText!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                Text(
                  '*',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          readOnly: isReadOnly,
          obscureText: type == AppTextFieldType.password,
          maxLines: maxLines ?? _getDefaultMaxLines(),
          minLines: minLines ?? _getDefaultMinLines(),
          maxLength: maxLength,
          textInputAction: textInputAction ?? _getDefaultTextInputAction(),
          keyboardType: _getKeyboardType(),
          inputFormatters: inputFormatters ?? _getInputFormatters(),
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            counterText: '',
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  int _getDefaultMaxLines() {
    switch (type) {
      case AppTextFieldType.multiline:
        return 4;
      case AppTextFieldType.text:
      case AppTextFieldType.email:
      case AppTextFieldType.password:
      case AppTextFieldType.number:
        return 1;
    }
  }

  int _getDefaultMinLines() {
    switch (type) {
      case AppTextFieldType.multiline:
        return 2;
      case AppTextFieldType.text:
      case AppTextFieldType.email:
      case AppTextFieldType.password:
      case AppTextFieldType.number:
        return 1;
    }
  }

  TextInputAction _getDefaultTextInputAction() {
    switch (type) {
      case AppTextFieldType.multiline:
        return TextInputAction.newline;
      case AppTextFieldType.email:
        return TextInputAction.next;
      case AppTextFieldType.password:
        return TextInputAction.done;
      case AppTextFieldType.text:
      case AppTextFieldType.number:
        return TextInputAction.next;
    }
  }

  TextInputType _getKeyboardType() {
    switch (type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      case AppTextFieldType.text:
      case AppTextFieldType.password:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    switch (type) {
      case AppTextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case AppTextFieldType.email:
      case AppTextFieldType.text:
      case AppTextFieldType.password:
      case AppTextFieldType.multiline:
        return [];
    }
  }
}
