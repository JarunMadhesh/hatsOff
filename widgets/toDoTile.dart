import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'package:hatsoff/screens/task/checkTaskDone.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class ToDoTile extends StatefulWidget {
  final String id;

  ToDoTile(this.id);

  @override
  _ToDoTileState createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  ToDo _toDo;

  @override
  Widget build(BuildContext context) {
    _toDo = Provider.of<ToDoProvider>(context)
        .toDolist
        .firstWhere((each) => each.id == widget.id);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(CheckTaskDone.route, arguments: _toDo.id);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.0997,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(1000),
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
            Hero(
              tag: _toDo.id,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5493,
                child: Container(
                  padding: EdgeInsets.only(
                      left: width * 0.04,
                      top: height * 0.0246,
                      bottom: height * 0.0246,
                      right: width * 0.013),
                  child: AutoSizeText(
                    _toDo.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Sofia',
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff717171),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: width * 0.021, right: width * 0.05),
              alignment: Alignment.centerLeft,
              width: width * 0.16,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6)],
                  color: _toDo.dueDate.difference(DateTime.now()).isNegative? Color(0xffE4E4E4):Theme.of(context).splashColor,
                  borderRadius:
                      const BorderRadius.only(bottomRight: Radius.circular(100))),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  AutoSizeText(
                    DateFormat.MMMM().format(_toDo.dueDate),
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Sofia',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: _toDo.dueDate.difference(DateTime.now()).isNegative? Color(0xff717171):Colors.white,
                    ),
                  ),
                  AutoSizeText(
                    _toDo.dueDate.day<10? '0${_toDo.dueDate.day}':_toDo.dueDate.day.toString(),
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Sofia',
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: _toDo.dueDate.difference(DateTime.now()).isNegative? Color(0xff717171):Colors.white,
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
