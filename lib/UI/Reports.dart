import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DashBoard.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

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
  double totalIncomeAmount=0.0;
  double totalExpensesAmount=0.0;
  QuerySnapshot statementOfAccountList;
  List<String> colorListArray = new List();
  String textTotalRows='0';
  DateTime statementOfAccountDateFrom = DateTime.now();
  DateTime statementOfAccountDateTo = DateTime.now();
  String statementOfAccountDateFromString=DateTime.now().toString().substring(0,10);
  String statementOfAccountDateToString=DateTime.now().toString().substring(0,10);
bool showStatementFlowList=false;
  @override
  void initState() {
    statementOfAccountDateFrom=setDateFormatWithoutTimeFrom(statementOfAccountDateFrom);
    statementOfAccountDateTo=setDateFormatWithoutTimeTo(statementOfAccountDateTo);
    setState(() {
      userID=widget.userID;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setDateFormatWithoutTimeFrom(pDate){
    String mvTempDate=pDate.toString().substring(0,10);
    mvTempDate=mvTempDate + ' 00:00:00.000';
    DateTime settedNewDate=DateTime.parse(mvTempDate);
    return settedNewDate;
  }

  setDateFormatWithoutTimeTo(pDate){
    String mvTempDate=pDate.toString().substring(0,10);
    mvTempDate=mvTempDate + ' 23:59:00.000';
    DateTime settedNewDate=DateTime.parse(mvTempDate);
    return settedNewDate;
  }

 Future getStatement() async {
     await Firestore.instance.collection('Transactions')
        .where('TransactionDate', isGreaterThanOrEqualTo: statementOfAccountDateFrom)
        .where('TransactionDate', isLessThanOrEqualTo: statementOfAccountDateTo)
        .where('UserID', isEqualTo: userID)
        .orderBy('TransactionDate', descending: false)
        .getDocuments().then((value) {
      statementOfAccountList=value;
    });
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

  calculateTotals(){
    double totalIncome=0.0;
    double totalExpenses=0.0;
    int i=0;
    while (i<statementOfAccountList.documents.length){
      if (statementOfAccountList.documents[i].data['TransactionType']=='Expenses'){
        totalExpenses=totalExpenses+double.parse(statementOfAccountList.documents[i].data['TransactionAmount']);
      }else{
        totalIncome=totalIncome+double.parse(statementOfAccountList.documents[i].data['TransactionAmount']);
      }
      print('Expenses= $totalExpenses');
      print('Income= $totalIncome');
      i++;
    }
    setState(() {
      totalIncomeAmount=totalIncome;
      totalExpensesAmount=totalExpenses;
    });
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8.0),
            child: headerStatus(),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: statementFlowList(),
          )
        ],
      ),
    );
  }

  Widget headerStatus(){
    return Container(
      height: 135,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Color(0xFF40084d),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('From: $statementOfAccountDateFromString    ',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
                Text('To: $statementOfAccountDateToString',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),

              ],
            ),
            SizedBox(height: 3.5,),
            Row(
              children: <Widget>[
                Text('Total Income: ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
                Text('$totalIncomeAmount',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
                Text('  SAR',
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.5,),
            Row(
              children: <Widget>[
                Text('Total Expenses: ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
                Text('$totalExpensesAmount',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
                Text('  SAR',
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ],
            ),
            SizedBox(height: 1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Theme(
                  data: Theme.of(context).copyWith(
                      dialogBackgroundColor: Colors.white,  // Calendar Background Color
                      accentColor: Color(0xFF40084d),  // Calendar Buttons range
                      primaryColor: Color(0xFF40084d),  // Calendar Title
                      buttonTheme: ButtonThemeData(
                          buttonColor: Colors.white,
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                              secondary: Color(0xFF40084d),
                              background: Color(0xFF40084d),
                              primary: Color(0xFF40084d),
                              brightness: Brightness.light,
                              onBackground: Color(0xFF40084d)),
                          textTheme: ButtonTextTheme.primary)),
                  child: new Builder(
                    builder: (context) => new MaterialButton(
                      child: IconButton(
                        icon: Icon(Icons.date_range,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () async {
                          final List<DateTime> datePicked =
                          await DateRagePicker.showDatePicker(
                              context: context,
                              initialFirstDate: new DateTime.now(),
                              initialLastDate: (new DateTime.now())
                                  .add(new Duration(days: 4)),
                              firstDate: new DateTime(2020),
                              lastDate: new DateTime(2025));
                          if (datePicked != null && datePicked.length == 2) {
                            setState(() {
                              statementOfAccountDateFromString = datePicked[0].toString().substring(0, 10);
                              statementOfAccountDateToString = datePicked[1].toString().substring(0, 10);
                              statementOfAccountDateFrom=DateTime.parse(statementOfAccountDateFromString);
                              statementOfAccountDateTo=DateTime.parse(statementOfAccountDateToString);
                              statementOfAccountDateFrom=setDateFormatWithoutTimeFrom(statementOfAccountDateFrom);
                              statementOfAccountDateTo=setDateFormatWithoutTimeTo(statementOfAccountDateTo);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.cloud_download,color: Colors.white,size: 30,),
                  onPressed: (){
                    showInSnackBar('Please wait...');
                    getStatement().whenComplete(() {
                      statementFlowList();
                      setState(() {
                        showStatementFlowList=true;
                      });
                      calculateTotals();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  transactionColoringByType(String transType){
    Color exTransColor = Colors.red.withOpacity(0.4); // variable of type color that hold red color
    Color incTransColor = Colors.green.withOpacity(0.4); // variable of type color that hold green color
    Color val; // variable that hold chosen color
    switch (transType){ // switch case parameter color
      case 'Expenses':{ // in case of passed color is red then ...
        val=exTransColor; // set val to exTransColor (expenses Transaction Color) (red)
      }break; // break
      case 'Saving':{ // in case of passed color is green then.....
        val=incTransColor;// set val to incTransColor (income Transaction Color) (green)
      }
    }
    return val; // return chosen color
  }

  Widget statementFlowList(){
    if(statementOfAccountList!=null){
      if (statementOfAccountList.documents.length>0){
        return Visibility(
          visible: showStatementFlowList,
          child: Container(
            height: 630,
            width: double.maxFinite,
            child: ListView.builder(
                itemCount: statementOfAccountList.documents.length,
                shrinkWrap: true,
                itemBuilder: (context,i){
                  return Container(
                    height: 45, // Trans Height
                    decoration: BoxDecoration(
                      color: transactionColoringByType(statementOfAccountList.documents[i].data['TransactionType']),// Trans Color
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white),
                    ),
                    child: ListTile(
                      title: Column(
                        children: <Widget>[
                          Center(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Date: ',
                                  style: TextStyle(
                                      color: Color(0xFF40084d),
                                      fontSize: 13
                                  ),
                                ),
                                Text(
                                  getCastedDate(statementOfAccountList.documents[i].data['TransactionDate']).toString(),
                                  style: TextStyle(
                                      color: Color(0xFF40084d),
                                      fontSize: 13
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Transaction Type: ',
                                style: TextStyle(
                                    color: Color(0xFF40084d),
                                    fontSize: 13
                                ),
                              ),
                              Text(
                                statementOfAccountList.documents[i].data['TransactionType'],
                                style: TextStyle(
                                    color: Color(0xFF40084d),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                'Transaction Amount: ',
                                style: TextStyle(
                                  color: Color(0xFF40084d),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                statementOfAccountList.documents[i].data['TransactionAmount'],
                                style: TextStyle(
                                    color: Color(0xFF40084d),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
          replacement: Padding(
            padding: const EdgeInsets.only(top:100.0),
            child: Center(
              child: Text(
                'No Transactions Found...',
                style: TextStyle(
                    color: Color(0xFF40084d),
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        );
      }else{
        return Padding(
          padding: const EdgeInsets.only(top:100.0),
          child: Center(
            child: Text(
              'No Transactions Found...',
              style: TextStyle(
                  color: Color(0xFF40084d),
                  fontSize: 15,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
        );
      }
    }else{
      return Padding(
        padding: const EdgeInsets.only(top:100.0),
        child: Center(
          child: Text(
            'No Transactions Found...',
            style: TextStyle(
                color: Color(0xFF40084d),
                fontSize: 15,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      );
    }
  }
}