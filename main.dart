import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'providers/toDo.dart';
import 'screens/task/addTask.dart';
import 'screens/task/checkTaskDone.dart';
import 'package:provider/provider.dart';

import 'screens/enterName.dart';
import 'screens/splashScreen.dart';
import 'providers/habits.dart';
import 'providers/user.dart';
import 'screens/habits/addHabitScreen.dart';
import 'screens/changeNameScreen.dart';
import 'screens/habits/checkDoneScreen.dart';
import 'screens/calendarScreen.dart';
import 'screens/homeScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ToDoProvider()),
      ],
      child: MaterialApp(
        title: 'Hats Off',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          splashColor: const Color(0xffe12909),
          backgroundColor: Colors.white,
          accentColor: Color(0xffe12909),
        ),
        home: Wrapper(),
        routes: {
          ChangeName.route: (ctx) => ChangeName(),
          CheckDone.route: (ctx) => CheckDone(),
          AddHabit.route: (ctx) => AddHabit(),
          AddTask.route: (ctx) => AddTask(),
          CalendarScreen.route: (ctx) => CalendarScreen(),
          CheckTaskDone.route: (ctx) => CheckTaskDone(),
        },
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isloading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0), () async {
      await Provider.of<UserProvider>(context, listen: false)
          .checkandsetName()
          .then((_) {
        _isloading = false;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? SplashScreen()
        : Provider.of<UserProvider>(context).name == null
            ? EnterName()
            : HomeScreen();
  }
}
