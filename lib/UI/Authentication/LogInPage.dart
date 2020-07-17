import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
  LogInPage({this.onSignedIn});
  final VoidCallback onSignedIn;
}

enum FormMode { LOGIN, SIGNUP }

class _LogInPageState extends State<LogInPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();// Global Key to Control Screen from any stated object
  // variables Section
  DateTime logInDate = DateTime.now();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  String email;
  String password;
  bool showChangePassEmailSend=false;
  TextEditingController forgetPasswordEmailController = TextEditingController();
  bool _isLoading;
  String forgetPassEmail;



  @override
  Widget build(BuildContext context) {// Main Widget
    final logo = Hero(// Logo variable
      tag: 'LOGO',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,// Logo Size
        child: Image.asset('images/Logo.png'),// Logo Path
      ),
    );
    return Scaffold(// Scaffold Widget
      key:_scaffoldKey,// Stated Key
      backgroundColor: Color(0xFF40084d),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),// Non-Scrollable Screen
        shrinkWrap: true,// Divide Widget by its main size
        padding: EdgeInsets.only(left: 24.0, right: 24.0),// Padding the edge of screen
        children: <Widget>[
          Padding(// Logo Padding
            padding: const EdgeInsets.only(top: 85),
            child: logo,
          ),
          SizedBox(// Extra Space
            height: 20,
          ),
          Center(// Login text
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontFamily: "Schyler",
                color: Colors.white,
                fontSize: 22,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Padding(// Email Text Field Padding
            padding: const EdgeInsets.only(top: 85),
            child: TextFormField(
              controller: emailController,// Variable that hold typed value
              style: TextStyle(
                color: Colors.white, // Field Color
                fontSize: 16,
                height: 1,
              ),
              decoration: InputDecoration(
                hintText: 'Email',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.white,// Border Color
                        width: 2.0, // Border Width
                        style: BorderStyle.solid// Border Style
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.white,
                        width: 2.0,
                        style: BorderStyle.solid
                    )
                ),
                labelText: 'Email',// Field Label
                labelStyle: TextStyle(color: Colors.white),
                focusColor: Colors.white,
                hoverColor: Colors.white,
                isDense: true,
                counterStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onChanged: (emailValue) {// Onchange Function Start hold typed value in 'emailValue'
                setState(() {// Setting typed value to a local variable
                  email = emailValue;// Assigning value
                });
              },
            ),
          ),
          SizedBox(height: 10.0),// Add Extra Size
          TextFormField(// Password Field
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1,
            ),
            //textAlign: vTextAlignment,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.white, width: 2.0, style: BorderStyle.solid)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.white, width: 2.0, style: BorderStyle.solid)),
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
              focusColor: Colors.white,
              hoverColor: Colors.white,
              isDense: true,
              counterStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onChanged: (passwordValue) {
              setState(() {
                password = passwordValue;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(// Login Button widget
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {// On Pressed Function
              FocusScope.of(context).unfocus();// Hide Keyboard

            },
            padding: EdgeInsets.all(12),
            color: Colors.white.withOpacity(0.8),
            child: Text('Login', style: TextStyle(color: Colors.black)),
          ),
          FlatButton(
            child: Text(
              'Forget Your Password?',
              style: TextStyle(color: Colors.white70),
            ),
            onPressed: () {},
          ),
          FlatButton(
            child: Text(
              'Don\'t Have an Account?',
              style: TextStyle(color: Colors.white70),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }



}