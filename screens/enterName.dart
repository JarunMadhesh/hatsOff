import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../providers/user.dart';
import 'package:provider/provider.dart';

class EnterName extends StatefulWidget {
  // static const route = '/EnterName';
  @override
  _EnterNameState createState() => _EnterNameState();
}

class _EnterNameState extends State<EnterName> {
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
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AutoSizeText(
          'Hats Off',
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
                ? height * 0.86
                : height * 0.86 - MediaQuery.of(context).viewInsets.bottom,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(children: [
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? SizedBox(height: height * 0.1256)
                    : SizedBox(height: height * 0.05),
                Center(
                  child: Container(
                    width: height * 0.346,
                    height: height * 0.346,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage('assets/logo.png')),
                      color: Theme.of(context).splashColor,
                      boxShadow: [
                        const BoxShadow(
                            blurRadius: 6,
                            offset: Offset(6, 6),
                            color: const Color.fromRGBO(159, 159, 159, 0.16))
                      ],
                      borderRadius: BorderRadius.circular(height * 0.346 / 2),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(height: height * 0.082),
                Container(
                  width: MediaQuery.of(context).viewInsets.bottom == 0
                      ? width * 0.752
                      : width * 0.952,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: Container(
                              width: width * 0.632,
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                style: const TextStyle(
                                  fontFamily: 'Sofia',
                                  fontSize: 24,
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
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(color: Colors.black),
                                  fillColor: Color(0xffF7F7F7),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(229, 226, 226, 1)),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(229, 226, 226, 1)),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.redAccent),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(229, 226, 226, 1)),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3)),
                                  ),
                                  hintText: 'enter your name',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Sofia',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff717171),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: onSubmit,
                            child: Container(
                              width: width * 0.15,
                              height: 64,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    const BoxShadow(
                                      blurRadius: 5,
                                      offset: const Offset(5, 5),
                                      color: const Color.fromRGBO(
                                          159, 159, 159, 0.1),
                                    )
                                  ],
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(3),
                                      bottomRight: Radius.circular(3)),
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          229, 226, 226, 1))),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).splashColor,
                                size: 34,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.033),
                      // Container(
                      //   width: width * 0.752,
                      //   height: height * 0.0739,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Color(0xffE5E2E2)),
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(3),
                      //       boxShadow: [
                      //         BoxShadow(
                      //             color: Color.fromRGBO(159, 159, 159, 0.14),
                      //             blurRadius: 6,
                      //             offset: Offset(6, 6))
                      //       ]),
                      //   child: FlatButton(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(3),
                      //     ),
                      //     color: Theme.of(context).primaryColor,
                      //     onPressed: onSubmit,
                      //     child: const Text(
                      //       'Next ',
                      //       style: TextStyle(
                      //         fontFamily: 'Sofia Pro',
                      //         fontSize: 26,
                      //         fontWeight: FontWeight.w300,
                      //         color: const Color(0xffe12909),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
