import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'package:hatsoff/widgets/plus.dart';
import 'package:hatsoff/widgets/toDoTile.dart';
import 'package:provider/provider.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          Provider.of<ToDoProvider>(context).toDolist.length == 0
              ? SizedBox(height: height * 0.146)
              : SizedBox(height: height * 0.0387),
          Provider.of<ToDoProvider>(context).toDolist.length == 0
              ? Plus(true, 'task') // true is the value for _isbig
              : Plus(false, 'task'),
          Provider.of<ToDoProvider>(context).toDolist.length == 0
              ? SizedBox(height: height * 0.0394)
              : SizedBox(height: height * 0.01),
          if (Provider.of<ToDoProvider>(context).toDolist.length != 0)
            Container(
              height: height * 0.035,
              child: const Text(
                'add a new task',
                style: const TextStyle(
                    color: const Color(0xff717171),
                    fontFamily: 'Sofia',
                    fontWeight: FontWeight.w300,
                    fontSize: 21),
              ),
            ),
          if (Provider.of<ToDoProvider>(context).toDolist.length != 0)
            SizedBox(height: height * 0.011),
          Provider.of<ToDoProvider>(context).toDolist.length != 0
              ? Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: CustomScrollView(
                        slivers: List.generate(
                            Provider.of<ToDoProvider>(context).toDolist.length,
                            (i) => SliverToBoxAdapter(
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height * 0.0098,
                                          horizontal: width * 0.04),
                                      child: ToDoTile(
                                          Provider.of<ToDoProvider>(context)
                                              .toDolist[i]
                                              .id)),
                                )),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    height: height * 0.2,
                    width: width * 0.7,
                    child: Column(
                      children: [
                        AutoSizeText(
                          'add a new task',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Sofia',
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xff717171),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          width: width * 0.6,
                          child: AutoSizeText(
                            'Let today be the start \nof something new ',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'sofia',
                              fontSize: 21,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xffd9d8d8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
