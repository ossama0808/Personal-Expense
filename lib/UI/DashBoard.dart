import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
  DashBoard({this.onSignedIn,this.userID});
  final VoidCallback onSignedIn;
  final String userID;
}

class _DashBoardState extends State<DashBoard> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();// Global Key to Control Screen from any stated object
  // variables Section



  @override
  Widget build(BuildContext context) {// Main Widget
    return Scaffold(// Scaffold Widget
      key:_scaffoldKey,// Stated Key
        appBar: AppBar(
          backgroundColor: Color(0xFFf2e0f6),
        ),
      backgroundColor: Color(0xFFf2e0f6),
      drawer: Column(),
      body: Container(
        height: 100,
        width: 20,
      )
    );
  }





}