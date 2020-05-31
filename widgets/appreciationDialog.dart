import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'package:provider/provider.dart';
import '../providers/appreciationSentences.dart';
import '../providers/habits.dart';

class AppreciationScreen extends StatefulWidget {
  final Habit habit;
  final ToDo toDo;

  AppreciationScreen({this.habit, this.toDo});

  @override
  _AppreciationScreenState createState() => _AppreciationScreenState();
}

class _AppreciationScreenState extends State<AppreciationScreen> {
  bool _isAppreciationShown = false;

  @override
  void initState() {
    super.initState();
    if (widget.toDo == null) {
      _isAppreciationShown = true;
    } else {
      if (widget.toDo.treat.length != 0) {
        _isAppreciationShown = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      elevation: 15,
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: Theme.of(context).splashColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Container(
          decoration: BoxDecoration(boxShadow: [
            const BoxShadow(
                blurRadius: 15,
                offset: Offset(15, 15),
                color: Color.fromRGBO(134, 131, 131, 0.1))
          ]),
          width: width * 0.853,
          height: _isAppreciationShown? height * 0.534: height * 0.4,
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.054,
                    ),
                    Container(
                      height: height * 0.137,
                      width: height * 0.157,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).splashColor,
                        ),
                      ),
                      child: Transform.scale(
                        scale: 1.3,
                        child: Image.asset(
                          'assets/transRedLogo.png',
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    const AutoSizeText(
                      'Hats off\n to you !',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontFamily: 'Sofia',
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffffffff),
                      ),
                    ),
                    SizedBox(height: height * 0.022),
                    if (_isAppreciationShown)
                      Center(
                          child: Container(
                        margin: EdgeInsets.only(left: width * 0.045),
                        padding: EdgeInsets.only(
                            left: width * 0.053,
                            top: height * 0.016,
                            bottom: height * 0.016,
                            right: 20),
                        width: width * 0.7,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(height * 0.093))),
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          AppreciationProvider().getAppreciation(
                              widget.toDo == null ? widget.habit.streek : 19,
                              widget.toDo == null
                                  ? widget.habit.treat
                                  : widget.toDo.treat),
                          style: const TextStyle(
                            fontFamily: 'Sofia',
                            fontSize: 21,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xfff52d0a),
                          ),
                        ),
                      )),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    if (widget.toDo != null) {
                      await Provider.of<ToDoProvider>(context, listen: false)
                          .setDone(widget.toDo);
                    }
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: height * 0.08,
                    width: height * 0.08,
                    child: Transform.scale(
                      scale: 1,
                      child: SvgPicture.asset(
                        'assets/icons/cross.svg',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
