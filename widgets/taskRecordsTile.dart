import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'package:intl/intl.dart';

class TaskRecordTile extends StatelessWidget {
  final ToDo _toDo;

  const TaskRecordTile(this._toDo);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 80,
      width: width * 0.55,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(100),
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
            width: width * 0.51,
            height: 80,
            child: Container(
              padding: EdgeInsets.only(
                left: width * 0.04,
                top: 9,
                bottom: 3,
                right: width * 0.013,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText(
                    _toDo.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Sofia',
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff717171),
                    ),
                  ),
                  SizedBox(height: height * 0.001),
                  AutoSizeText(
                    'Start date: ${DateFormat.MMMMd().format(_toDo.startTime)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Sofia',
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff949494),
                    ),
                  ),
                  AutoSizeText(
                    'Due date: ${DateFormat.MMMMd().format(_toDo.dueDate)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Sofia',
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff949494),
                    ),
                  ),
                  if (_toDo.doneTime != null)
                    AutoSizeText(
                      'Task completed on ${DateFormat.MMMd().format(_toDo.doneTime)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Sofia',
                        fontWeight: FontWeight.w300,
                        color: const Color(0xff949494),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: width * 0.021),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.18,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6)],
                color: _toDo.doneTime != null
                    ? const Color(0xff48c52c)
                    : _toDo.dueDate.difference(DateTime.now()).isNegative
                        ? const Color(0xffE4E4E4)
                        : Theme.of(context).splashColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50))),
          ),
        ],
      ),
    );
  }
}
