import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habits.dart';
import '../screens/habits/checkDoneScreen.dart';

class HabitTile extends StatefulWidget {
  final String id;
  // final int index;

  HabitTile(this.id);

  @override
  _HabitTileState createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  Habit _habit;

  @override
  Widget build(BuildContext context) {
    _habit = Provider.of<HabitProvider>(context)
        .habits
        .firstWhere((each) => each.id == widget.id);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(CheckDone.route, arguments: _habit.id);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.0997,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(1000),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: const Color.fromRGBO(229, 226, 226, 1),
          ),
          boxShadow: [
            BoxShadow(
                color: const Color.fromRGBO(134, 131, 131, 0.42),
                blurRadius: 6,
                offset: Offset(6, 6))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: width * 0.021),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.16,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6)],
                  color: Provider.of<HabitProvider>(context).isDone(_habit.id)
                      ? Color(0xff48c52c)
                      : Theme.of(context).splashColor,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100))),
              child: Container(
                  // child:
                  // Text(
                  //   _habit.streek < 10
                  //       ? '0${_habit.streek}'
                  //       : _habit.streek.toString(),
                  //   style: TextStyle(
                  //       fontFamily: 'Sofia',
                  //       fontWeight: FontWeight.w300,
                  //       fontSize: 24,
                  //       color: Theme.of(context).primaryColor),
                  // ),
                  ),
            ),
            Hero(
              tag: _habit.id,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5493,
                child: Container(
                  padding: EdgeInsets.only(
                      left: width * 0.04,
                      top: height * 0.0246,
                      bottom: height * 0.0246,
                      right: width * 0.013),
                  child: AutoSizeText(
                    _habit.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Sofia',
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff717171),
                    ),
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
