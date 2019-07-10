import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../globals.dart';
import 'Home.dart';

class NewHabit extends StatefulWidget {
  String name;
  String icon;
  DateTime time;
  List<int> weekDaysOfHabit;
  Color color;

  NewHabit({this.name = "", this.icon = "👌🏼", time, weekDaysOfHabit, color})
      : this.time = time ?? DateTime.now(),
        this.weekDaysOfHabit = weekDaysOfHabit ?? [],
        this.color = color ?? appColors[Random().nextInt(appColorsLen)];

  @override
  _NewHabitState createState() =>
      _NewHabitState(name, icon, time, weekDaysOfHabit, color);
}

//TODO change list of weeekdays from dynamic to static like: List<int>
class _NewHabitState extends State<NewHabit> {
  final _formKey = new GlobalKey<FormState>();

  String name;
  String icon;
  DateTime time;
  List<int> weekDaysOfHabit;

  Color color;

  _NewHabitState(
      this.name, this.icon, this.time, this.weekDaysOfHabit, this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: Container(
            margin: EdgeInsets.all(minMargin * 5),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: minMargin * 40),
                    child: Text(
                      "Add new habit:",
                      style: Theme.of(context).textTheme.display2,
                    ),
                  ),
                  Expanded(child: const Text("")),
                  Container(
                    height: minMargin * 40,
                    margin: EdgeInsets.only(bottom: minMargin * 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: minMargin * 140,
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: "Habit name"),
                            style: Theme
                                .of(context)
                                .textTheme
                                .body2,
                            initialValue: this.name,
                            onSaved: (String val) => this.name = val,
                          ),
                        ),
                        Container(
                          width: minMargin * 50,
                          child: TextFormField(
                            initialValue: this.icon,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: minMargin * 21),
                            onSaved: (String val) => this.icon = val,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: minMargin * 3),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TimePicker(time, (time) {
                    this.time = time;
                  }),
                  //TODO JESUS WTF IS THIS?!
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekDays.map<CheckBox>((weekDay) {
                      return CheckBox(
                          minMargin * 25,
                          weekDays.indexOf(weekDay) + 1,
                          Text(
                            weekDay.substring(0, 1),
                            style: Theme.of(context).textTheme.body1,
                          ),
                          (weekDaysOfHabit
                                  .contains(weekDays.indexOf(weekDay) + 1)
                              ? true
                              : false), (int val) {
                        if (weekDaysOfHabit.contains(val))
                          weekDaysOfHabit.remove(val);
                        else
                          weekDaysOfHabit.add(val);
                      });
                    }).toList(),
                  )),
                  Expanded(child: const Text("")),
                  Container(
                    height: minMargin * 25,
                    width: minMargin * 100,
                    margin: EdgeInsets.only(bottom: minMargin * 5),
                    child: RaisedButton(
                        child: const Text("Save"), onPressed: addHabit),
                  ),
                  Container(
                    height: minMargin * 25,
                    width: minMargin * 100,
                    margin: EdgeInsets.only(bottom: minMargin * 5),
                    child: FlatButton(
                      child: const Text(
                        "Delete habit",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        goHome();
//                        showDemoDialog(
//                          context: context,
//                          child: CupertinoAlertDialog(
//                            title: const Text(
//                                'Are you sure you want to delete habit?'),
//                            actions: <Widget>[
//                              CupertinoDialogAction(
//                                child: const Text("Stop"),
//                                onPressed: () => Navigator.pop(context)
//                                ,
//                              ),
//                              CupertinoDialogAction(
//                                child: const Text('Delete', style: TextStyle(color:Colors.red)),
//                                onPressed: () => Navigator.pop(context),
//                              ),
//                            ],
//                          ),
//                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  String textValidator(String text) {
    if (text == "" || text == null) return "This field cannot be empty!";
    return null;
  }

  void addHabit() {
    _formKey.currentState.save();
    user.addHabit(name, time, color, icon, weekDaysOfHabit);
    goHome();
  }

  void goHome() {
    Navigator.of(context).pushReplacement(
        PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return Home();
    }));
  }

  void showDemoDialog({BuildContext context, Widget child}) {
    showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => child).then((String value) {
      if (value != null) {
        return;
      }
    });
  }
}

class CheckBox extends StatefulWidget {
  bool isChecked;

  Widget child;
  double width;
  int value;

  Function(int val) onCheck;

  CheckBox(this.width, this.value, this.child, this.isChecked, this.onCheck);

  @override
  _CheckBoxState createState() =>
      _CheckBoxState(width, value, child, isChecked, onCheck);
}

class _CheckBoxState extends State<CheckBox> {
  bool isChecked;

  Widget child;
  double width;
  int value;

  Function(int val) onCheck;

  _CheckBoxState(
      this.width, this.value, this.child, this.isChecked, this.onCheck);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
      child: FlatButton(
          color: (isChecked)
              ? appColors[0].withOpacity(0.9)
              : Theme.of(context).primaryColor,
          onPressed: () {
            setState(() {
              isChecked = !isChecked;
              onCheck(value);
            });
          },
          child: this.child),
    );
  }
}

class TimePicker extends StatefulWidget {
  DateTime time;

  Function(DateTime time) onTimeChange;

  TimePicker(this.time, this.onTimeChange);

  @override
  _TimePickerState createState() =>
      _TimePickerState(time, onTimeChange);
}

class _TimePickerState extends State<TimePicker> {
  DateTime time;

  Function(DateTime time) onTimeChange;

  _TimePickerState(this.time, this.onTimeChange);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(minMargin * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            DateFormat('kk:mm').format(time),
            style: Theme.of(context).textTheme.body2,
          ),
          FlatButton(
              onPressed: () {
                DatePicker.showPicker(context, onConfirm: (date) {
                  setState(() {
                    time = date;
                    onTimeChange(time);
                  });
                },
                    pickerModel: TimePickerModel(),
                    theme: DatePickerTheme(
                        backgroundColor: Theme.of(context).primaryColor,
                        itemStyle: Theme.of(context).textTheme.body2,
                        cancelStyle: TextStyle(color: Colors.red)));
              },
              child: const Text(
                'Change',
                style: TextStyle(color: Colors.blue),
              )),
        ],
      ),
    );
  }
}

class TimePickerModel extends DateTimePickerModel {
  @override
  List<int> layoutProportions() {
    return [1, 1000, 1000];
  }
}
