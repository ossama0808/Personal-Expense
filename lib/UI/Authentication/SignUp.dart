import 'package:PersonalExpense/UI/Authentication/LogInPage.dart';
import 'package:PersonalExpense/UI/DashBoard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
  SignUpPage({this.onSignedIn});
  final VoidCallback onSignedIn;
}

enum FormMode { LOGIN, SIGNUP }

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();// Global Key to Control Screen from any stated object
  // variables Section
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime signUpDate = DateTime.now();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var userLastNameController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  String userId;
  String userName;
  String userLastName;
  String email;
  String password;
  String confirmPassword;
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
              'SignUp',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 180,
                  child: TextFormField(
                    controller: userNameController,// Variable that hold typed value
                    style: TextStyle(
                      color: Colors.white, // Field Color
                      fontSize: 16,
                      height: 1,
                    ),
                    decoration: InputDecoration(
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
                      labelText: 'First Name',// Field Label
                      labelStyle: TextStyle(color: Colors.white),
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      isDense: true,
                      counterStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onChanged: (value) {// Onchange Function Start hold typed value in 'Value'
                      setState(() {// Setting typed value to a local variable
                        userName = value;// Assigning value
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: TextFormField(
                    controller: userLastNameController,// Variable that hold typed value
                    style: TextStyle(
                      color: Colors.white, // Field Color
                      fontSize: 16,
                      height: 1,
                    ),
                    decoration: InputDecoration(
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
                      labelText: 'Last Name',// Field Label
                      labelStyle: TextStyle(color: Colors.white),
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      isDense: true,
                      counterStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onChanged: (value) {// Onchange Function Start hold typed value in 'Value'
                      setState(() {// Setting typed value to a local variable
                        userLastName = value;// Assigning value
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(// Email Text Field Padding
            padding: const EdgeInsets.only(top: 10),
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
          SizedBox(height: 10.0),// Add Extra Size
          TextFormField(// Password Field
            controller: confirmPasswordController,// Variable that hold typed value
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1,
            ),
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.white, width: 2.0, style: BorderStyle.solid)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0), borderSide: BorderSide(color: Colors.white, width: 2.0, style: BorderStyle.solid)),
              labelText: 'Confirm Password',
              labelStyle: TextStyle(color: Colors.white),
              focusColor: Colors.white,
              hoverColor: Colors.white,
              isDense: true,
              counterStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onChanged: (confirmPasswordValue) {
              setState(() {
                confirmPassword = confirmPasswordValue;
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
              userDetailValidation();
            },
            padding: EdgeInsets.all(12),
            color: Colors.white.withOpacity(0.8),
            child: Text('Login', style: TextStyle(color: Colors.black)),
          ),
          FlatButton(
            child: Text(
              'Have an Account?',
              style: TextStyle(color: Colors.white70),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(new CupertinoPageRoute(builder: (BuildContext context) => new LogInPage()));
            },
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color(0xFF40084d),
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 2),
    ));
  }

 Future userDetailValidation(){
    if(userName==null){
      showInSnackBar("First Name cannot be empty");
    }else if(userLastName==null){
      showInSnackBar("Last Name cannot be empty");
    }else if(email==null){
      showInSnackBar("Email cannot be empty");
    }else{
      if(password==confirmPassword){
        print(password);
        print(confirmPassword);
        if(password.length>6 && password!='123456'){
          signUp();// Calling SignUp function.
        }else{
          showInSnackBar("Password does'nt match the criteria");
        }
      }else{
        showInSnackBar("Password does'nt match the criteria");
      }
    }
 }

  Future signUp()async{
    showInSnackBar("Please Wait...");
    try {
      userId = (await _auth.createUserWithEmailAndPassword(email: emailController.text,
          password: passwordController.text)).user.uid;
      if (userId.length > 0 && userId != null) {
        if(userId==null){
          showInSnackBar("Cannot Sign you Up, Please try again");
        }else{
          print('UserID= '+userId);
          print('Saving New User To DB...... ');
          saveUserData().whenComplete(() {// Calling SaveUserData function and wait till finish to execute the navigator Command
            Navigator.of(context).pushReplacement(new CupertinoPageRoute(builder: (BuildContext context) => new DashBoard(userID: userId,)));
          });
        }
      }
    } catch (e) {
      print(e.toString());
      showInSnackBar("Invalid email or password");
    }
  }

  Future saveUserData()async{
    await Firestore.instance
        .collection('UsersAccounts')
        .document(userId)
        .setData({// Setting Data to create new record with the following records NOT UPDATEDATA.
      'UserID':userId,
      'UserName':userName,
      'UserLastName':userLastName,
      'SignUpDate':signUpDate,
      'UserEmail':email,
      'PasswordValidated':true,
    });
    setState(() {
      password='';
      confirmPassword='';
    });
    await Firestore.instance.collection('Statistics').document(userId).setData({
      'TotalBalance':int.parse('0'),
      'TotalExpenses':int.parse('0'),
      'TotalIncome':int.parse('0'),
      'UserID':userId
    });
  }

}// end of signUp Page.