import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'package:provider/provider.dart';

import '../providers/habits.dart';
import 'errorDialog.dart';

class ConfirmDelete extends StatelessWidget {
  final Habit habit;
  final ToDo toDo;

  ConfirmDelete({this.habit, this.toDo});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      elevation: 15,
      contentPadding: EdgeInsets.all(0),
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: height * 0.037),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffF7F7F7)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 15,
                  offset: Offset(15, 15),
                  color: Color.fromRGBO(134, 131, 131, 0.1))
            ]),
        width: width * 0.645,
        height: height * 0.2606,
        child: Column(
          children: <Widget>[
            Center(
                child: Container(
              height: height * 0.0418,
              child: const AutoSizeText(
                'Are you sure ?',
                style: TextStyle(
                  fontFamily: 'Sofia',
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff717171),
                ),
              ),
            )),
            SizedBox(height: height * 0.0098),
            Container(
              height: height * 0.0603,
              width: width * 0.5,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Color(0xffE5E2E2)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6,
                      offset: Offset(6, 6),
                      color: Color.fromRGBO(159, 159, 159, 0.16))
                ],
              ),
              child: RaisedButton(
                color: Colors.white,
                onPressed: () async {
                  try {
                    if (habit != null) {
                      await Provider.of<HabitProvider>(context, listen: false)
                          .deleteHabit(habit.id);
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();
                    } else {
                      Provider.of<ToDoProvider>(context, listen: false)
                          .deleteTask(toDo);
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    showDialog(context: context, child: ErrorDialog());
                  }
                },
                child: const AutoSizeText(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'sofia',
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xffe12909),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.0098),
            Container(
              height: height * 0.0615,
              width: width * 0.5,
              decoration: BoxDecoration(
                color: Theme.of(context).splashColor,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Color(0xffE5E2E2)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6,
                      offset: Offset(6, 6),
                      color: Color.fromRGBO(159, 159, 159, 0.16))
                ],
              ),
              child: RaisedButton(
                color: Theme.of(context).splashColor,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const AutoSizeText(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'sofia',
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
