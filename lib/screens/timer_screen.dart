import 'package:flutter/material.dart';
import 'package:plank_timer/helpers/db_helper.dart';
import 'package:plank_timer/providers/workout_provider.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

class TimerScreen extends StatefulWidget {
  final _isHours = true;

  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final _isHours = true;
  var _currentTime = '';
  var _isStart = false;
  var _isStartedAtLeastOnce = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    // onChange: (value) => print('onChange $value'),
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  @override
  void initState() {
    super.initState();
    // _stopWatchTimer.rawTime.listen((value) =>
    //     print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    // _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    // _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    // _stopWatchTimer.records.listen((value) => print('records $value'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 600234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: StreamBuilder<int>(
          stream: _stopWatchTimer.rawTime,
          initialData: _stopWatchTimer.rawTime.value,
          builder: (context, snapshot) {
            final value = snapshot.data;
            final displayTime =
                StopWatchTimer.getDisplayTime(value).substring(3);
            return Text(
              displayTime,
              style: TextStyle(
                fontSize: 70,
              ),
            );
          },
        )),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  minWidth: 300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  color: Colors.blue,
                  onPressed: () {
                    if (!_isStart) {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                      _isStart = true;
                    } else {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                      _isStart = false;
                    }
                    _isStartedAtLeastOnce = true;
                  },
                  child: Text(
                    'START/STOP',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(16),
                  color: Colors.red,
                  onPressed: () {
                    _isStartedAtLeastOnce = false;
                    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                  },
                  child: Text(
                    'RESET',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(16),
                  color: Colors.green,
                  onPressed: () {
                    if (!_isStartedAtLeastOnce) {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            'Timer not started',
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    if (_isStart) {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            'Please stop the timer and save',
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    Provider.of<WorkoutProvider>(context, listen: false)
                        .addWorkout(_stopWatchTimer.rawTime.value.toString());
                    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                    _isStartedAtLeastOnce = false;
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text(
                          'Saved',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text(
                    'SAVE',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
