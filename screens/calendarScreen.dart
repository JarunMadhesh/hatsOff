import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hatsoff/providers/habits.dart';
import 'package:hatsoff/providers/notificationsProvider.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'package:hatsoff/screens/habits/habitCalendar.dart';
import 'package:hatsoff/screens/splashScreen.dart';
import 'package:hatsoff/screens/task/taskCalendar.dart';
import 'package:hatsoff/widgets/errorDialog.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  static const route = 'CalendarScreen';
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<NotificationData> _recordList;
  List<ToDo> _taskList;
  int _selectedPage = 0;
  PageController _pageController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    try {
      Future.delayed(Duration(seconds: 0), () async {
        await Provider.of<ToDoProvider>(context, listen: false).getRecords();
      });
    } catch (e) {
      showDialog(context: context, child: ErrorDialog());
    }

    _pageController = PageController(initialPage: 0, keepPage: true);
    _recordList = Provider.of<HabitProvider>(context, listen: false).records;
    _taskList = Provider.of<ToDoProvider>(context, listen: false).records;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    _taskList = Provider.of<ToDoProvider>(context).records.reversed.toList();
    return _isLoading
        ? SplashScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    width: height * 0.035,
                    height: height * 0.035,
                    child: Icon(
                      Icons.arrow_back,
                      size: 34,
                      color: Color(0xff717171),
                    )),
              ),
              title: const AutoSizeText(
                'Records',
                style: TextStyle(
                  fontFamily: 'Sofia',
                  color: const Color(0xffe12909),
                  fontWeight: FontWeight.w300,
                  fontSize: 30,
                ),
              ),
            ),
            body: Column(
              children: <Widget>[
                SizedBox(height: height * 0.026),
                Center(
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.69,
                    padding: EdgeInsets.all(width * 0.005),
                    decoration: BoxDecoration(
                        color: const Color(0xffE4E4E4),
                        borderRadius:
                            BorderRadius.all(Radius.circular(height * 0.025)),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xff9F9F9F).withOpacity(0.16),
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
                            padding: EdgeInsets.all(4),
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
                                      color: const Color(0xff9F9F9F)
                                          .withOpacity(0.16),
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
                                    ? const Color(0xffffffff)
                                    : const Color(0xff737373),
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
                                      color: const Color(0xff9F9F9F)
                                          .withOpacity(0.16),
                                      blurRadius: 6,
                                      offset: Offset(6, 6)),
                              ],
                              color: _selectedPage == 1
                                  ? Theme.of(context).splashColor
                                  : const Color(0xffE4E4E4),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(height * 0.025)),
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
                ),
                SizedBox(height: height * 0.02),
                Expanded(
                    child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedPage = index;
                          });
                        },
                        children: [
                      HabitCalendar(_recordList),
                      TaskCalendar(_taskList)
                    ])),
              ],
            ),
          );
  }
}
