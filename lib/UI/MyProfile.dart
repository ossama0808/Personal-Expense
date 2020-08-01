import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DashBoard.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
  MyProfile({this.userID,this.userProfileData});
  final String userID;
  final DocumentSnapshot userProfileData;

}

class _MyProfileState extends State<MyProfile> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();// Global Key to Control Screen from any stated object

  // variables Section
  String userID=' ';
  String imageAvatarLink='https://cdn1.vectorstock.com/i/thumb-large/38/10/solid-purple-gradient-user-icon-web-icon-vector-23623810.jpg';

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
          'My Profile',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              child: Image.network(imageAvatarLink),
              backgroundColor: Colors.white,maxRadius: 75,
            ),
          ),
          Center(
            child: Text(
              widget.userProfileData.data['UserName']+' '+widget.userProfileData.data['UserLastName'],
              style: TextStyle(
                color: Color(0xFF40084d),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 25,),
          Text(
            'Email: '+widget.userProfileData.data['UserEmail'],
            style: TextStyle(
              color: Color(0xFF40084d),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5,),
          Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFF40084d),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {

              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                  height: 30,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color(0xFF40084d),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.fiber_new,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Change Name",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {

              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                  height: 30,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color(0xFF40084d),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.lock_open,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Change Password",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {

              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                  height: 30,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color(0xFF40084d),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 25,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Close Account",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

}