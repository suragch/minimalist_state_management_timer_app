import 'package:flutter/material.dart';
import 'package:timer_app/services/service_locator.dart';
import 'package:timer_app/pages/timer_page/timer_page_logic.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final stateManager = getIt<TimerPageManager>();

  @override
  void initState() {
    stateManager.initTimerState();
    super.initState();
  }

  @override
  void dispose() {
    stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('building MyHomePage');
    return Scaffold(
      appBar: AppBar(title: Text('My Timer App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TimerTextWidget(),
            SizedBox(height: 20),
            ButtonsContainer(),
          ],
        ),
      ),
    );
  }
}

class TimerTextWidget extends StatelessWidget {
  const TimerTextWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<TimerPageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: stateManager.timeLeftNotifier,
      builder: (context, timeLeft, child) {
        print('building time left state: $timeLeft');
        return Text(
          timeLeft,
          style: Theme.of(context).textTheme.headline2,
        );
      },
    );
  }
}

class ButtonsContainer extends StatelessWidget {
  const ButtonsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateManager = getIt<TimerPageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: stateManager.buttonNotifier,
      builder: (context, buttonState, child) {
        print('building button state: $buttonState');
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (buttonState == ButtonState.initial) ...[
              StartButton(),
            ],
            if (buttonState == ButtonState.started) ...[
              PauseButton(),
              SizedBox(width: 20),
              ResetButton(),
            ],
            if (buttonState == ButtonState.paused) ...[
              StartButton(),
              SizedBox(width: 20),
              ResetButton(),
            ],
            if (buttonState == ButtonState.finished) ...[
              ResetButton(),
            ],
          ],
        );
      },
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final stateManager = getIt<TimerPageManager>();
        stateManager.start();
      },
      child: Icon(Icons.play_arrow),
    );
  }
}

class PauseButton extends StatelessWidget {
  const PauseButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final stateManager = getIt<TimerPageManager>();
        stateManager.pause();
      },
      child: Icon(Icons.pause),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final stateManager = getIt<TimerPageManager>();
        stateManager.reset();
      },
      child: Icon(Icons.replay),
    );
  }
}
