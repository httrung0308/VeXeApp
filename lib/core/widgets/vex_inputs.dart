import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Input field widgets
class VexTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const VexTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      onTap: onTap,
      readOnly: readOnly,
      onChanged: onChanged,
      focusNode: focusNode,
      textInputAction: textInputAction,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class VexSearchField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  const VexSearchField({
    super.key,
    this.hint = 'Tìm kiếm...',
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.onClear,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,
      onChanged: onChanged,
      focusNode: focusNode,
      style: AppTypography.body,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary, size: AppSpacing.iconSize),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.textTertiary, size: AppSpacing.iconSizeSmall),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
    );
  }
}

class VexLocationField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final IconData icon;
  final bool isFilled;

  const VexLocationField({
    super.key,
    required this.label,
    this.value,
    this.onTap,
    this.icon = Icons.location_on_outlined,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isFilled ? AppColors.surfaceVariant : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(color: isFilled ? AppColors.primary : AppColors.border, width: isFilled ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isFilled ? AppColors.primary : AppColors.textTertiary, size: AppSpacing.iconSize),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.caption.copyWith(color: isFilled ? AppColors.primary : AppColors.textTertiary)),
                  if (value != null && value!.isNotEmpty)
                    Text(value!, style: AppTypography.body.copyWith(fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)
                  else
                    Text('Chọn điểm đi', style: AppTypography.body.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.textTertiary, size: AppSpacing.iconSizeSmall),
          ],
        ),
      ),
    );
  }
}

class VexDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback? onTap;
  final bool showQuickOptions;

  const VexDateField({
    super.key,
    required this.label,
    this.value,
    this.onTap,
    this.showQuickOptions = true,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (dateOnly == today) return 'Hôm nay';
    if (dateOnly == tomorrow) return 'Ngày mai';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.textTertiary, size: AppSpacing.iconSize),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.caption),
                  const SizedBox(height: 2),
                  Text(
                    value != null ? _formatDate(value!) : 'Chọn ngày',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: value != null ? AppColors.textPrimary : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
