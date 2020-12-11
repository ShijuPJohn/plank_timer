import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plank_timer/screens/list_screen.dart';
import 'package:plank_timer/screens/timer_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Timer'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.timer),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TimerScreen(),
            ListScreen(),
          ],
        ),
      ),
    );
  }
}
