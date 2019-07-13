import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habits_maker/app/Habbit.dart';

import 'app/Home.dart';
import 'globals.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    user.loadHabits();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, IOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload $payload");
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Payload"),
              content: const Text("Payload"),
            ));
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.paused || user.habits.length > 0)
        user.saveHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    flutterLocalNotificationsPlugin.cancelAll();
    return MaterialApp(debugShowCheckedModeBanner: false, home: Main());
  }
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    minMargin = MediaQuery.of(context).size.width / 200;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Color.fromRGBO(20, 20, 20, 1.0),
            accentColor: Colors.white70,
            scaffoldBackgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
            textTheme: TextTheme(
              display1: TextStyle(
                  color: Colors.white,
                  fontSize: minMargin * 30,
                  fontFamily: "Mainfont",
                  fontWeight: FontWeight.w900),
              display2: TextStyle(
                  color: Colors.white,
                  fontSize: minMargin * 24,
                  fontFamily: "Mainfont",
                  fontWeight: FontWeight.w900),
              display3: TextStyle(
                color: Colors.white,
                fontSize: minMargin * 9,
                fontFamily: "MainFont",
              ),
              body1: TextStyle(
                color: Colors.white,
                fontFamily: "MainFont",
              ),
              body2: TextStyle(
                color: Colors.white,
                fontSize: minMargin * 11,
                fontFamily: "MainFont",
              ),
              button: TextStyle(
                fontSize: minMargin * 10,
                fontFamily: "MainFont",
              ),
            ),
            buttonTheme: ButtonThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              buttonColor: appColors[0],
            ),
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                  borderRadius: BorderRadius.circular(30.0)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                  borderRadius: BorderRadius.circular(30.0)),
            )),
        home: Home());
  }
}
