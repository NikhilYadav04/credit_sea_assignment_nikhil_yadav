import 'package:flutter/material.dart';

class KeyboardDismiss extends StatefulWidget {
  const KeyboardDismiss({super.key, required this.child});

  final Widget child;

  @override
  State<KeyboardDismiss> createState() => _KeyboardDismissState();
}

class _KeyboardDismissState extends State<KeyboardDismiss> with WidgetsBindingObserver {
  double _lastInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final inset = View.of(context).viewInsets.bottom;
    if (_lastInset > 0 && inset == 0) FocusManager.instance.primaryFocus?.unfocus();
    _lastInset = inset;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: widget.child,
    );
  }
}
