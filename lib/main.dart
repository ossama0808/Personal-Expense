import 'package:PersonalExpense/UI/LogInPage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Style/SplashColor.dart'as Theme;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new SplashScreen(// Implementation of Splash Screen As Object.
        seconds: 8,// Seconds Of Loading
        navigateAfterSeconds: LogInPage(),// After Loading Navigation
        title: new Text('',// Non Text just for space
            style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
            )),
        image: Image.asset('images/Logo.png'),// Logo Path
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,// Logo Size in pix
        loaderColor:  Colors.white,
        gradientBackground: new LinearGradient(// Page Color From Style/SplashColor File
            colors: [
              Theme.Colors.loginGradientStart,// Start of Gradient
              Theme.Colors.loginGradientEnd// End Of Gradient
            ],
            begin: const FractionalOffset(0.0, 0.0),// Color Start Offset per pix
            end: const FractionalOffset(1.0, 1.0),// Color End Offset per pix
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp// Gradient Mode Style
        ),
      ),
    );
  }
}
