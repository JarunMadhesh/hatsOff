import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).splashColor,
        body: Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  'assets/splashscreen.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.45,
              bottom: MediaQuery.of(context).size.height * 0.2,
              child: SpinKitThreeBounce(
                color: Theme.of(context).splashColor,
                size: 25.0,
              ),
            ),
          ],
        ));
  }
}
