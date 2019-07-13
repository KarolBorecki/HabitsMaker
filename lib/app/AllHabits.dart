import 'package:flutter/material.dart';

import '../globals.dart';
import 'Habbit.dart';
import 'Home.dart';

class AllHabits extends StatelessWidget {
  final int weekDay;

  AllHabits({int weekDay}) : this.weekDay = weekDay ?? DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(minMargin * 5),
      child: Column(
        children: <Widget>[
          Expanded(child: const Text("")),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) {
                    return AllHabits(weekDay: (weekDay <= 1) ? 7 : weekDay - 1);
                  }));
                },
              ),
              Text(
                weekDays[weekDay - 1],
                style: Theme.of(context).textTheme.display2,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) {
                    return AllHabits(weekDay: weekDay % 7 + 1);
                  }));
                },
              ),
            ],
          )),
          Container(
              height: minMargin * 250,
              margin: EdgeInsets.only(top: minMargin * 10),
              child: HabitsOptionsList(weekDay)),
          Expanded(child: const Text("")),
          Container(
            height: minMargin * 25,
            width: minMargin * 100,
            margin: EdgeInsets.only(bottom: minMargin * 5),
            child: RaisedButton(
                child: const Text("Back"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                      pageBuilder: (BuildContext context, _, __) {
                    return Home();
                  }));
                }),
          )
        ],
      ),
    ));
  }
}
