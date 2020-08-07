import 'package:PersonalExpense/UI/Authentication/LogInPage.dart';
import 'package:PersonalExpense/UI/MyProfile.dart';
import 'package:PersonalExpense/UI/Reports.dart';
import 'package:PersonalExpense/UI/Transaction-CUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

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
  String userName=' '; // Variable that holds User Name from DataBase
  String userID=' '; // Variable that holds User ID from DataBase
  DocumentSnapshot userData; // Variable of type Document that hold User's FULL DATA from DataBase
  QuerySnapshot transactionsList; // Variable of type Query that holds all Transactions
  bool showGraph=false; // Variable of type boolean to show graph if there is enough data
  Stream<DocumentSnapshot> statistics; // Stream List of type  Document that Fetch Statistics Data from Database
  Stream<QuerySnapshot> transactions; // Stream List of type  Document that Fetch Transactions Data from Database
  QuerySnapshot statisticsGraph; // Variable of type Query that holds multiple Doc from multiple Data Sorce
  var statisticsGraphicList = [0.0, 0.1, 0.0, 0.1, 0.0]; // Variable of type array that holds Graph Y axis
  num totalBalance=0.0; // Variable of type Number holds Total Balance
  num totalIncome=0.0; // Variable of type Number holds Total Income
  num totalExpenses=0.0; // Variable of type Number holds Total Expenses

