import 'dart:ui';

import 'app/Habbit.dart';

int notificationID = 0;

double minMargin = 1.0;
User user = User();

int appColorsLen = weekDays.length;

List<Color> appColors = [
  Color.fromRGBO(255, 51, 0, 1.0),
  Color.fromRGBO(255, 153, 0, 1.0),
  Color.fromRGBO(255, 0, 102, 1.0),
  Color.fromRGBO(204, 51, 255, 1.0),
  Color.fromRGBO(102, 102, 255, 1.0),
  Color.fromRGBO(46, 204, 64, 1.0),
  Color.fromRGBO(255, 230, 50, 1.0),
  Color.fromRGBO(255, 0, 255, 1.0),
  Color.fromRGBO(57, 121, 150, 1.0),
  Color.fromRGBO(49, 79, 112, 1.0),
  Color.fromRGBO(246, 114, 128, 1.0),
  Color.fromRGBO(69, 173, 168, 1.0),
  Color.fromRGBO(157, 224, 173, 1.0),
  Color.fromRGBO(255, 65, 54, 1.0),
  Color.fromRGBO(255, 133, 27, 1.0),
  Color.fromRGBO(177, 13, 201, 1.0),
  Color.fromRGBO(0, 116, 217, 1.0),
  Color.fromRGBO(255, 220, 0, 1.0),
  Color.fromRGBO(240, 18, 190, 1.0),
];

List<String> weekDays = [
  "Monday",
  "Tuesday",
  "Wedensday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

List<String> cheeringUpTexts = [
  "Come on you can do it!",
  "Get some streak on this one!"
  "Come on lazy one!",
  "Don't waste your time - keep doing habits!",
  "Don't let it go!",
  "It won't take long! Just do it!"
];
