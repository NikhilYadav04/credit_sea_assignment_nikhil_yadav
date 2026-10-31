import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.length,
    required this.onChanged,
    this.boxSize = 50,
    this.autofocus = true,
    this.controller,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final double boxSize;
  final bool autofocus;
  final TextEditingController? controller;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final TextEditingController _controller = widget.controller ?? TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focus.addListener(() => setState(() {}));
  }

  void _onTextChanged() {
    setState(() {});
    widget.onChanged(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;
    return GestureDetector(
      onTap: _focus.requestFocus,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < widget.length; i++)
                _Box(
                  size: widget.boxSize,
                  char: i < code.length ? code[i] : '',
                  active: _focus.hasFocus && i == code.length.clamp(0, widget.length - 1),
                ),
            ],
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.number,
                maxLength: widget.length,
                enableInteractiveSelection: false,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(counterText: '', border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.size, required this.char, required this.active});

  final double size;
  final String char;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.fieldBorder,
          width: active ? 1.5 : 1,
        ),
      ),
      child: Text(char, style: AppTextStyles.authTitle),
    );
  }
}
