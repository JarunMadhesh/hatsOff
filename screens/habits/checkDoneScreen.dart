import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hatsoff/screens/habits/addHabitScreen.dart';
import 'package:hatsoff/widgets/confirmDeleteDialog.dart';
import 'package:provider/provider.dart';

import '../../providers/habits.dart';
import '../splashScreen.dart';
import '../../widgets/appreciationDialog.dart';
import '../../widgets/errorDialog.dart';

class CheckDone extends StatefulWidget {
  static const route = '/CheckDone';
  @override
  _CheckDoneState createState() => _CheckDoneState();
}

class _CheckDoneState extends State<CheckDone> {
  String _id;
  Habit _habit;

  @override
  Widget build(BuildContext context) {
    _id = ModalRoute.of(context).settings.arguments;
    if (_id != null) {
      _habit = Provider.of<HabitProvider>(context)
          .habits
          .firstWhere((test) => test.id == _id, orElse: () => null);
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return _habit == null
        ? SplashScreen()
        : Scaffold(
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
              title: Hero(
                tag: _habit.id,
                child: AutoSizeText(
                  _habit.name,
                  style: const TextStyle(
                    fontFamily: 'Sofia',
                    color: const Color(0xffe12909),
                    fontWeight: FontWeight.w300,
                    fontSize: 28,
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  tooltip: 'Edit Habit',
                  icon: const Icon(Icons.edit),
                  color: Color(0xff717171),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AddHabit.route, arguments: _habit);
                  },
                ),
                IconButton(
                  tooltip: 'Delete Habit',
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: ConfirmDelete(habit: _habit),
                    );
                  },
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).splashColor,
                ),
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            body: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).viewInsets.bottom == 0
                        ? height * 0.89
                        : height * 0.89 -
                            MediaQuery.of(context).viewInsets.bottom,
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView(children: [
                        SizedBox(height: height * 0.1268),
                        Center(
                          child: Container(
                            width: height * 0.346,
                            height: height * 0.346,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                boxShadow: [
                                  const BoxShadow(
                                      blurRadius: 6,
                                      offset: Offset(6, 6),
                                      color:
                                          Color.fromRGBO(159, 159, 159, 0.16))
                                ],
                                borderRadius:
                                    BorderRadius.circular(height * 0.346 / 2),
                                border: Border.all(
                                  width: 2,
                                  color: Provider.of<HabitProvider>(context)
                                          .isDone(_habit.id)
                                      ? Color(0xff85E21E)
                                      : Theme.of(context).splashColor,
                                )),
                            child: Transform.scale(
                              scale: 1.3,
                              child: SvgPicture.asset(
                                'assets/icons/tick.svg',
                                fit: BoxFit.none,
                                color: Provider.of<HabitProvider>(context)
                                        .isDone(_habit.id)
                                    ? Color(0xff85E21E)
                                    : Theme.of(context).splashColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.11),
                        Center(
                          child: Container(
                            width: width * 0.512,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                !Provider.of<HabitProvider>(context)
                                        .isDone(_habit.id)
                                    ? Container(
                                        width: width * 0.752,
                                        height: height * 0.0739,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xffE5E2E2)),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            boxShadow: [
                                              const BoxShadow(
                                                  color: Color.fromRGBO(
                                                      159, 159, 159, 0.14),
                                                  blurRadius: 6,
                                                  offset: Offset(6, 6))
                                            ]),
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () async {
                                            try {
                                              await Provider.of<HabitProvider>(
                                                      context,
                                                      listen: false)
                                                  .setDone(_habit.id)
                                                  .then((isAdded) {
                                                if (isAdded) {
                                                  showDialog(
                                                      context: context,
                                                      child: AppreciationScreen(
                                                          habit: _habit));
                                                }
                                              });
                                            } catch (e) {
                                              showDialog(
                                                  context: context,
                                                  child: ErrorDialog());
                                            }
                                          },
                                          child: const Text(
                                            'I did it ',
                                            style: TextStyle(
                                              fontFamily: 'sofia',
                                              fontSize: 26,
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xffe12909),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Container(
                                          width: width * 0.752,
                                          height: height * 0.0739,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xffE5E2E2)),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromRGBO(
                                                        159, 159, 159, 0.14),
                                                    blurRadius: 6,
                                                    offset: Offset(6, 6))
                                              ]),
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () async {
                                              try {
                                                await Provider.of<
                                                            HabitProvider>(
                                                        context,
                                                        listen: false)
                                                    .setNotDone(_habit.id);
                                              } catch (e) {
                                                showDialog(
                                                    context: context,
                                                    child: ErrorDialog());
                                              }
                                            },
                                            child: const Text(
                                              'Undo',
                                              style: TextStyle(
                                                fontFamily: 'sofia',
                                                fontSize: 22,
                                                fontWeight: FontWeight.w300,
                                                color: const Color(0xff333232),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
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
