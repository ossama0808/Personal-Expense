import 'package:cloud_firestore/cloud_firestore.dart';
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
  String userName=' ';
  String userID=' ';
  DocumentSnapshot userData;


@override
  void initState() {
    setState(() {
      userID=widget.userID;
    });
  getUserData();
  super.initState();
  }

  Future getUserData() async {
  print(userID);
  await Firestore.instance
      .collection('UsersAccounts')
      .document(userID)
      .get().then((value) {
        print(value.data.toString());
        setState(() {
          userName=value.data['UserName']+' '+value.data['UserLastName'];
        });
  });
  }

  @override
  Widget build(BuildContext context) {// Main Widget
    return Scaffold(// Scaffold Widget
      key:_scaffoldKey,// Stated Key
        appBar: PreferredSize(
          child: Container(
            color: Colors.transparent,
            height: 50,
          ),
          preferredSize: MediaQuery.of(context).size,
        ),
      backgroundColor: Colors.white,
      body: mainDashBoard(),
    );
  }

  Widget mainDashBoard(){
   return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Hello,',style: TextStyle(fontSize: 40,color: Color(0xFF40084d)),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(userName,
                style: TextStyle(
                    fontSize: 35,
                    color: Color(0xFF40084d),
                    fontWeight: FontWeight.w700
                ),
              ),
              IconButton(
                icon: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF40084d),
                  ),
                  child: Center(child: Icon(Icons.refresh,size: 25,color: Colors.white,)),
                ),
              ),

            ],
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              height: 225,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Color(0xFF40084d),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25,left: 25),
                    child: Text('Balance',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0,left: 20),
                    child: Row(
                      children: <Widget>[
                        Text('SAR   ',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Text('23,657.95',
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    )
                  ),
              ],
              ),
            ),
          ),
        ],
      ),
    );
  }



}