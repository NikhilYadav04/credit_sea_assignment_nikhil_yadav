import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_text_field.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.required = false,
    this.validator,
  });

  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final bool required;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: required),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          validator: validator,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDark),
          style: AppTextStyles.input,
          hint: Text(hint, style: AppTextStyles.hint),
          items: [
            for (final item in items)
              DropdownMenuItem(value: item, child: Text(item, style: AppTextStyles.input)),
          ],
        ),
      ],
    );
  }
}
