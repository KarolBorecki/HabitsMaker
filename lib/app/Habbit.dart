import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../globals.dart';
import 'NewHabit.dart';

class User {
  DateTime time = DateTime.now();

  List<Habit> habits;

  User({List<Habit> habits}) : this.habits = habits ?? [];

  void addHabit(name, time, color, icon, weekDays) async {
    habits.add(Habit(name, time, 0, false, color, icon, weekDays));
  }

  void saveHabits() async {
    File saveFile = await _saveFile;
    saveFile.writeAsString('');
    for (int i = 0; i < this.habits.length; i++)
      saveHabit(this.habits[i], file: saveFile);
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
    habits.clear();
    final file = await _saveFile;
    String contents = file.readAsStringSync();
    List<String> content = contents.split('\n');

    for (int i = 0; i < content.length - 1; i += 7) {
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
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _saveFile async {
    final path = await _localPath;
    File file = File('$path/SaveFile.txt');
    return file;
  }
}

class Habit {
  String name;
  DateTime time;
  int streak;
  bool isDone;

  Color color;
  String icon;
  var weekdays = [];

  Habit(this.name, this.time, this.streak, this.isDone, this.color, this.icon,
      this.weekdays);
}

class HabitsList extends StatefulWidget {
  var weekDay;

  HabitsList(this.weekDay);

  @override
  _HabitsListState createState() => _HabitsListState(weekDay);
}

// TODO There is an idea - read about list title

class _HabitsListState extends State<HabitsList> {
  var weekDay;

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
                      HabitListElement(minMargin, habit),
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

  //TODO Delete this horryfing vars OMFG
  List<dynamic> getHabits(var weekDay) {
    var finalHabits = [];
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
  var _minMargin;
  var weekDay;

  HabitsOptionsList(this._minMargin, this.weekDay);

  @override
  _HabitsOptionsListState createState() =>
      _HabitsOptionsListState(_minMargin, weekDay);
}

class _HabitsOptionsListState extends State<HabitsOptionsList> {
  var _minMargin;
  var weekDay;

  _HabitsOptionsListState(this._minMargin, this.weekDay);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: getHabits(weekDay).map<Padding>((habit) {
          if (habit == null)
            return Padding(
              padding: EdgeInsets.only(top: _minMargin * 10),
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "No habits!",
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: _minMargin * 10,
                    ),
                  )),
            );
          return Padding(
            padding: EdgeInsets.only(top: _minMargin * 10),
            child: Slidable(
              delegate: SlidableDrawerDelegate(),
              actionExtentRatio: 0.25,
              // Here is child
              child: HabitListElement(_minMargin, habit),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Theme.of(context).scaffoldBackgroundColor,
                  icon: Icons.delete_forever,
                  foregroundColor: Colors.red,
                  onTap: () {
                    // TODO add popup window - are you fcking sure???
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

  List<dynamic> getHabits(var weekDay) {
    var finalHabits = [];
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
  var _minMargin;
  Habit habit;

  HabitListElement(this._minMargin, this.habit);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _minMargin * 40,
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
                  Text(habit.icon, style: TextStyle(fontSize: _minMargin * 15)),
              color: habit.color.withOpacity(0.6),
              iconSize: _minMargin * 40,
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: _minMargin * 5),
            child: Text(
              //TODO problem - too long name = overfolowed error
              habit.name,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          Expanded(child: const Text("")),
          Container(
            margin: EdgeInsets.only(right: _minMargin * 5),
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
