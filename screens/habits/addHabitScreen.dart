import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../providers/habits.dart';
import '../../widgets/errorDialog.dart';

class AddHabit extends StatefulWidget {
  static const route = '/AddHabitName';
  @override
  _AddHabitState createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  FocusNode _nameFocusNode;
  FocusNode _switchFocusNode;
  FocusNode _treatFocusNode;

  String _pageTitle;
  String _buttonTitle;
  String _habitName;
  bool check = true;
  String _treat;
  bool _isReminderOn = false;
  TimeOfDay _reminderTime = TimeOfDay(hour: 21, minute: 00);
  Habit _tempHabit;

  void onSubmit() async {
    if (!_formKey1.currentState.validate() ||
        !_formKey2.currentState.validate()) {
      return;
    }
    try {
      if (_pageTitle == 'New Habit') {
        if (_isReminderOn) {
          await Provider.of<HabitProvider>(context, listen: false).addHabit(
              Habit(DateTime.now().toString(), _habitName, 0, false, _treat,
                  reminderTime: _reminderTime));
        } else {
          await Provider.of<HabitProvider>(context, listen: false).addHabit(
              Habit(DateTime.now().toString(), _habitName, 0, false, _treat));
        }
      } else {
        if (_isReminderOn) {
          Provider.of<HabitProvider>(context, listen: false).editHabit(Habit(
              _tempHabit.id,
              _habitName,
              _tempHabit.streek,
              _tempHabit.isDone,
              _treat,
              reminderTime: _reminderTime));
        } else {
          Provider.of<HabitProvider>(context, listen: false).editHabit(Habit(
              _tempHabit.id,
              _habitName,
              _tempHabit.streek,
              _tempHabit.isDone,
              _treat));
        }
      }
    } catch (e) {
      showDialog(context: context, child: ErrorDialog());
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();

    _nameFocusNode = FocusNode();
    _switchFocusNode = FocusNode();
    _treatFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    if (_nameFocusNode != null) _nameFocusNode.dispose();
    if (_switchFocusNode != null) _switchFocusNode.dispose();
    if (_treatFocusNode != null) _treatFocusNode.dispose();
    if (_formKey1.currentState != null) _formKey1.currentState.dispose();
    if (_formKey2.currentState != null) _formKey2.currentState.dispose();
  }

  @override
  void didChangeDependencies() {
    if (check) {
      _tempHabit = ModalRoute.of(context).settings.arguments;
      if (_tempHabit != null) {
        _pageTitle = 'Edit Habit';
        _buttonTitle = 'Change';
        _habitName = _tempHabit.name;
        _treat = _tempHabit.treat;
        _reminderTime = _tempHabit.reminderTime != null
            ? _tempHabit.reminderTime
            : TimeOfDay(hour: 21, minute: 0);
        if (_tempHabit.reminderTime != null) {
          _isReminderOn = true;
        } else {
          _isReminderOn = false;
        }
      } else {
        _pageTitle = 'New Habit';
        _buttonTitle = 'Start';
      }
      check = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
        title: AutoSizeText(
          _pageTitle,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Sofia',
            color: const Color(0xffe12909),
            fontWeight: FontWeight.w300,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).viewInsets.bottom == 0
                ? height * 0.87
                : height * 0.87 - MediaQuery.of(context).viewInsets.bottom,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(
                children: [
                  MediaQuery.of(context).viewInsets.bottom == 0
                      ? SizedBox(height: height * 0.0615)
                      : SizedBox(height: height * 0.0415),
                  Center(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Form(
                            key: _formKey1,
                            child: Container(
                              width: width * 0.781,
                              child: TextFormField(
                                focusNode: _nameFocusNode,
                                initialValue: _habitName ?? _habitName,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: const TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff717171),
                                ),
                                cursorColor: Theme.of(context).splashColor,
                                cursorWidth: 2,
                                showCursor: true,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (str) {
                                  FocusScope.of(context)
                                      .requestFocus(_switchFocusNode);
                                },
                                onChanged: (str) {
                                  _habitName = str;
                                },
                                validator: (str) {
                                  if (str.trim().length == 0)
                                    return 'Please enter a habit name';
                                  if (str.length > 15)
                                    return 'Please enter a short habit name';
                                  if (Provider.of<HabitProvider>(context,
                                              listen: false)
                                          .checkIftheNameAlreadyExists(str) &&
                                      _pageTitle != 'Edit Habit')
                                    return 'You already have a habit with this name';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  fillColor: const Color(0xffF7F7F7),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromRGBO(
                                              229, 226, 226, 1)),
                                      borderRadius: BorderRadius.circular(3)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromRGBO(
                                              229, 226, 226, 1)),
                                      borderRadius: BorderRadius.circular(3)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                      borderRadius: BorderRadius.circular(3)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromRGBO(
                                              229, 226, 226, 1)),
                                      borderRadius: BorderRadius.circular(3)),
                                  hintText: 'habit name',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Sofia',
                                    fontSize: 26,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xffbfbcbc),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.056),
                          Container(
                            width: width * 0.781,
                            height: height * 0.082,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(width * width * 0.181)),
                                boxShadow: [
                                  const BoxShadow(
                                      blurRadius: 6,
                                      offset: Offset(6, 6),
                                      color: const Color.fromRGBO(
                                          159, 159, 159, 0.16))
                                ],
                                border: Border.all(
                                  color: const Color(0xffE5E2E2),
                                )),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: <
                                    Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).splashColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(width * 0.181))),
                                width: width * 0.181,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: width * 0.02),
                                child: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                              Container(
                                width: width * 0.59,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText(
                                        _isReminderOn
                                            ? '${_reminderTime.format(context)}'
                                            : 'Reminder',
                                        style: const TextStyle(
                                          fontFamily: 'Sofia',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w300,
                                          color: const Color(0xff717171),
                                        ),
                                      ),
                                      Spacer(),
                                      if (_isReminderOn)
                                        InkWell(
                                          onTap: () async {
                                            await DatePicker.showTime12hPicker(
                                              context,
                                              showTitleActions: true,
                                              onConfirm: (time) {
                                                _reminderTime = TimeOfDay(
                                                    hour: time.hour,
                                                    minute: time.minute);
                                              },
                                              currentTime: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                                _reminderTime.hour,
                                                _reminderTime.minute,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: const Color(
                                                        0xff717171)),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        height * 0.02),
                                                color: const Color(0xffF7F7F7)),
                                            height: height * 0.03,
                                            width: height * 0.03,
                                            alignment: Alignment.topCenter,
                                            child: Transform.scale(
                                              scale: 0.6,
                                              child: const Icon(
                                                Icons.edit,
                                                color: Color(0xff717171),
                                              ),
                                            ),
                                          ),
                                        ),
                                      Container(
                                          child: Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                            activeColor:
                                                Theme.of(context).splashColor,
                                            value: _isReminderOn,
                                            onChanged: (val) async {
                                              _isReminderOn = val;
                                              setState(() {});
                                              if (!val) return;
                                              await DatePicker
                                                  .showTime12hPicker(
                                                context,
                                                showTitleActions: true,
                                                theme: DatePickerTheme(
                                                    doneStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .splashColor)),
                                                onConfirm: (time) {
                                                  _reminderTime = TimeOfDay(
                                                      hour: time.hour,
                                                      minute: time.minute);
                                                },
                                                currentTime: DateTime.now(),
                                              );
                                              setState(() {});
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _treatFocusNode);
                                            }),
                                      )),
                                    ]),
                              )
                            ]),
                          ),
                          SizedBox(height: height * 0.022),
                          // if (_isReminderOn)
                          //   Container(
                          //     width: width * 0.781,
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       'you will be reminded on ${_reminderTime.format(context)}',
                          //       style: TextStyle(
                          //         fontFamily: 'Sofia',
                          //         fontSize: 18,
                          //         fontWeight: FontWeight.w300,
                          //         color: const Color(0xff717171),
                          //       ),
                          //     ),
                          //   ),
                          SizedBox(height: height * 0.0294),
                          Container(
                            width: width * 0.781,
                            height: height * 0.082,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(width * width * 0.181)),
                                boxShadow: [
                                  const BoxShadow(
                                      blurRadius: 6,
                                      offset: Offset(6, 6),
                                      color:
                                          Color.fromRGBO(159, 159, 159, 0.16))
                                ],
                                border: Border.all(
                                  color: const Color(0xffE5E2E2),
                                )),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).splashColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                width * 0.181))),
                                    width: width * 0.181,
                                    alignment: Alignment.centerRight,
                                    padding:
                                        EdgeInsets.only(right: width * 0.04),
                                    child: SvgPicture.asset(
                                      'assets/icons/icecream.svg',
                                      width: 36,
                                      height: 36.84,
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.59,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.03),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const AutoSizeText(
                                            'Treat yourself ',
                                            style: TextStyle(
                                              fontFamily: 'Sofia',
                                              fontSize: 24,
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xff717171),
                                            ),
                                          ),
                                          // Switch(value: null, onChanged: (val) {}),
                                        ]),
                                  )
                                ]),
                          ),
                          SizedBox(height: height * 0.022),
                          Container(
                            width: width * 0.781,
                            alignment: Alignment.centerLeft,
                            child: const AutoSizeText(
                              'what do you like to treat \nyourself with ?',
                              maxLines: 2,
                              style: TextStyle(
                                fontFamily: 'Sofia',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff717171),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.028),
                          Form(
                            key: _formKey2,
                            child: Container(
                              width: width * 0.781,
                              height: height * 0.1,
                              child: TextFormField(
                                focusNode: _treatFocusNode,
                                showCursor: true,
                                cursorColor: Theme.of(context).splashColor,
                                cursorWidth: 1,
                                style: const TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff717171),
                                ),
                                validator: (str) {
                                  if (str.trim().length == 0)
                                    return 'Treat yourself with something.\nDont leave it blank';
                                  if (str.length > 15)
                                    return 'Have short goals!';
                                  return null;
                                },
                                onFieldSubmitted: (str) {
                                  _treat = str;
                                  onSubmit();
                                },
                                onChanged: (str) {
                                  _treat = str;
                                },
                                initialValue: _treat ?? _treat,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromRGBO(
                                              229, 226, 226, 1)),
                                      borderRadius: BorderRadius.circular(3)),
                                  fillColor: Theme.of(context).primaryColor,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromRGBO(
                                              229, 226, 226, 1)),
                                      borderRadius: BorderRadius.circular(3)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromRGBO(
                                              229, 226, 226, 1)),
                                      borderRadius: BorderRadius.circular(3)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.redAccent),
                                      borderRadius: BorderRadius.circular(3)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromRGBO(
                                              229, 226, 226, 1)),
                                      borderRadius: BorderRadius.circular(3)),
                                  hintText: 'ice cream, movie etc…',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Sofia',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xffbfbcbc),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.06),
                          Center(
                            child: Container(
                              width: width * 0.498,
                              height: height * 0.0615,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffE5E2E2)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: const Color.fromRGBO(
                                            159, 159, 159, 0.14),
                                        blurRadius: 6,
                                        offset: Offset(6, 6))
                                  ]),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                color: Theme.of(context).primaryColor,
                                onPressed: onSubmit,
                                child: AutoSizeText(
                                  _buttonTitle,
                                  style: const TextStyle(
                                    fontFamily: 'Sofia',
                                    fontSize: 26,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xffe12909),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
