import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

class ChangeName extends StatefulWidget {
  static const route = '/ChangeName';
  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final _formKey = GlobalKey<FormState>();
  String _name;

  @override
  void initState() {
    _name = Provider.of<UserProvider>(context, listen: false).name;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_formKey.currentState != null) _formKey.currentState.dispose();
  }

  void onSubmit() {
    if (!_formKey.currentState.validate()) return;
    Provider.of<UserProvider>(context, listen: false).setName(_name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
        title: const AutoSizeText(
          'Settings',
          style: TextStyle(
            fontFamily: 'Sofia',
            color: const Color(0xffe12909),
            fontWeight: FontWeight.w300,
            fontSize: 32,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).viewInsets.bottom == 0
                ? height * 0.82
                : height * 0.89 - MediaQuery.of(context).viewInsets.bottom,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(children: [
                SizedBox(height: height * 0.1),
                Hero(
                  transitionOnUserGestures: true,
                  tag: 'settings',
                  child: Container(
                    width: width * 0.429,
                    height: width * 0.429,
                    child: SvgPicture.asset(
                      'assets/icons/bigSettingsIcon.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.059),
                Center(
                  child: Container(
                    width: width * 0.752,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const AutoSizeText(
                          'Edit your name',
                          style: TextStyle(
                            fontFamily: 'Sofia',
                            fontSize: 21,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xff717171),
                          ),
                        ),
                        SizedBox(height: height * 0.03325),
                        Form(
                          key: _formKey,
                          child: Container(
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(
                                fontFamily: 'Sofia',
                                fontSize: 26,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff717171),
                              ),
                              cursorColor: Theme.of(context).splashColor,
                              cursorWidth: 2,
                              showCursor: true,
                              onFieldSubmitted: (str) {
                                _name = str;
                                onSubmit();
                              },
                              onChanged: (str) {
                                _name = str;
                              },
                              validator: (str) {
                                if (str.trim().length == 0)
                                  return 'Please enter a name';
                                if (str.length > 10)
                                  return 'Please enter a short name of yours';
                                return null;
                              },
                              initialValue: Provider.of<UserProvider>(context,
                                      listen: false)
                                  .name,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black),
                                fillColor: Color(0xffF7F7F7),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(229, 226, 226, 1)),
                                    borderRadius: BorderRadius.circular(3)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(229, 226, 226, 1)),
                                    borderRadius: BorderRadius.circular(3)),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(3)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(229, 226, 226, 1)),
                                    borderRadius: BorderRadius.circular(3)),
                                hintText: 'enter your name',
                                hintStyle: TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff717171),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.033),
                        Container(
                          width: width * 0.752,
                          height: height * 0.0739,
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffE5E2E2)),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(159, 159, 159, 0.14),
                                    blurRadius: 6,
                                    offset: Offset(6, 6))
                              ]),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: onSubmit,
                            child: const AutoSizeText(
                              'Submit ',
                              style: TextStyle(
                                fontFamily: 'Sofia',
                                fontSize: 26,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xffe12909),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Center(
                          child: Container(
                            width: width * 0.352,
                            height: height * 0.0739,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const AutoSizeText(
                                'Back',
                                style: TextStyle(
                                  fontFamily: 'Sofia',
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
    );
  }
}
