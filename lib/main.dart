import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plank_timer/providers/workout_provider.dart';
import 'package:plank_timer/screens/tabs_screen.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (ChangeNotifierProvider.value(
      value: WorkoutProvider(),
      child: MaterialApp(
        title: 'Custom Timer',
        home: TabsScreen(),
      ),));
  }
}
