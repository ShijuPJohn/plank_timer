import 'package:flutter/foundation.dart';
import 'package:plank_timer/helpers/db_helper.dart';
import 'package:plank_timer/models/single_workout.dart';
import 'package:uuid/uuid.dart';

class WorkoutProvider with ChangeNotifier {
  List<SingleWorkout> _items = [];

  List<SingleWorkout> get items {
    return [..._items.reversed];
  }

  Future<void> addWorkout(String duration) async {
    final uuid = Uuid();
    final singleWorkout = SingleWorkout(
        id: uuid.v1().toString(),
        dateTime: DateTime.now().toIso8601String(),
        timeDuration: duration);
    DBHelper.insert('workout_list', {
      'id': singleWorkout.id,
      'duration': singleWorkout.timeDuration,
      'date_time': singleWorkout.dateTime,
    });
    _items.add(singleWorkout);
  }

  Future<void> fetchAndSetWorkouts() async {
    final workoutList = await DBHelper.getData('workout_list');
    _items = workoutList
        .map((item) => SingleWorkout(
            id: item['id'],
            timeDuration: item['duration'],
            dateTime: item['date_time']))
        .toList();
    notifyListeners();
  }

  Future<void> deleteItemById(String id) async {
    _items.removeWhere((element) => element.id == id);
    DBHelper.deleteById(id);
    notifyListeners();
  }
}
