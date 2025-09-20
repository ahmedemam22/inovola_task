import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';

class ReceiptUpload extends StatelessWidget {
  final String? receiptPath;
  final Function(String) onReceiptAdded;
  final VoidCallback onReceiptRemoved;

  const ReceiptUpload({
    super.key,
    this.receiptPath,
    required this.onReceiptAdded,
    required this.onReceiptRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return
        GestureDetector(
          onTap: () => _showImageSourceDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12),

            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    receiptPath != null && receiptPath!.isNotEmpty
                        ? "Receipt attached"
                        : "Upload image",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: receiptPath != null && receiptPath!.isNotEmpty
                          ? AppColors.textPrimary
                          : AppColors.textLight,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  receiptPath != null && receiptPath!.isNotEmpty
                      ? Icons.check_circle
                      : Icons.camera_alt_outlined,
                  color: receiptPath != null && receiptPath!.isNotEmpty
                      ? AppColors.success
                      : AppColors.textSecondary,
                ),
              ],
            ),
          ),

    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Image Source',
                  style: AppTextStyles.h6,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildSourceOption(
                        context,
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onTap: () =>
                            _pickImage(context, ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSourceOption(
                        context,
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        onTap: () =>
                            _pickImage(context, ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    Navigator.pop(context);

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        onReceiptAdded(pickedFile.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
