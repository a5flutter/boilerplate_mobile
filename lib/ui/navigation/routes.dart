import 'package:blank_project/ui/navigation/screens.dart';
import 'package:blank_project/ui/screens/initial_screen/initial_screen.dart';
import 'package:blank_project/ui/screens/main_screen/main_screen.dart';
import 'package:blank_project/ui/screens/screen_1/screen_1.dart';
import 'package:blank_project/ui/screens/screen_2/screen_2.dart';
import 'package:blank_project/ui/screens/screen_3/screen_3.dart';
import 'package:blank_project/ui/screens/screen_4/screen_4.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(dynamic)> appRoutes = {
  //Screens
  Screens.initial: (ctx) => InitialScreen(),
  ///Wrapped route example. Can be used to wrap screen into the some bloc
  Screens.main: (ctx) => const MainScreen().wrappedRoute(),

  //Nested pages
  Screens.screen1: (ctx) => const Screen1(),
  Screens.screen2: (ctx) => const Screen2(),
  Screens.screen3: (ctx) => const Screen3(),
  Screens.screen4: (ctx) => const Screen4(),

};
