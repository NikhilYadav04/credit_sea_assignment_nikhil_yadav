import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(required ? '$text*' : text, style: AppTextStyles.label),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.required = false,
    this.controller,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.suffix,
    this.obscureText = false,
    this.inputFormatters,
    this.maxLength,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    this.autovalidateMode,
  });

  final AutovalidateMode? autovalidateMode;
  final String? label;
  final bool required;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) FieldLabel(label!, required: required),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: autovalidateMode,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          onChanged: onChanged,
          textCapitalization: textCapitalization,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.hint = 'Enter password',
    this.validator,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      hint: widget.hint,
      obscureText: _hidden,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      suffix: IconButton(
        onPressed: () => setState(() => _hidden = !_hidden),
        icon: Icon(
          _hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
