import 'dart:async';

import 'package:flutter/foundation.dart';
import 'notifiers/time_left_notifier.dart';

class TimerPageManager {
  // state notifiers
  final timeLeftNotifier = TimeLeftNotifier();
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.initial);

  void initTimerState() {
    timeLeftNotifier.initialize();
  }

  void start() {
    if (buttonNotifier.value == ButtonState.paused) {
      _unpauseTimer();
    } else {
      _startTimer();
    }
  }

  void _unpauseTimer() {
    buttonNotifier.value = ButtonState.started;
    timeLeftNotifier.unpause();
  }

  void _startTimer() {
    buttonNotifier.value = ButtonState.started;
    timeLeftNotifier.start(onDone: () {
      buttonNotifier.value = ButtonState.finished;
    });
  }

  void pause() {
    timeLeftNotifier.pause();
    buttonNotifier.value = ButtonState.paused;
  }

  void reset() {
    timeLeftNotifier.reset();
    buttonNotifier.value = ButtonState.initial;
  }

  void dispose() {
    timeLeftNotifier.dispose();
  }
}

enum ButtonState {
  initial,
  started,
  paused,
  finished,
}
