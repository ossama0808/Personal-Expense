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
  String userName=' ';
  String userID=' ';
  DocumentSnapshot userData;
  QuerySnapshot transactionsList;
  bool showGraph=false;
  Stream<DocumentSnapshot> statistics;
  Stream<QuerySnapshot> transactions;
  QuerySnapshot statisticsGraph;
  var statisticsGraphicList = [0.0, 0.1, 0.0, 0.1, 0.0];
  num totalBalance=0.0;
  num totalIncome=0.0;
  num totalExpenses=0.0;

@override
  void initState() {
  if (!mounted) return;
    setState(() {
      userID=widget.userID;
    });
  getUserData().whenComplete((){
    getStatistics();
    getTransactions();
    getGraphStatistics();
  });
  super.initState();
  }

  Future getUserData() async {
  print(userID);
  await Firestore.instance
      .collection('UsersAccounts')
      .document(userID)
      .get().then((value) {
        if (!mounted) return;
        setState(() {
          userName=value.data['UserName']+' '+value.data['UserLastName'];
        });
  });
  }

  Future getGraphStatistics()async{
  var expenses=[0.0];
  var income=[0.0];
  var higherLength=[0.0];
  var lowerLength=[0.0];
  var total=[0.0];
   await Firestore.instance.collection('Transactions')
       .where('UserID',isEqualTo: userID)
       .where('TransactionType',isEqualTo: 'Expenses')
       .getDocuments().then((value){
         setState(() {
           expenses.clear();
            for(int i =0;i < value.documents.length;i++){
              expenses.add(double.parse(double.parse(value.documents[i].data['TransactionAmount']).toStringAsFixed(2)));
          }
         });
   });
   await Firestore.instance.collection('Transactions')
       .where('UserID',isEqualTo: userID)
       .where('TransactionType',isEqualTo: 'Saving')
       .getDocuments().then((value){
         setState(() {
           income.clear();
            for(int i =0;i < value.documents.length;i++){
              income.add(double.parse(double.parse(value.documents[i].data['TransactionAmount']).toStringAsFixed(2)));
          }
         });
   });
   if(transactionsList.documents.length<5){
     setState(() {
       showGraph=false;
     });
   }else{
     if(income.length>=1 && income.length>=1){
       double totalVal;
       setState(() {
         if(income.length>expenses.length){
           higherLength=income;
           lowerLength=expenses;
           print('Income is bigger');
         }else if(expenses.length>income.length){
           higherLength=expenses;
           lowerLength=income;
           print('Expenses is bigger');
         }
         total.clear();
         for (int i = 0; i < lowerLength.length; i++) {
           totalVal=higherLength[i]-lowerLength[i];
           total.add(totalVal);
           higherLength.removeAt(i);
           lowerLength.removeAt(i);
         }
         for (int i = 0; i < higherLength.length; i++) {
           total.add(higherLength[i]);
         }
         statisticsGraphicList.clear();
         for(int i=0;i<total.length;i++){
           statisticsGraphicList.add(total[i]);
         }
         print(statisticsGraphicList.toString());
         showGraph=true;
       });
     }else{
       setState(() {
         showGraph=false;
       });
     }
   }

  }

  Future getStatistics()async{
    statistics= Firestore.instance.collection('Statistics').document(userID).snapshots();
    statistics.listen((value) {
      if (!mounted) return;
      setState(() {
        totalBalance=value.data['TotalBalance'];
        totalIncome=value.data['TotalIncome'];
        totalExpenses=value.data['TotalExpenses'];
      });
    });
  }

  Future getTransactions()async{
    transactions= Firestore.instance
        .collection('Transactions')
        .where('UserID', isEqualTo: userID)
        .orderBy('TransactionDate',descending: true)
        .snapshots();
    transactions.listen((value) {
      if (!mounted) return;
      setState(() {
        transactionsList=value;
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
      body: topHeader(),
    );
  }

  Widget topHeader(){
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
                  child: Center(child: Icon(Icons.add_circle_outline,size: 25,color: Colors.white,)),
                ),
                onPressed: (){
                  //getGraphStatistics();
                  Navigator.of(context).pushReplacement(// Navigating without replacement
                      new CupertinoPageRoute(builder: (BuildContext context) => new TransactionCUD(
                        userID: userID,// UserID Value
                        title: 'New Transaction',
                      )
                      )
                  );
              },
              ),
            ],
          ),
          SizedBox(height: 10,),
          statisticsSection(),
          //SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
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
          transactionFlowList(),
        ],
      ),
    );
  }

  Widget statisticsSection(){
  return Padding(
    padding: const EdgeInsets.all(5),
    child: InkWell(
      onTap: (){
        getStatistics();
        getTransactions();
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
                    Text(totalBalance.toStringAsFixed(2),
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
                      visible: showGraph,
                      child: Sparkline(
                        data: statisticsGraphicList,
                        pointsMode: PointsMode.all,
                        pointSize: 5.0,
                        pointColor: Colors.white,
                        lineWidth: 2.0,
                        lineColor: Color(0xFFFFF805E),
                        fillMode: FillMode.none,
                      ),
                      replacement: Center(
                        child: Text('No Enough Data To Show Graph',
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

  Widget transactionFlowList(){
  if(transactionsList!=null){
    return Expanded(
      flex: 1,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: transactionsList.documents.length,
        shrinkWrap: true,
        itemBuilder: (context,i){
          return Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    //ToDo:Edit Entered Data And Fetch to DB
                    showModalBottomSheet(context: context, builder: (context){
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
                              onTap: ()async{
                                getStatistics().whenComplete(() async{
                                  if(transactionsList.documents[i].data['TransactionType']=='Saving'){
                                    await Firestore.instance.collection('Statistics').document(userID).updateData({
                                      'TotalBalance':totalBalance - double.parse(transactionsList.documents[i].data['TransactionAmount']),
                                      'TotalIncome':totalIncome - double.parse(transactionsList.documents[i].data['TransactionAmount'])
                                    });
                                    await Firestore.instance.collection('Transactions').document(transactionsList.documents[i].documentID).delete().whenComplete(() {
                                      getGraphStatistics();
                                      getStatistics();
                                      getTransactions();
                                      Navigator.of(context).pop();
                                    });
                                  }else if(transactionsList.documents[i].data['TransactionType']=='Expenses'){
                                    await Firestore.instance.collection('Statistics').document(userID).updateData({
                                      'TotalBalance':totalBalance + double.parse(transactionsList.documents[i].data['TransactionAmount']),
                                      'TotalExpenses':totalExpenses - double.parse(transactionsList.documents[i].data['TransactionAmount'])
                                    });
                                    await Firestore.instance.collection('Transactions').document(transactionsList.documents[i].documentID).delete().whenComplete(() {
                                      getGraphStatistics();
                                      getStatistics();
                                      getTransactions();
                                      Navigator.of(context).pop();
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    });
                    print(transactionsList.documents[i].documentID);
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
                                color: filterTransactionLeading(transactionsList.documents[i].data['TransactionColor'].toString()),
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
                                  Text('Date: '+getCastedDate(transactionsList.documents[i].data['TransactionDate']),
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
                                      Text(transactionsList.documents[i].data['TransactionType'].toString(),
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
                                      Text(transactionsList.documents[i].data['TransactionAmount'].toString(),
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
                                      Text(transactionsList.documents[i].data['Category'].toString(),
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
                                      Text(transactionsList.documents[i].data['Description'].toString(),
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

  getCastedDate(Timestamp inputVal) {
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

    return processedDate;
  }
  filterTransactionLeading(String transType){
    Color exTransColor = Colors.red;
    Color incTransColor = Colors.green;
    Color val;
    switch (transType){
      case 'Red':{
      val=exTransColor;
      }break;
      case 'Green':{
        val=incTransColor;
      }
    }
    return val;
  }

}