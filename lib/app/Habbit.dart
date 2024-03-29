import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habits_maker/main.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../globals.dart';
import 'NewHabit.dart';

class User {
  DateTime time = DateTime.now();
  DateTime lastSaving;

  List<Habit> habits;

  User({List<Habit> habits}) : this.habits = habits ?? [];

  void addHabit(name, habitTime, color, icon, weekDays) async {
    habits.add(Habit(name, habitTime, 0, false, color, icon, weekDays));

    for (int i = 0; i < weekDays.length; i++)
      _showWeeklyAtDayAndTime(weekDays[i], habitTime, name, cheeringUpTexts[Random().nextInt(cheeringUpTexts.length-1)]);

    List<PendingNotificationRequest> pending =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (int i = 0; i < pending.length; i++) {
      print(pending[i].title + " " + pending[i].id.toString());
    }
  }

  void saveHabits() async {
    File saveFile = await _saveFile;
    saveFile.writeAsString('');
    for (int i = 0; i < this.habits.length; i++)
      saveHabit(this.habits[i], file: saveFile);
    saveFile.writeAsStringSync(DateTime.now().toString(),
        mode: FileMode.append);
  }

  void saveHabit(Habit habit, {File file}) async {
    file = (file == null) ? await _saveFile : file;
    file.writeAsStringSync(habit.name + "\n", mode: FileMode.append);
    file.writeAsStringSync(habit.time.toString() + "\n", mode: FileMode.append);
    file.writeAsStringSync(habit.streak.toString() + "\n",
        mode: FileMode.append);
    file.writeAsStringSync(habit.isDone.toString() + "\n",
        mode: FileMode.append);
    file.writeAsStringSync(habit.color.value.toString() + "\n",
        mode: FileMode.append);
    file.writeAsStringSync(habit.icon + "\n", mode: FileMode.append);
    file.writeAsStringSync(habit.weekdays.toString() + "\n",
        mode: FileMode.append);
  }

  void loadHabits() async {
    final file = await _saveFile;
    if (file.existsSync()) {
      habits.clear();
      String contents = file.readAsStringSync();
      List<String> content = contents.split('\n');

      //Decrease length by 2 because I have lastSaving value at the end of the file
      for (int i = 0; i < content.length - 2; i += 7) {
        List<String> sList =
            content[i + 6].substring(1, content[i + 6].length - 1).split(', ');
        habits.add(new Habit(
          content[i],
          DateTime.parse(content[i + 1]),
          int.parse(content[i + 2]),
          content[i + 3] == 'true',
          Color(int.parse(content[i + 4])),
          content[i + 5].toString(),
          List<int>.generate(sList.length, (i) => int.parse(sList[i])),
        ));
      }
      lastSaving = DateTime.parse(content[content.length - 1]);
      checkIsDone();
    }
  }

  void checkIsDone() {
    if (time.day > lastSaving.day)
      for (int i = 0; i < habits.length; i++) {
        habits[i].isDone = false;
      }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _saveFile async {
    final path = await _localPath;
    File file = File('$path/SaveFile.txt');
    print(path);
    return file;
  }

  Future<void> _showWeeklyAtDayAndTime(
      int day, DateTime habitTime, String title, String description) async {
    var timeN = Time(habitTime.hour, habitTime.minute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    int dIndex = (day == 7) ? 1 : (day + 1);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(notificationID,
        title, description, Day(dIndex), timeN, platformChannelSpecifics);
    print("Notification " +
        title +
        " will be shown at " +
        Day(dIndex).value.toString() +
        " " +
        timeN.hour.toString() +
        ":" +
        timeN.minute.toString() +
        " with ID = " +
        notificationID.toString());
    notificationID++;
  }
}

class Habit {
  String name;
  DateTime time;
  int streak;
  bool isDone;

  Color color;
  String icon;
  List<int> weekdays = [];

  Habit(this.name, this.time, this.streak, this.isDone, this.color, this.icon,
      this.weekdays);
}

class HabitsList extends StatefulWidget {
  final int weekDay;

  HabitsList(this.weekDay);

  @override
  _HabitsListState createState() => _HabitsListState(weekDay);
}

// TODO There is an idea - read about list title

class _HabitsListState extends State<HabitsList> {
  int weekDay;

  _HabitsListState(this.weekDay);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: minMargin * 250,
        margin: EdgeInsets.only(left: minMargin, right: minMargin),
        child: ListView(
            scrollDirection: Axis.vertical,
            children: getHabits(weekDay).map<Padding>((habit) {
              if (habit == null)
                return Padding(
                  padding: EdgeInsets.only(top: minMargin * 10),
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Whoa all habits done!",
                        style: TextStyle(
                          color: Colors.white30,
                          fontSize: minMargin * 10,
                        ),
                      )),
                );
              return Padding(
                  padding: EdgeInsets.only(top: minMargin * 10),
                  child: Stack(
                    children: <Widget>[
                      // Here is this child
                      HabitListElement(habit),
                      Container(
                        height: minMargin * 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            color: Colors.transparent),
                        child: Dismissible(
                          direction: DismissDirection.startToEnd,
                          key: Key(habit.name),
                          child: Container(),
                          background: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80.0),
                                  color: habit.color),
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Text(habit.icon,
                                        style: TextStyle(
                                            fontSize: minMargin * 15)),
                                    iconSize: minMargin * 40,
                                    onPressed: () {},
                                  ),
                                  Expanded(child: const Text(""))
                                ],
                              )),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd)
                              setState(() {
                                habit.isDone = true;
                                habit.streak++;
                              });
                          },
                        ),
                      ),
                    ],
                  ));
            }).toList()));
  }

  List<dynamic> getHabits(int weekDay) {
    List<Habit> finalHabits = [];
    user.habits.forEach((element) {
      if (element.weekdays.contains(weekDay) && !element.isDone)
        finalHabits.add(element);
    });
    finalHabits.sort((a, b) {
      return (a.time.hour + a.time.minute / 60)
          .compareTo(b.time.hour + b.time.minute / 60);
    });
    if (finalHabits.length <= 0) return [null];
    return finalHabits;
  }
}