@override
  void initState() { // Function of type Void Executes after Main Widget
  if (!mounted) return;
    setState(() {
      userID=widget.userID; // Setting UserID from LogIn Screen to UserID Local Variable
    });
  getUserData().whenComplete((){ // calling getUserData an then....
    getStatistics(); // Calling getStatistics Function
    getTransactions(); // Calling getTransactions Function
    getGraphStatistics(); // Calling getGraphStatistics Function
  });
  super.initState(); // Initiate Full State
  }

  Future getUserData() async { // Getting User Full Data from Database
  print(userID);
  await Firestore.instance
      .collection('UsersAccounts')// Table Path
      .document(userID) // Document ID (UserID)
      .get().then((value) { // Getting Data
        if (!mounted) return;
        setState(() {
          userName=value.data['UserName']+' '+value.data['UserLastName']; // Set UserName value
          userData=value; // Set User FULL Doc
        });
  });
  }

  // !Note: Please Read this function multiple times.
  Future getGraphStatistics()async{ // Get, Calculate and Show Graph
  var expenses=[0.0]; // Variable of type list array that holds expenses as AMOUNTS
  var income=[0.0]; // Variable of type list array that holds Incomes as AMOUNTS
  var higherLength=[0.0]; // Variable of type list array that holds higher transaction length between Expenses and Incomes as AMOUNTS
  var lowerLength=[0.0]; // Variable of type list array that holds lower transaction length between Expenses and Incomes as AMOUNTS
  var total=[0.0]; // Variable of type list array that holds total after formula.

  // getting all transactions where values of transactions (userid is equal to the signed in user and transaction type is equal to expenses)
   await Firestore.instance.collection('Transactions')
       .where('UserID',isEqualTo: userID) // condition
       .where('TransactionType',isEqualTo: 'Expenses') // condition
       .getDocuments().then((value){ // then....
         setState(() { // set values
           expenses.clear(); // clearing expense list
            for(int i =0;i < value.documents.length;i++){ // for loop to fill expenses list with TRANSACTION AMOUNT WITH TWO DECIMAL POINT
              expenses.add(double.parse(double.parse(value.documents[i].data['TransactionAmount']).toStringAsFixed(2))); // adding record
          } // end of for loop
         });
   });

  // getting all transactions where values of transactions (userid is equal to the signed in user and transaction type is equal to Saving)(saving is Income)
   await Firestore.instance.collection('Transactions')
       .where('UserID',isEqualTo: userID) // condition
       .where('TransactionType',isEqualTo: 'Saving') // condition
       .getDocuments().then((value){ // then....
         setState(() {// set values
           income.clear(); // clearing income list
            for(int i =0;i < value.documents.length;i++){ // for loop to fill income list with TRANSACTION AMOUNT WITH TWO DECIMAL POINT
              income.add(double.parse(double.parse(value.documents[i].data['TransactionAmount']).toStringAsFixed(2))); // adding record
          }// end of for loop
         });
   });

  if(transactionsList==null){
    // Do Nothing
  }else{
    //////////////////////////// Now we have two lists that holds Expenses and Incomes Transaction Amount./////////////////////
    if(transactionsList.documents.length<5){ // checking if both Transactions type (expenses and income) is less than 5 transactions?
      setState(() {
        showGraph=false; // if true then don't show graph
        // because if we show graph with less than 5 transaction mathematically we can't calculate Y axis
      });
    }
    else{// if true

      if(income.length>=1 && income.length>=1){// checking if income list is greater than 1 transaction ( graph can't be shown if income is less than 1 transaction )
        double totalVal; // temp variable of type double that holds total of formula
        // if true
        setState(() { // setting values..

          if(income.length>expenses.length){ // here we see, if income is bigger tan expenses?
            // if true
            higherLength=income; // fill higherLength list with income list
            lowerLength=expenses; // fill lowerLength list with expenses list
          }else if(expenses.length>income.length){// if false
            higherLength=expenses; // fill higherLength list with expenses list
            lowerLength=income; // fill lowerLength list with income list
          }

          total.clear(); // clearing total list
          for (int i = 0; i < lowerLength.length; i++) { // for loop to calculate and fill total array
            // formula is Y axis = ( higher length value - lower length value)
            totalVal=higherLength[i]-lowerLength[i]; // fill totalVal variable with value
            total.add(totalVal); // add totalVal value to total List
            higherLength.removeAt(i); // remove value at index from higherLength
            lowerLength.removeAt(i); // remove value at index from lowerLength
          }

          for (int i = 0; i < higherLength.length; i++) { // adding the remaining values from higherLength list to total list
            total.add(higherLength[i]);
          }

          statisticsGraphicList.clear(); // clearing MAIN Graph list
          for(int i=0;i<total.length;i++){ // filling MAIN Graph List with total list
            statisticsGraphicList.add(total[i]);
          }

          showGraph=true; // lastly show graph
        });

      }else{ // if false
        setState(() {
          showGraph=false; // hide Graph
        });
      }
    }
  }

  } // end of calculating and showing graph

  Future getStatistics()async{ // getting statistics from DataBase
    statistics= Firestore.instance.collection('Statistics').document(userID).snapshots(); // setting values
    statistics.listen((value) { // Open Listener connection
      if (!mounted) return;
      setState(() { // each time values changed in database it set....
        totalBalance=value.data['TotalBalance']; // totalBalance to value TotalBalance from DB
        totalIncome=value.data['TotalIncome']; // totalIncome to value TotalIncome from DB
        totalExpenses=value.data['TotalExpenses']; // totalExpenses to value TotalExpenses from DB
      });
    });
  }// end

  Future getTransactions()async{ // getting transactions with conditions
    transactions= Firestore.instance
        .collection('Transactions') // path
        .where('UserID', isEqualTo: userID) // condition where Transaction UserID is equal to SignedIn userID
        .orderBy('TransactionDate',descending: true) // ordering documents by date with descending order
        .snapshots();
    transactions.listen((value) { // Open Listener connection
      if (!mounted) return;
      setState(() {// each time values changed in database it set....
        transactionsList=value; // transactionList to list of Transactions from DataBase
      });
    });
  } // end
  
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
      body: topHeader(),
    );
  }

  Widget topHeader(){ // header widget
   return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // give space between each..
            children: <Widget>[
              Text('Hello,',style: TextStyle(fontSize: 40,color: Color(0xFF40084d)),), // Text
              IconButton(// Icon button
                icon: Container(// adding container to icon to manage its size
                  height: 40, // icon height
                  width: 40, // icon width
                  decoration: BoxDecoration( // adding decoration to container
                    shape: BoxShape.circle, // with a shape of circle
                    color: Color(0xFF40084d), // color
                  ),
                  child: Center(child: Icon(Icons.show_chart,size: 25,color: Colors.white,)),// inside this circle it comes the icon with its parameters type,size and color
                ),
                onPressed: (){ // on pressed functions is when icon is pressed>-
                  showSettingBottomSheet(context);// show Setting Bottom Sheet
              },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(userName, // user name value
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
                  child: Center(child: Icon(Icons.add_circle_outline,size: 25,color: Colors.white,)),
                ),
                onPressed: (){
                  Navigator.of(context).pushReplacement(// Navigating without replacement to page TransactionCUD. CUD=(Create,Update,Delete)
                      new CupertinoPageRoute(builder: (BuildContext context) => new TransactionCUD(
                        userID: userID,// passing UserID Value
                        title: 'New Transaction', // passing page name
                      )
                      )
                  );
              },
              ),
            ],
          ),
          SizedBox(height: 10,),// UnVisible box just to add some space
          statisticsSection(), // Calling statisticsSection widget ( referenced after this widget)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text( // Lable
                  'Transactions:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color:Color(0xFF40084d)
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios,size: 18,color: Color(0xFF40084d),),
                  onPressed: (){

                  },
                )
              ],
            )
          ),
          transactionFlowList(),// Calling transactionFlowList widget ( referenced after this widget)
        ],
      ),
    );
  }

  showSettingBottomSheet(BuildContext context) { // BottomSheet Modal
    return _scaffoldKey.currentState.showBottomSheet((context) { // Asking Scaffold to show current BottomSheet
      return Container( // Bottom Sheet
        height: 300, // Bottom Sheet height
        decoration: BoxDecoration( // adding decorations
            color: Color(0xFF40084d),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16)
            )
        ),
        child: Column(
          children: <Widget>[
            Container( // container that holds icon
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.settings, // icon type
                    color: Colors.white, // icon color
                    size: 50,// icon size
                  )),
            ),
            Container( // container that hold text to make it centered
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Settings',
                  style: TextStyle(
                      color: Colors.white, // color
                      fontSize: 18,// size
                      fontWeight: FontWeight.w300 // font weight ( how much bold it is )
                  ),
                ),
              ),
            ),
            SizedBox(height: 5,), // UnVisible box just to add some space
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.of(context).pushReplacement(// Navigating without replacement
                      new CupertinoPageRoute(builder: (BuildContext context) => new MyProfile(
                        userID: userID,// UserID Value
                        userProfileData: userData, // passing FULL User DATA
                      )));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                    height: 30,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
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
                          Icons.people,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "My Profile",
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
                  Navigator.of(context).pushReplacement(// Navigating without replacement
                      new CupertinoPageRoute(builder: (BuildContext context) => new Reports(
                        userID: userID,// UserID Value
                      )));
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                    height: 30,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
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
                          Icons.description,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Reports",
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

            Divider(
              color: Colors.white,
              height: 1,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.pop(context);// hide current bottomSheet and
                  showAppearanceBottomSheet(context); // call and show AppearanceBottomSheet
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                    height: 30,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
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
                          Icons.color_lens,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Appearance",
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
                  FirebaseAuth.instance.signOut().whenComplete(() { // signOut current user and navigate without replacement to loginPage
                    Navigator.of(context).pushReplacement(
                        new CupertinoPageRoute(builder: (BuildContext context) => new LogInPage()));
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                    height: 30,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
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
                          Icons.exit_to_app,
                          color: Colors.red,
                          size: 25,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "SignOut",
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
    }, shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16),
            topRight: Radius.circular(16))),
        backgroundColor: Colors.white,// BottomSheet Background Color
        elevation: 2 // shadow
    );
  }

  showAppearanceBottomSheet(BuildContext context) {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
            color: Color(0xFF40084d),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16)
            )
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.color_lens,
                    color: Colors.white,
                    size: 50,
                  )),
            ),
            Container(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Appearance',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            SizedBox(height: 5,),
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
                      color: Colors.white.withOpacity(0.2),
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
                          Icons.color_lens,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Purple Mode",
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
                      color: Colors.white.withOpacity(0.2),
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
                          Icons.color_lens,
                          color: Colors.black,
                          size: 25,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Dark Mode",
                          style: TextStyle(
                              color: Colors.black,
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
    }, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))), backgroundColor: Colors.white, elevation: 2);
  }

  Widget statisticsSection(){
  return Padding(
    padding: const EdgeInsets.all(5),
    child: InkWell(
      onTap: (){ // when tapping statistics box
        getStatistics(); // calling statistics functions
        getTransactions(); // calling transactions functions
      },
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
                    Text(totalBalance.toStringAsFixed(2), // Total Balance with 2 Decimal Points
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),Text(' ~',
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 113,
                width: 370,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color(0xFFF561C5D),
                ),
                child: Container(
                  height: 90,
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15,bottom: 20,top: 10),
                    child: Visibility(
                      visible: showGraph, // bool show graph
                      child: Sparkline(
                        data: statisticsGraphicList,// graph data list
                        pointsMode: PointsMode.all,
                        pointSize: 5.0,
                        pointColor: Colors.white,
                        lineWidth: 2.0,
                        lineColor: Color(0xFFFFF805E),
                        fillMode: FillMode.none,
                      ),
                      replacement: Center( // in case of showGraph = flase, Show.....
                        child: Text('No Enough Data To Show Graph', // Text
                        style: TextStyle(fontSize: 15,color: Colors.white.withOpacity(0.4)),),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget transactionFlowList(){ // transaction flow list
  if(transactionsList!=null){ // if transaction is not empty then..
    return Expanded(
      flex: 1,
      child: ListView.builder( // list view of type builder that receive data from transactionList
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: transactionsList.documents.length, // list limit is the transactionList length
        shrinkWrap: true, // shrink means to suppurate each records from the second
        itemBuilder: (context,i){ // build with context and index
          return Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    showModalBottomSheet(context: context, builder: (context){ // show modal bottomSheet with some widget attached to it
                      return Container(
                        height: 120,
                        color: Color(0xFF40084d),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text('Edit Transaction',style: TextStyle(color: Colors.white),),
                              leading: Icon(Icons.edit,color: Colors.amber,),
                              onTap: (){
                                Navigator.of(context).pushReplacement(// Navigating without replacement
                                    new CupertinoPageRoute(builder: (BuildContext context) => new TransactionCUD(
                                      userID: userID,// UserID Value
                                      title: 'Update Transaction',
                                      transactionEdit: transactionsList.documents[i],
                                    )
                                    )
                                );
                              },
                            ),
                            ListTile(
                              title: Text('Delete Transaction',style: TextStyle(color: Colors.red),),
                              leading: Icon(Icons.delete_forever,color: Colors.red,),
                              onTap: ()async{ // in case of delete transaction
                                getStatistics().whenComplete(() async{ // getting statistics data an then ...
                                  if(transactionsList.documents[i].data['TransactionType']=='Saving'){ // check if transaction is saving then...
                                    await Firestore.instance.collection('Statistics').document(userID).updateData({ // calling FireStore and open Statistics data and change ...
                                      'TotalBalance':totalBalance - double.parse(transactionsList.documents[i].data['TransactionAmount']), // TotalBalance to TotalBalance - the transaction amount
                                      'TotalIncome':totalIncome - double.parse(transactionsList.documents[i].data['TransactionAmount']) // TotalIncome to TotalBalance - the transaction amount
                                    });
                                    await Firestore.instance.collection('Transactions').document(transactionsList.documents[i].documentID).delete().whenComplete(() { // delete transaction and then .....
                                      getGraphStatistics(); // calling getGraphStatistics function
                                      getStatistics(); // calling getStatistics function
                                      getTransactions(); // calling getTransactions function
                                      Navigator.of(context).pop(); // hide modal bottom sheet
                                    });
                                  }
                                  else if(transactionsList.documents[i].data['TransactionType']=='Expenses'){// if transaction is expenses
                                    await Firestore.instance.collection('Statistics').document(userID).updateData({// calling FireStore and open Statistics data and change ...
                                      'TotalBalance':totalBalance + double.parse(transactionsList.documents[i].data['TransactionAmount']), // TotalBalance to TotalBalance + the transaction amount
                                      'TotalExpenses':totalExpenses - double.parse(transactionsList.documents[i].data['TransactionAmount']) // TotalIncome to TotalBalance - the transaction amount
                                    });
                                    await Firestore.instance.collection('Transactions').document(transactionsList.documents[i].documentID).delete().whenComplete(() {
                                      getGraphStatistics(); // calling getGraphStatistics function
                                      getStatistics(); // calling getStatistics function
                                      getTransactions(); // calling getTransactions function
                                      Navigator.of(context).pop(); // hide modal bottom sheet
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    });
                    print(transactionsList.documents[i].documentID); // print transactionID when clicked
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xFFF561C5D),
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left:0.8),
                            child: Container(
                              height: 65,
                              width: 5,
                              decoration: BoxDecoration(
                                color: filterTransactionLeading(transactionsList.documents[i].data['TransactionColor'].toString()),// calling and passing TransactionColor to filterTransactionLeading function
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text('Date: '+getCastedDate(transactionsList.documents[i].data['TransactionDate']), // calling and passing TransactionDate to getCastedDate function
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('Type: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white
                                        ),
                                      ),
                                      Text(transactionsList.documents[i].data['TransactionType'].toString(), // transaction Type
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('Amount ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white
                                        ),
                                      ),
                                      Text(transactionsList.documents[i].data['TransactionAmount'].toString(), // transaction Amount and casting it to string
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('Category: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white
                                        ),
                                      ),
                                      Text(transactionsList.documents[i].data['Category'].toString(), // transaction Category
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('Description: ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white
                                        ),
                                      ),
                                      Text(transactionsList.documents[i].data['Description'].toString(), // transaction description
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }else{
    return SizedBox(height: 1,width: 1,);
  }
  }

  getCastedDate(Timestamp inputVal) { // get casted date function is a function that convert TimeStamp to DateAndTime
    String processedDate;
    if (inputVal.toDate().month < 10 && inputVal.toDate().day < 10) {
      processedDate = inputVal.toDate().year.toString() + '-0' + inputVal.toDate().month.toString() + '-0' + inputVal.toDate().day.toString();
    } else if (inputVal.toDate().month < 10 && inputVal.toDate().day > 9) {
      processedDate = inputVal.toDate().year.toString() + '-0' + inputVal.toDate().month.toString() + '-' + inputVal.toDate().day.toString();
    } else if (inputVal.toDate().month > 9 && inputVal.toDate().day < 10) {
      processedDate = inputVal.toDate().year.toString() + '-' + inputVal.toDate().month.toString() + '-0' + inputVal.toDate().day.toString();
    } else {
      processedDate = inputVal.toDate().year.toString() + '-' + inputVal.toDate().month.toString() + '-' + inputVal.toDate().day.toString();
    }

    return processedDate; // return date after converting it from TimeStamp to DateAndTime
  }
  filterTransactionLeading(String transType){
    Color exTransColor = Colors.red; // variable of type color that hold red color
    Color incTransColor = Colors.green; // variable of type color that hold green color
    Color val; // variable that hold chosen color
    switch (transType){ // switch case parameter color
      case 'Red':{ // in case of passed color is red then ...
      val=exTransColor; // set val to exTransColor (expenses Transaction Color) (red)
      }break; // break
      case 'Green':{ // in case of passed color is green then.....
        val=incTransColor;// set val to incTransColor (income Transaction Color) (green)
      }
    }
    return val; // return chosen color
  }

}