import 'package:PersonalExpense/UI/Authentication/SignUp.dart';
import 'package:PersonalExpense/UI/DashBoard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime logInDate = DateTime.now();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  String userId;
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
                //hintText: 'Email',
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
            controller: passwordController,// Variable that hold typed value
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1,
            ),
            //textAlign: vTextAlignment,
            obscureText: true,
            decoration: InputDecoration(
              //hintText: 'Password',
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
              signIn();
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
            onPressed: () {
              Navigator.of(context).pushReplacement(new CupertinoPageRoute(builder: (BuildContext context) => new SignUpPage()));
            },
          ),
        ],
      ),
    );
  }
  void showInSnackBar(String value) { // Void Function to show SnackBar
    FocusScope.of(context).requestFocus(new FocusNode());// Request Keyboard to hide
    _scaffoldKey.currentState?.removeCurrentSnackBar();// check if there is another snackbar before call new one
    _scaffoldKey.currentState.showSnackBar(new SnackBar( // SnackBar Entry point
      content: new Text(// text that contain Message
        value,// Message Value
        textAlign: TextAlign.center, //Text Positioned
        style: TextStyle(
            color: Color(0xFF40084d),
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.white,// SnackBar Background Color
      duration: Duration(seconds: 1),// Duration of snackbar, How many seconds must the snackbar be at the top of the scaffold
    ));
  }

  Future signIn()async{
    showInSnackBar("Please Wait...");// Snack message
    try {// try catch start
      userId = (await _auth.signInWithEmailAndPassword(email: emailController.text,
          password: passwordController.text)).user.uid; // calling _auth method from FirebaseAuth Lib and passing Email and Password to signIn this User and return the UserID
      if (userId.length > 0 && userId != null) { // Checking if the returned UserId is null
        if(userId==null){// Checking if the returned UserId is null again
          showInSnackBar("Invalid email or password");// passing SnackMessage
        }else{
          print('UserID= '+userId);// Print UserID text and it's value(UserID)
          saveUserData().whenComplete(() {// Calling SaveUserData function to save user data to DB and after this function complete 100% Navigate to the DashBoard Page and passing UserId with it
            Navigator.of(context).pushReplacement(// Navigating with replacement to prevent Backward
                new CupertinoPageRoute(builder: (BuildContext context) => new DashBoard(
                  userID: userId,// UserID Value
                )));
          });
        }
      }
    } catch (e) {// Catch on exception
      print(e.toString());// print Exception value
      showInSnackBar("Invalid email or password");// SnackBar Message in case of exception
    }
  }
  Future saveUserData()async{// Save User Data Function with asynchronous ability
    await Firestore.instance // FireStore Instance
        .collection('UsersAccounts')// FireStore Collection name (Table Name)
        .document(userId)// Document ID = UserID
        .updateData({// Commanding Firebase to Update UserID record with the following
      'UserLastLogin':logInDate,// FieldName:FieldValue
    });// end of firestore query
    setState(() {
      password='';//setting password field to empty in case of any leak
    });
  }

}// end of LoginPage