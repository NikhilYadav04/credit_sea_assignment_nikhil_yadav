import 'dart:async';

import 'package:get/get.dart';

class ResendCountdown {
  final seconds = 0.obs;
  Timer? _timer;

  bool get finished => seconds.value == 0;

  String get label {
    final m = (seconds.value ~/ 60).toString().padLeft(2, '0');
    final s = (seconds.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void start(int from) {
    _timer?.cancel();
    seconds.value = from;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value <= 1) {
        seconds.value = 0;
        timer.cancel();
      } else {
        seconds.value -= 1;
      }
    });
  }

  void dispose() => _timer?.cancel();
}
