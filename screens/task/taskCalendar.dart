import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'package:hatsoff/widgets/taskRecordsTile.dart';

class TaskCalendar extends StatefulWidget {
  final List<ToDo> taskList;

  TaskCalendar(this.taskList);
  @override
  _TaskCalendarState createState() => _TaskCalendarState();
}

class _TaskCalendarState extends State<TaskCalendar> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
              height:
                  widget.taskList.length != 0 ? height * 0.05 : height * 0.14),
          if (widget.taskList.length != 0)
            Expanded(
                child: Container(
              width: width * 0.72,
              child: CustomScrollView(
                slivers: List.generate(
                    widget.taskList.length,
                    (i) => SliverToBoxAdapter(
                        child: TaskRecordTile(widget.taskList[i]))),
              ),
            )),
          if (widget.taskList.length == 0)
            Container(
              width: width * 0.6,
              child: Column(children: [
                SizedBox(height: height * 0.15),
                const AutoSizeText(
                  'No results',
                  style: TextStyle(
                    fontFamily: 'Sofia Pro',
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: Color(0xff717171),
                  ),
                ),
                const AutoSizeText(
                  "You haven't scheduled any task yet!",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Sofia Pro',
                    fontSize: 21,
                    fontWeight: FontWeight.w300,
                    color: Color(0xffd9d8d8),
                  ),
                )
              ]),
            )
        ],
      ),
    );
  }
}
