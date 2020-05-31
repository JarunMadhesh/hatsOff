import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'package:hatsoff/widgets/errorDialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddTask extends StatefulWidget {
  static const route = '/AddTaskName';
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  FocusNode _nameFocusNode;
  FocusNode _switchFocusNode;
  FocusNode _treatFocusNode;
  FocusNode _dueDateFocusNode;

  String _pageTitle;
  String _buttonTitle;
  String _taskName;
  String _dueDateErrorText;
  bool check = true;
  String _treat = '';
  bool _isReminderOn = false;
  bool _isDueDateSelected = false;
  DateTime _dueDate = DateTime.now();
  ToDo _temptask;

  void onSubmit() async {
    if (!_formKey1.currentState.validate() || !_isDueDateSelected) {
      setState(() {
        _dueDateErrorText = 'Enter a due date';
      });
      return;
    }

    try {
      if (_pageTitle == 'New task') {
        Provider.of<ToDoProvider>(context, listen: false).addTask(ToDo(
            DateTime.now().toString(),
            _taskName,
            _isReminderOn,
            _dueDate,
            DateTime.now(),
            _treat));
      } else {
        Provider.of<ToDoProvider>(context, listen: false).editTask(ToDo(
            _temptask.id,
            _taskName,
            _isReminderOn,
            _temptask.startTime,
            DateTime.now(),
            _treat));
      }
    } catch (e) {
      showDialog(context: context, child: ErrorDialog());
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future getTime() async {
    _isDueDateSelected = true;
    await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      theme: DatePickerTheme(
          doneStyle: TextStyle(color: Theme.of(context).splashColor)),
      onConfirm: (datetime) {
        _dueDate = datetime;
      },
      minTime: DateTime.now().subtract(Duration(minutes: 1)),
      // maxTime: DateTime.now(),
      currentTime: _dueDate,
    );
    setState(() {});
    FocusScope.of(context).requestFocus(_switchFocusNode);
  }

  @override
  void initState() {
    super.initState();

    _nameFocusNode = FocusNode();
    _switchFocusNode = FocusNode();
    _dueDateFocusNode = FocusNode();
    _treatFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    if (_nameFocusNode != null) _nameFocusNode.dispose();
    if (_switchFocusNode != null) _switchFocusNode.dispose();
    if (_treatFocusNode != null) _treatFocusNode.dispose();
    if (_dueDateFocusNode != null) _dueDateFocusNode.dispose();
    if (_formKey1.currentState != null) _formKey1.currentState.dispose();
    if (_formKey1.currentState != null) _formKey2.currentState.dispose();
  }

  @override
  void didChangeDependencies() {
    if (check) {
      _temptask = ModalRoute.of(context).settings.arguments;
      if (_temptask != null) {
        _pageTitle = 'Edit task';
        _buttonTitle = 'Change';
        _taskName = _temptask.name;
        _treat = _temptask.treat;
        _isReminderOn = _temptask.isReminderOn;
        _isDueDateSelected = true;
        _dueDate = _temptask.dueDate;
      } else {
        _pageTitle = 'New task';
        _buttonTitle = 'Add';
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
                                initialValue: _taskName ?? _taskName,
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
                                      .requestFocus(_dueDateFocusNode);
                                },
                                onChanged: (str) {
                                  _taskName = str;
                                },
                                validator: (str) {
                                  if (str.trim().length == 0)
                                    return 'Please enter a task name';
                                  if (str.length > 15)
                                    return 'Please enter a short task name';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.black),
                                  fillColor: Color(0xffF7F7F7),
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
                                  hintText: 'task name',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Sofia',
                                    fontSize: 26,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xffbfbcbc),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.05),
                          if (_dueDateErrorText != null && !_isDueDateSelected)
                            Container(
                                width: width * 0.781,
                                alignment: Alignment.centerRight,
                                child: AutoSizeText(
                                  _dueDateErrorText,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'Sofia',
                                      color: Theme.of(context).splashColor),
                                )),
                          SizedBox(height: height * 0.006),
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
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
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
                                      Container(
                                        child: AutoSizeText(
                                          _isDueDateSelected
                                              ? '${DateFormat.MMMd().format(_dueDate)} ${DateFormat.Hm().format(_dueDate)}'
                                              : 'Due date',
                                              maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'Sofia',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w300,
                                            color: const Color(0xff717171),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      if (_isDueDateSelected)
                                        IconButton(
                                            tooltip: 'Edit due time',
                                            icon: Icon(
                                              Icons.edit,
                                              color: const Color(0xff717171)
                                                  .withOpacity(0.4),
                                            ),
                                            onPressed: getTime),
                                      if (!_isDueDateSelected)
                                        Container(
                                            width: width * 0.1,
                                            alignment: Alignment.centerLeft,
                                            child: Transform.scale(
                                              scale: 1.2,
                                              child: IconButton(
                                                  focusNode: _dueDateFocusNode,
                                                  icon: const Icon(
                                                      Icons.chevron_right),
                                                  onPressed: getTime),
                                            )),
                                    ]),
                              )
                            ]),
                          ),
                          SizedBox(height: height * 0.02),
                          Container(
                            width: width * 0.781,
                            height: height * 0.082,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(width * width * 0.181)),
                                boxShadow: [
                                  BoxShadow(
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
                                        EdgeInsets.only(right: width * 0.02),
                                    child: Icon(
                                      Icons.notifications,
                                      color: Theme.of(context).primaryColor,
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
                                          const AutoSizeText(
                                            'Reminder',
                                            style: TextStyle(
                                              fontFamily: 'Sofia',
                                              fontSize: 24,
                                              fontWeight: FontWeight.w300,
                                              color: const Color(0xff717171),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                              child: Transform.scale(
                                            scale: 0.8,
                                            child: CupertinoSwitch(
                                                activeColor: Theme.of(context)
                                                    .splashColor,
                                                value: _isReminderOn,
                                                onChanged: (val) async {
                                                  _isReminderOn = val;
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
                          SizedBox(height: height * 0.02),
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
                            child: RichText(
                              text: const TextSpan(
                                text:
                                    'what do you like to treat \nyourself with ?',
                                style: TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff717171),
                                ),
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
                                  color: Color(0xff717171),
                                ),
                                validator: (str) {
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
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Sofia',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xffbfbcbc),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.04),
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
                                        offset: const Offset(6, 6))
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
