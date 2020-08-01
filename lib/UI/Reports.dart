import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DashBoard.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
  Reports({this.userID,});
  final String userID;

}

class _ReportsState extends State<Reports> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();// Global Key to Control Screen from any stated object

  // variables Section
  String userID=' ';


  @override
  void initState() {
    setState(() {
      userID=widget.userID;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showInSnackBar(String value) { // Void Function to show SnackBar
    FocusScope.of(context).requestFocus(new FocusNode());// Request Keyboard to hide
    _scaffoldKey.currentState?.removeCurrentSnackBar();// check if there is another snackbar before call new one
    _scaffoldKey.currentState.showSnackBar(new SnackBar( // SnackBar Entry point
      content: new Text(// text that contain Message
        value,// Message Value
        textAlign: TextAlign.center, //Text Positioned
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Color(0xFF40084d),// SnackBar Background Color
      duration: Duration(seconds: 1),// Duration of snackbar, How many seconds must the snackbar be at the top of the scaffold
    ));
  }

  @override
  Widget build(BuildContext context) {// Main Widget
    return Scaffold(// Scaffold Widget
      key:_scaffoldKey,// Stated Key
      appBar: AppBar(
        title: Text(
          'Reports',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(// Navigating without replacement
                new CupertinoPageRoute(builder: (BuildContext context) => new DashBoard(
                  userID: userID,// UserID Value
                )
                )
            );
          },
        ),
        backgroundColor: Color(0xFF40084d),
      ),
      backgroundColor: Colors.white,
      //body: main(),
    );
  }

}