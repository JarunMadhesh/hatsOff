import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      content: Container(
        height: height * 0.2721,
        width: width * 0.648,
        padding: EdgeInsets.only(
          top: height * 0.0123,
          bottom: height * 0.0369,
          right: width * 0.05,
          left: width * 0.05,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xffF7F7F7)),
          boxShadow: [
            BoxShadow(
                blurRadius: 15,
                offset: const Offset(15, 15),
                color: const Color(0xff868383).withOpacity(0.16))
          ],
          color: Colors.white,
        ),
        child: Stack(children: [
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: height * 0.0197,
                width: height * 0.0197,
                child: SvgPicture.asset(
                  'assets/icons/cross.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: height * 0.007),
                Container(
                  height: height * 0.089,
                  width: height * 0.089,
                  child: SvgPicture.asset(
                    'assets/icons/info.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: height * 0.0123),
                const AutoSizeText(
                  'Error occurred',
                  style: TextStyle(
                    fontFamily: 'Sofia',
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xff969696),
                  ),
                ),
                SizedBox(height: height * 0.0123),
                Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xffE5E2E2),
                        )),
                    height: height * 0.0615,
                    width: width * 0.49,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const AutoSizeText(
                        'Close',
                        style: TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: 26,
                          fontWeight: FontWeight.w300,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
