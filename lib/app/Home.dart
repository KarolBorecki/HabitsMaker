import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_maker/globals.dart';

import 'AllHabits.dart';
import 'Habbit.dart';
import 'NewHabit.dart';
import 'Settings.dart';

class Home extends StatefulWidget {
  final int weekDay;

  Home({weekDay}) : this.weekDay = weekDay ?? DateTime.now().weekday;

  @override
  _HomeState createState() => _HomeState(weekDay);
}

class _HomeState extends State<Home> {
  int weekDay;

  _HomeState(this.weekDay);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(minMargin * 5),
      child: Column(
        children: <Widget>[
          Expanded(child: const Text("")),
          Container(
              margin: EdgeInsets.all(minMargin * 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Today",
                    style: Theme.of(context).textTheme.display1,
                  ),
                  FlatButton(
                    child: Text(
                      "See all",
                      style: TextStyle(color: Colors.white54),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(PageRouteBuilder(
                          pageBuilder: (BuildContext context, _, __) {
                        return AllHabits();
                      }));
                    },
                  )
                ],
              )),
          Container(height: minMargin * 250, child: HabitsList(weekDay)),
          Expanded(child: const Text("")),
          Container(
            margin: EdgeInsets.only(bottom: minMargin * 5),
            child: Row(
              children: <Widget>[
                Container(
                  width: minMargin * 100,
                  height: minMargin * 25,
                  child: RaisedButton(
                    child: Text(
                      "+ New Habit",
                      style: Theme.of(context).textTheme.body2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(PageRouteBuilder(
                          pageBuilder: (BuildContext context, _, __) {
                        return NewHabit(
                          weekDaysOfHabit: [weekDay],
                        );
                      }));
                    },
                  ),
                ),
                Expanded(child: const Text("")),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    iconSize: minMargin * 15,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(PageRouteBuilder(
                          pageBuilder: (BuildContext context, _, __) {
                        return Settings();
                      }));
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