class HabitsOptionsList extends StatefulWidget {
  final int weekDay;

  HabitsOptionsList(this.weekDay);

  @override
  _HabitsOptionsListState createState() => _HabitsOptionsListState(weekDay);
}

class _HabitsOptionsListState extends State<HabitsOptionsList> {
  int weekDay;

  _HabitsOptionsListState(this.weekDay);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: getHabits(weekDay).map<Padding>((habit) {
          if (habit == null)
            return Padding(
              padding: EdgeInsets.only(top: minMargin * 10),
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "No habits!",
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: minMargin * 10,
                    ),
                  )),
            );
          return Padding(
            padding: EdgeInsets.only(top: minMargin * 10),
            child: Slidable(
              delegate: SlidableDrawerDelegate(),
              actionExtentRatio: 0.25,
              // Here is child
              child: HabitListElement(habit),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Theme.of(context).scaffoldBackgroundColor,
                  icon: Icons.delete_forever,
                  foregroundColor: Colors.red,
                  onTap: () {
                    setState(() {
                      user.habits.remove(habit);
                    });
                  },
                ),
                IconSlideAction(
                  caption: 'Options',
                  color: Theme.of(context).scaffoldBackgroundColor,
                  icon: Icons.settings,
                  onTap: () {
                    user.habits.remove(habit);
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (BuildContext context, _, __) {
                      return NewHabit(
                        name: habit.name,
                        icon: habit.icon,
                        weekDaysOfHabit: habit.weekdays,
                        time: habit.time,
                        color: habit.color,
                        goHome: false,
                      );
                    }));
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  List<dynamic> getHabits(int weekDay) {
    List<Habit> finalHabits = [];
    user.habits.forEach((element) {
      if (element.weekdays.contains(weekDay)) finalHabits.add(element);
    });
    finalHabits.sort((a, b) {
      return (a.time.hour + a.time.minute / 60)
          .compareTo(b.time.hour + b.time.minute / 60);
    });
    if (finalHabits.length <= 0) return [null];
    return finalHabits;
  }
}

class HabitListElement extends StatelessWidget {
  final Habit habit;

  HabitListElement(this.habit);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: minMargin * 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          color: Theme.of(context).primaryColor),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80.0),
                color: habit.color.withOpacity(0.8)),
            child: IconButton(
              icon:
                  Text(habit.icon, style: TextStyle(fontSize: minMargin * 15)),
              color: habit.color.withOpacity(0.6),
              iconSize: minMargin * 40,
              onPressed: () {},
            ),
          ),
          Expanded(
            child: Container(
              margin:
                  EdgeInsets.only(left: minMargin * 5, right: minMargin * 5),
              child: Text(
                habit.name,
                style: Theme.of(context).textTheme.body2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: minMargin * 7),
            child: Text(
              DateFormat('kk:mm').format(habit.time),
              style: Theme.of(context).textTheme.body2,
            ),
          )
        ],
      ),
    );
  }
}
