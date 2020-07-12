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
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
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
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'LOGO',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,
        child: Image.asset('images/Logo.png'),
      ),
    );
    return Scaffold(
      key:_scaffoldKey,
      backgroundColor: Color(0xFFb728d8),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 85),
            child: logo,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontFamily: "Schyler-Regular",
                color: Colors.white,
                fontSize: 22,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          //SizedBox(height: 35.0),
          Padding(
            padding: const EdgeInsets.only(top: 85),
            child: TextFormField(
              controller: emailController,
              style: TextStyle(
                color: Colors.white, // colorPallet('vTextFormFieldTextStyleForgroundColor'),
                fontSize: 16,
                height: 1,
              ),
              decoration: InputDecoration(
                hintText: 'Email',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.white,
                        width: 2.0, style: BorderStyle.solid
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.white,
                        width: 2.0,
                        style: BorderStyle.solid
                    )
                ),
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                focusColor: Colors.white,
                hoverColor: Colors.white,
                isDense: true,
                counterStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onChanged: (emailValue) {
                setState(() {
                  email = emailValue;
                });
              },
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
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
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              //signIn();
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