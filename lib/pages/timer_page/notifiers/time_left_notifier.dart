import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_app/services/service_locator.dart';
import 'package:timer_app/services/storage_service/storage_service.dart';

class TimeLeftNotifier extends ValueNotifier<String> {
  TimeLeftNotifier() : super(_durationString(_initialValue));

  static const int _initialValue = 10;
  int _currentTimeLeft = _initialValue;

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  final _storageService = getIt<StorageService>();

  static String _durationString(int duration) {
    final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final seconds = (duration % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> initialize() async {
    final savedTime = await _storageService.getTimeLeft() ?? _initialValue;
    _updateTimeLeft(savedTime);
  }

  void start({required Function onDone}) {
    // cancel any previous timer
    _tickerSubscription?.cancel();

    // initialize the state
    _updateTimeLeft(_currentTimeLeft);

    // update timer text on each tick
    _tickerSubscription = _ticker.tick(ticks: _currentTimeLeft).listen(
      (duration) {
        _updateTimeLeft(duration);
      },
    );

    // update button state when timer finished
    _tickerSubscription!.onDone(() {
      _storageService.saveTimeLeft(_initialValue);
      onDone();
    });
  }

  void reset() {
    _tickerSubscription?.cancel();
    _updateTimeLeft(_initialValue);
  }

  void pause() {
    _tickerSubscription?.pause();
    _storageService.saveTimeLeft(_currentTimeLeft);
  }

  void unpause() {
    _tickerSubscription?.resume();
  }

  void _updateTimeLeft(int seconds) {
    value = _durationString(seconds);
    _currentTimeLeft = seconds;
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    _storageService.saveTimeLeft(_currentTimeLeft);
    super.dispose();
  }
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      Duration(seconds: 1),
      (x) => ticks - x - 1,
    ).take(ticks);
  }
}
