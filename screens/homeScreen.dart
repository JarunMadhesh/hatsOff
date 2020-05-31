import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'package:hatsoff/screens/calendarScreen.dart';
import 'package:hatsoff/screens/habits/habitScreen.dart';
import 'package:hatsoff/screens/task/checkTaskDone.dart';
import 'package:hatsoff/screens/task/toDoScreen.dart';
import 'package:provider/provider.dart';

import '../widgets/errorDialog.dart';
import '../providers/habits.dart';
import '../providers/user.dart';
import 'changeNameScreen.dart';
import 'habits/checkDoneScreen.dart';
import 'splashScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  int _selectedPage = 0;
  PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  Future onSelectNotification(String payload) async {
    final purpose = payload.substring(0, 5);
    final habitid = payload.substring(6, payload.length);

    if (purpose == 'habit') {
      try {
        await Provider.of<HabitProvider>(context, listen: false)
            .getHabit()
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        }).then((_) {
          Navigator.of(context).pushNamed(CheckDone.route, arguments: habitid);
        });
      } catch (e) {
        showDialog(context: context, child: ErrorDialog());
      }
    } else {
      try {
        await Provider.of<ToDoProvider>(context, listen: false)
            .getTasks()
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        }).then((_) => {
                  Navigator.of(context)
                      .pushNamed(CheckTaskDone.route, arguments: habitid)
                });
      } catch (e) {
        showDialog(context: context, child: ErrorDialog());
      }
    }
  }

  @override
  void initState() {
    //initialization for local notification
    var android = new AndroidInitializationSettings('logo');
    var ios = new IOSInitializationSettings();
    var initSetting = new InitializationSettings(android, ios);
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    //I used future function to make sure theses happen
    //before the app starts running
    Future.delayed(Duration(seconds: 0), () async {
      try {
        //actual initialization for local notifucation
        await _flutterLocalNotificationsPlugin.initialize(initSetting,
            onSelectNotification: (str) => onSelectNotification(str));
        await Provider.of<ToDoProvider>(context, listen: false)
            .getTasks()
            .then((value) async {
          await Provider.of<HabitProvider>(context, listen: false).getHabit();
        }).then((_) {
          _isLoading = false;
          setState(() {});
        });
      } catch (e) {
        showDialog(context: context, child: ErrorDialog());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_pageController != null) _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Widget habitTaskSwitch() {
      return Center(
        child: Container(
          height: height * 0.05,
          width: width * 0.69,
          padding: EdgeInsets.all(width * 0.005),
          decoration: BoxDecoration(
              color: Color(0xffE4E4E4),
              borderRadius: BorderRadius.all(Radius.circular(height * 0.025)),
              boxShadow: [
                BoxShadow(
                    color: Color(0xff9F9F9F).withOpacity(0.16),
                    blurRadius: 6,
                    offset: Offset(6, 6))
              ]),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (_pageController.page == 0) return;
                  setState(() {
                    _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInCubic);
                  });
                },
                child: Container(
                  width: width * 0.335,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _selectedPage == 0
                        ? Theme.of(context).splashColor
                        : Color(0xffE4E4E4),
                    borderRadius: BorderRadius.all(
                      Radius.circular(height * 0.025),
                    ),
                    boxShadow: [
                      if (_selectedPage == 0)
                        BoxShadow(
                            color: const Color(0xff9F9F9F).withOpacity(0.16),
                            blurRadius: 6,
                            offset: Offset(6, 6)),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    'Habit ',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Sofia Pro',
                      fontSize: 21,
                      fontWeight: FontWeight.w300,
                      color: _selectedPage == 0
                          ? Color(0xffffffff)
                          : Color(0xff737373),
                    ),
                  ),
                ),
              ),
              SizedBox(width: width * 0.01),
              GestureDetector(
                onTap: () {
                  if (_pageController.page == 1) return;
                  setState(() {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInCubic);
                  });
                },
                child: Container(
                  width: width * 0.335,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    boxShadow: [
                      if (_selectedPage == 1)
                        BoxShadow(
                            color: const Color(0xff9F9F9F).withOpacity(0.16),
                            blurRadius: 6,
                            offset: const Offset(6, 6)),
                    ],
                    color: _selectedPage == 1
                        ? Theme.of(context).splashColor
                        : const Color(0xffE4E4E4),
                    borderRadius:
                        BorderRadius.all(Radius.circular(height * 0.025)),
                  ),
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    'Task',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Sofia Pro',
                      fontSize: 21,
                      fontWeight: FontWeight.w300,
                      color: _selectedPage == 1
                          ? const Color(0xffffffff)
                          : const Color(0xff737373),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _isLoading
        ? SplashScreen()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CalendarScreen.route);
                },
                tooltip: 'Records',
                icon: const Icon(Icons.calendar_today),
                color: const Color(0xff717171),
              ),
              centerTitle: true,
              title: const AutoSizeText(
                'Hats Off',
                style: const TextStyle(
                  fontFamily: 'Sofia',
                  color: const Color(0xffe12909),
                  fontWeight: FontWeight.w300,
                  fontSize: 32,
                ),
              ),
              actions: <Widget>[
                Transform.scale(
                  scale: 1.1,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ChangeName.route);
                    },
                    icon: Hero(
                        transitionOnUserGestures: false,
                        tag: 'settings',
                        child: const Icon(Icons.settings)),
                    color: const Color(0xff717171),
                    tooltip: 'Settings',
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<ToDoProvider>(context, listen: false)
                        .getTasks();
                    await Provider.of<HabitProvider>(context, listen: false)
                        .getHabit();
                  },
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: height * 0.89,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: height * 0.0344),
                            Container(
                              width: double.infinity,
                              height: height * 0.048,
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft:
                                          Radius.circular(height * 0.058)),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 3))
                                  ],
                                ),
                                width: width * 0.55,
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      right: width * 0.04, left: width * 0.02),
                                  alignment: Alignment.centerRight,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(50)),
                                      color: Colors.white),
                                  width: width * 0.55,
                                  child: AutoSizeText(
                                    'Hey ${Provider.of<UserProvider>(context).name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Sofia',
                                      color: const Color(0xff717171),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.024,
                            ),
                            habitTaskSwitch(),
                            Container(
                              height: height * 0.733,
                              child: PageView(
                                controller: _pageController,
                                physics: BouncingScrollPhysics(),
                                onPageChanged: (int i) {
                                  setState(() {
                                    _selectedPage = i;
                                  });
                                },
                                children: <Widget>[
                                  HabitScreen(),
                                  ToDoScreen(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
