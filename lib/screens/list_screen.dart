import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plank_timer/providers/workout_provider.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder(
          future: Provider.of<WorkoutProvider>(context, listen: false)
              .fetchAndSetWorkouts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return Consumer<WorkoutProvider>(
                  child: Center(
                    child: Text('No exercise records'),
                  ),
                  builder: (context, exerciseItems, child) => exerciseItems
                              .items.length ==
                          0
                      ? child
                      : ListView.builder(
                          itemCount: exerciseItems.items.length,
                          itemBuilder: (context, index) => Card(
                            color: Color.fromRGBO(242, 237, 238, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          Duration(
                                                  milliseconds: int.parse(
                                                      exerciseItems.items[index]
                                                          .timeDuration))
                                              .inMinutes
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.green.shade800,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            'Minutes',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20,),
                                        Text(
                                          Duration(
                                                  milliseconds: int.parse(
                                                      exerciseItems.items[index]
                                                          .timeDuration))
                                              .inSeconds
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.green.shade800,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom : 8.0),
                                          child: Text(
                                            'Seconds',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        DateFormat('dd MMM    hh:mm a').format(
                                            DateTime.parse(exerciseItems
                                                .items[index].dateTime)),
                                        style: TextStyle(
                                            color: Colors.grey.shade500),
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    Provider.of<WorkoutProvider>(context,
                                            listen: false)
                                        .deleteItemById(
                                            exerciseItems.items[index].id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ));
            }
          },
        ),
      ),
    );
  }
}
