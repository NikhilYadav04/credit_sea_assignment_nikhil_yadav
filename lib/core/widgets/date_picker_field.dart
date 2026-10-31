import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_text_field.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.label,
    required this.onPicked,
    this.value,
    this.required = false,
    this.validator,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime? value;
  final bool required;
  final ValueChanged<DateTime> onPicked;
  final String? Function(DateTime?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  static final _display = DateFormat('dd - MM - yyyy');

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: firstDate ?? DateTime(1940),
      lastDate: lastDate ?? now,
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: value,
      validator: validator,
      builder: (state) {
        if (state.value != value) {
          WidgetsBinding.instance.addPostFrameCallback((_) => state.didChange(value));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(label, required: required),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _pick(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  errorText: state.errorText,
                  suffixIcon: const Icon(Icons.calendar_month_outlined, color: AppColors.textDark),
                ),
                child: Text(
                  value == null ? 'DD - MM - YYYY' : _display.format(value!),
                  style: value == null ? AppTextStyles.hint : AppTextStyles.input,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
