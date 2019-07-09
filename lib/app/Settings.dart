import 'package:flutter/material.dart';
import 'package:habits_maker/globals.dart';

import 'Home.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.all(minMargin * 5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: minMargin * 40),
                  child: Text("Settings:",
                      style: Theme.of(context).textTheme.display1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: minMargin * 25,
                      width: minMargin * 80,
                      child: RaisedButton(
                          onPressed: () {
                            user.saveHabits();
                          },
                          child: const Text("Save")),
                    ),
                    Container(
                      height: minMargin * 25,
                      width: minMargin * 80,
                      child: RaisedButton(
                          onPressed: () {
                            user.loadHabits();
                          },
                          child: const Text("Load")),
                    ),
                  ],
                ),
                Container(
                  height: minMargin * 25,
                  width: minMargin * 100,
                  margin: EdgeInsets.only(bottom: minMargin * 5),
                  child: RaisedButton(
                      child: Text("Back"),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(PageRouteBuilder(
                            pageBuilder: (BuildContext context, _, __) {
                          return Home();
                        }));
                      }),
                )
              ],
            ),
          )),
    );
  }
}
