import 'dart:math';
import 'dart:ui';

import 'app/Habbit.dart';

var minMargin = 1.0;
User user = User();

var appColors = [
  Color.fromRGBO(255, 51, 0, 1.0),
  Color.fromRGBO(255, 153, 0, 1.0),
  Color.fromRGBO(255, 0, 102, 1.0),
  Color.fromRGBO(204, 51, 255, 1.0),
  Color.fromRGBO(102, 102, 255, 1.0),
  Color.fromRGBO(0, 255, 0, 1.0),
  Color.fromRGBO(255, 255, 0, 1.0),
  Color.fromRGBO(255, 0, 255, 1.0),
  Color.fromRGBO(255, 255, 255, 1.0),
];

var weekDays = [
  "Monday",
  "Tuesday",
  "Wedensday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

var appColorsLen = weekDays.length;

var habitsSample = [
  Habit("Running", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], "🏃🏼‍♂️", [6, 7]),
  Habit("Medicines", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], "💊️", [3, 5]),
  Habit("Yoga", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], "️ 🤸🏻‍♂️", [4, 5, 7, 1]),
  Habit("Lessons", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], "️ 👨🏻‍🏫", [2]),
  Habit("Writing", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], "✍🏻", [4]),
  Habit("Gym", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], " 🏋🏻‍♀️️", [3, 5, 2]),
  Habit("Swimming", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], " 🏊🏻‍♀️", [3]),
  Habit("Biking", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], " 🚴🏻‍♂️", [5, 4]),
  Habit("Cinema", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], " 🎬", [7]),
  Habit("Drums", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], " 🥁️", [1]),
  Habit("Guitar", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], " 🎸", [2, 6]),
  Habit("Work", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], " 🚜", [6]),
  Habit("Meditation", DateTime(1, 1, 1, Random().nextInt(23)), 0, false,
      appColors[Random().nextInt(appColorsLen)], " 🧘🏻‍♂️️", [4, 7, 2]),
];
