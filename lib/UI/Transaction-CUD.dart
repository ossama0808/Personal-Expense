import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

import 'DashBoard.dart';

class TransactionCUD extends StatefulWidget {
  @override
  _TransactionCUDState createState() => _TransactionCUDState();
  TransactionCUD({this.userID,this.title,this.transactionID,this.transactionEdit});
  final String userID;
  final String title;
  final String transactionID;
  final DocumentSnapshot transactionEdit;
}

class _TransactionCUDState extends State<TransactionCUD> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();// Global Key to Control Screen from any stated object

  // variables Section
  bool transactionUpdate=false;
  String userID=' ';
  String transactionNo;
  String transactionAmount;
  String description;
  String descriptionLable='Description';
  int transactionTypeValue;
  String transactionType;
  var initialCategoryValue;
  String initialCategoryLable='Category';
  var transactionNoController = TextEditingController();
  var transactionAmountController = TextEditingController();
  String transactionAmountLable='Transaction Amount';
  var descriptionController = TextEditingController();
  num totalBalance;
  num totalExpenses;
  num totalIncome;

  @override
  void initState() {
    setState(() {
      userID=widget.userID;
    });
    getStatistics();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getStatistics()async{
    await Firestore.instance.collection('Statistics').document(userID).get().then((value) {
      if (!mounted) return;
      setState(() {
        totalBalance=value.data['TotalBalance'];
        totalExpenses=value.data['TotalExpenses'];
        totalIncome=value.data['TotalIncome'];
      });
      print(totalBalance.toString());
      print(totalExpenses.toString());
      print(totalIncome.toString());
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
          widget.title,
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
      body: main(),
    );
  }

  getTransactionToUpdate(String transID) async{

  }

  Widget main(){
    if(widget.transactionID==null && widget.title=='New Transaction'){
      setState(() {
        transactionUpdate=false;
      });
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
            top: 20,
            left: 8,
            right: 8,
            bottom: 8
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 195,
                  child: TextFormField(
                    controller: transactionNoController,// Variable that hold typed value
                    style: TextStyle(
                      color: Color(0xFF40084d), // Field Color
                      fontSize: 16,
                      height: 1,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Color(0xFF40084d),// Border Color
                              width: 2.0, // Border Width
                              style: BorderStyle.solid// Border Style
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Color(0xFF40084d),
                              width: 2.0,
                              style: BorderStyle.solid
                          )
                      ),
                      labelText: 'Transaction No',// Field Label
                      labelStyle: TextStyle(color: Color(0xFF40084d)),
                      focusColor: Color(0xFF40084d),
                      hoverColor: Color(0xFF40084d),
                      isDense: true,
                      counterStyle: TextStyle(color: Color(0xFF40084d), fontWeight: FontWeight.bold),
                    ),
                    onChanged: (transNo) {// Onchange Function Start hold typed value in 'transNo'
                      if (!mounted) return;
                      setState(() {// Setting typed value to a local variable
                        transactionNo=transNo;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 195,
                  child: TextFormField(
                    controller: transactionAmountController,// Variable that hold typed value
                    style: TextStyle(
                      color: Color(0xFF40084d), // Field Color
                      fontSize: 16,
                      height: 1,
                    ),
                    keyboardType: TextInputType.numberWithOptions(signed: false,decimal: true,),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Color(0xFF40084d),// Border Color
                              width: 2.0, // Border Width
                              style: BorderStyle.solid// Border Style
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Color(0xFF40084d),
                              width: 2.0,
                              style: BorderStyle.solid
                          )
                      ),
                      labelText: transactionAmountLable,// Field Label
                      labelStyle: TextStyle(color: Color(0xFF40084d)),
                      focusColor: Color(0xFF40084d),
                      hoverColor: Color(0xFF40084d),
                      isDense: true,
                      counterStyle: TextStyle(color: Color(0xFF40084d), fontWeight: FontWeight.bold),
                    ),
                    onChanged: (transAmount) {// Onchange Function Start hold typed value in 'transAmount'
                      if (!mounted) return;
                      setState(() {// Setting typed value to a local variable
                        transactionAmount=transAmount;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Transaction Type: ',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF40084d),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: transactionTypeValue,
                    onChanged: handleTransactionTypeValue,
                    activeColor: Color(0xFF40084d),
                  ),
                  Text(
                    'Saving',
                    style: TextStyle(
                        color: Color(0xFF40084d),
                        fontSize: 18
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: 2,
                    groupValue: transactionTypeValue,
                    onChanged: handleTransactionTypeValue,
                    activeColor: Color(0xFF40084d),
                  ),
                  Text(
                    'Expenses',
                    style: TextStyle(
                        color: Color(0xFF40084d),
                        fontSize: 18
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Category Type: ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF40084d),
                ),
              ),
              SizedBox(width: 20,),
              Icon(Icons.book,size: 16,color: Colors.black,),
              DropdownButton<String>(
                iconEnabledColor: Color(0xFF40084d),
                iconSize: 30,
                value: initialCategoryValue,
                //style: TextStyle(backgroundColor: colorPallet('vDropdownMenuBackGoundColor'), color: colorPallet('vDropdownMenuForeGoundColor'), decorationStyle: TextDecorationStyle.solid, fontSize: 18),
                onChanged: (String value) {
                  if (!mounted) return;
                  setState(() {
                    initialCategoryValue = value;
                  });
                  print(initialCategoryValue);
                },
                hint: Text(
                  initialCategoryLable,textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0xFF40084d), //Colors.amber,
                  ),
                ),
                items: <String>[
                  'Groceries',
                  'Personal care',
                  'Entertainment',
                  'Health expenses',
                  'Fuel',
                  'Electronics',
                  'Subscriptions',
                  'Utility bills',
                  'Other',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,textAlign: TextAlign.justify,
                      style: TextStyle(
                        //backgroundColor: colorPallet('vDropdownMenuBackGoundColor'),
                          color: Color(0xFF40084d)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10,top: 10),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: descriptionController,// Variable that hold typed value
              style: TextStyle(
                color: Color(0xFF40084d), // Field Color
                fontSize: 16,
                height: 1,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Color(0xFF40084d),// Border Color
                        width: 2.0, // Border Width
                        style: BorderStyle.solid// Border Style
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Color(0xFF40084d),
                        width: 2.0,
                        style: BorderStyle.solid
                    )
                ),
                labelText: descriptionLable,// Field Label
                labelStyle: TextStyle(color: Color(0xFF40084d)),
                focusColor: Color(0xFF40084d),
                hoverColor: Color(0xFF40084d),
                isDense: true,
                counterStyle: TextStyle(color: Color(0xFF40084d), fontWeight: FontWeight.bold),
              ),
              onChanged: (descriptionvalue) {// Onchange Function Start hold typed value in 'transAmount'
                if (!mounted) return;
                setState(() {// Setting typed value to a local variable
                  description=descriptionvalue;
                });
              },
            ),
          ),
          RaisedButton(// Login Button widget
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {// On Pressed Function
              FocusScope.of(context).unfocus();// Hide Keyboard
              validation();
            },
            padding: EdgeInsets.all(12),
            color: Color(0xFF40084d),
            child: Text('Save Transaction', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }else{
      setState(() {
        transactionUpdate=true;
        transactionAmountLable=widget.transactionEdit.data['TransactionAmount'];
        transactionAmount=widget.transactionEdit.data['TransactionAmount'];
        if(widget.transactionEdit.data['TransactionType']=='Saving'){
          transactionTypeValue=1;
          transactionType='Saving';
        }else{
          transactionTypeValue=2;
          transactionType='Expenses';
        }
        initialCategoryLable=widget.transactionEdit.data['Category'];
        initialCategoryValue=widget.transactionEdit.data['Category'];
        if(widget.transactionEdit.data['Description']==" "|| widget.transactionEdit.data['Description']==null){
          descriptionLable='Description';
          description=' ';
        }else{
          descriptionLable=widget.transactionEdit.data['Description'];
        }
      });
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
            top: 20,
            left: 8,
            right: 8,
            bottom: 8
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Transaction Amount: ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF40084d),
                  ),
                ),
                SizedBox(
                  width: 195,
                  child: TextFormField(
                    controller: transactionAmountController,// Variable that hold typed value
                    style: TextStyle(
                      color: Color(0xFF40084d), // Field Color
                      fontSize: 16,
                      height: 1,
                    ),
                    keyboardType: TextInputType.numberWithOptions(signed: false,decimal: true,),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Color(0xFF40084d),// Border Color
                              width: 2.0, // Border Width
                              style: BorderStyle.solid// Border Style
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Color(0xFF40084d),
                              width: 2.0,
                              style: BorderStyle.solid
                          )
                      ),
                      labelText: transactionAmountLable,// Field Label
                      labelStyle: TextStyle(color: Color(0xFF40084d)),
                      focusColor: Color(0xFF40084d),
                      hoverColor: Color(0xFF40084d),
                      isDense: true,
                      counterStyle: TextStyle(color: Color(0xFF40084d), fontWeight: FontWeight.bold),
                    ),
                    onChanged: (transAmount) {// Onchange Function Start hold typed value in 'transAmount'
                      print(transAmount);
                      if (!mounted) return;
                      setState(() {// Setting typed value to a local variable
                        transactionAmount=transAmount;
                      });
                      print(transactionAmount);
                    },
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Transaction Type: $transactionType',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF40084d),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Category Type: ',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF40084d),
                ),
              ),
              SizedBox(width: 20,),
              Icon(Icons.book,size: 16,color: Colors.black,),
              DropdownButton<String>(
                iconEnabledColor: Color(0xFF40084d),
                iconSize: 30,
                value: initialCategoryValue,
                //style: TextStyle(backgroundColor: colorPallet('vDropdownMenuBackGoundColor'), color: colorPallet('vDropdownMenuForeGoundColor'), decorationStyle: TextDecorationStyle.solid, fontSize: 18),
                onChanged: (String value) {
                  if (!mounted) return;
                  setState(() {
                    initialCategoryValue = value;
                  });
                  print(initialCategoryValue);
                },
                hint: Text(
                  initialCategoryLable,textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0xFF40084d), //Colors.amber,
                  ),
                ),
                items: <String>[
                  'Groceries',
                  'Personal care',
                  'Entertainment',
                  'Health expenses',
                  'Fuel',
                  'Electronics',
                  'Subscriptions',
                  'Utility bills',
                  'Other',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,textAlign: TextAlign.justify,
                      style: TextStyle(
                        //backgroundColor: colorPallet('vDropdownMenuBackGoundColor'),
                          color: Color(0xFF40084d)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10,top: 10),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: descriptionController,// Variable that hold typed value
              style: TextStyle(
                color: Color(0xFF40084d), // Field Color
                fontSize: 16,
                height: 1,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Color(0xFF40084d),// Border Color
                        width: 2.0, // Border Width
                        style: BorderStyle.solid// Border Style
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Color(0xFF40084d),
                        width: 2.0,
                        style: BorderStyle.solid
                    )
                ),
                labelText: descriptionLable,// Field Label
                labelStyle: TextStyle(color: Color(0xFF40084d)),
                focusColor: Color(0xFF40084d),
                hoverColor: Color(0xFF40084d),
                isDense: true,
                counterStyle: TextStyle(color: Color(0xFF40084d), fontWeight: FontWeight.bold),
              ),
              onChanged: (descriptionvalue) {// Onchange Function Start hold typed value in 'transAmount'
                if (!mounted) return;
                setState(() {// Setting typed value to a local variable
                  description=descriptionvalue;
                });
              },
            ),
          ),
          RaisedButton(// Login Button widget
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {// On Pressed Function
              FocusScope.of(context).unfocus();// Hide Keyboard
              if (transactionType=='Saving') {
                showInSnackBar('Saving Transaction.....');
                updateTransaction('Green');
              }else{
                  showInSnackBar('Saving Transaction.....');
                  updateTransaction('Red');
              }
            },
            padding: EdgeInsets.all(12),
            color: Color(0xFF40084d),
            child: Text('Update Transaction', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }
  }

  void handleTransactionTypeValue(int value) {
    if (!mounted) return;
    setState(() {
      transactionTypeValue=value;
    });
    switch (transactionTypeValue){
      case 1 :{
        if (!mounted) return;
        setState(() {
          transactionType='Saving';
        });
      }break;
      case 2 :{
        if (!mounted) return;
        setState(() {
          transactionType='Expenses';
        });
      }break;
    }
  }

  Future validation(){
    if(transactionNo==null){
      showInSnackBar('Transaction No Cannot be empty.');
    }else if(transactionAmount==null){
      showInSnackBar('Transaction Amount Cannot be empty.');
    }else if(transactionType==null){
      showInSnackBar('Transaction Type Cannot be empty.');
    }else if(initialCategoryValue==null){
      showInSnackBar('Category Type Cannot be empty.');
    }else if(description==null){
      setState(() {
        description=' ';
      });
    }else{
      if (transactionType=='Saving') {
        showInSnackBar('Saving Transaction.....');
        saveTransaction('Green');
      }else{
        if(double.parse(transactionAmount)>totalBalance){
          showInSnackBar('Transaction Amount is greater than your balance');
        }else {
          showInSnackBar('Saving Transaction.....');
          saveTransaction('Red');
        }
      }
    }
  }
  Future saveTransaction(String transColor)async{
    await Firestore.instance.collection('Transactions').add({
      'UserID':widget.userID,
      'TransactionNo':transactionNo,
      'TransactionAmount':transactionAmount,
      'TransactionType':transactionType,
      'Description':description,
      'Category':initialCategoryValue,
      'TransactionColor':transColor,
      'TransactionDate':DateTime.now(),
    }).whenComplete(() {
      updateStatistics().whenComplete(() {
        _scaffoldKey.currentState.hideCurrentSnackBar();
          navigateAfterProcess();

      });
    });
  }
  Future updateTransaction(String transColor)async{
    if (transactionAmountController.text==null){
      await Firestore.instance.collection('Transactions').document(widget.transactionEdit.documentID).updateData({
        'TransactionAmount':transactionAmountController.text,
        'TransactionType':transactionType,
        'Description':descriptionController.text,
        'Category':initialCategoryValue,
        'TransactionColor':transColor,
        'TransactionUpdateDate':DateTime.now(),
      }).whenComplete(() {
        updateStatistics().whenComplete(() {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          navigateAfterProcess();

        });
      });
    }
  }

  Future updateStatistics()async{
    if(transactionUpdate==false){
      num transactionAmountCasted;
      if (!mounted) return;
      setState(() {
        transactionAmountCasted=num.parse(transactionAmount);
      });
      if(transactionType=='Expenses'){
        if (!mounted) return;
        setState(() {
          totalExpenses=totalExpenses+transactionAmountCasted;
          totalBalance=totalBalance-transactionAmountCasted;
        });
        await Firestore.instance.collection('Statistics').document(widget.userID).updateData({
          'TotalBalance':totalBalance,
          'TotalExpenses':totalExpenses,
          'TotalIncome':totalIncome,

        });
      }else if(transactionType=='Saving'){
        if (!mounted) return;
        setState(() {
          totalIncome=totalIncome+transactionAmountCasted;
          totalBalance=totalBalance+transactionAmountCasted;
        });
        await Firestore.instance.collection('Statistics').document(widget.userID).updateData({
          'TotalBalance':totalBalance,
          'TotalExpenses':totalExpenses,
          'TotalIncome':totalIncome,

        });
      }
    }else{
      print(transactionAmount);
      print(transactionAmountLable);
      if(transactionAmountController.text==transactionAmountLable){
        // Do Noting
      }else{
        num castedTransactionAmountLable;
        num difference;
        if (!mounted) return;
        setState(() {
          castedTransactionAmountLable=num.parse(transactionAmountController.text);
          difference=castedTransactionAmountLable-num.parse(transactionAmountLable);
          print('diff'+ difference.toString());
        });
        if(transactionType=='Expenses'){
          if (!mounted) return;
          setState(() {
            totalExpenses=totalExpenses+difference;
            totalBalance=totalBalance-difference;
          });
          await Firestore.instance.collection('Statistics').document(widget.userID).updateData({
            'TotalBalance':totalBalance,
            'TotalExpenses':totalExpenses,
            'TotalIncome':totalIncome,

          });
        }else if(transactionType=='Saving'){
          if (!mounted) return;
          setState(() {
            totalIncome=totalIncome+difference;
            totalBalance=totalBalance+difference;
          });
          await Firestore.instance.collection('Statistics').document(widget.userID).updateData({
            'TotalBalance':totalBalance,
            'TotalExpenses':totalExpenses,
            'TotalIncome':totalIncome,

          });
        }
      }
    }
  }

  navigateAfterProcess(){
    return Navigator.of(context).pushReplacement(// Navigating with replacement
        new CupertinoPageRoute(builder: (BuildContext context) => new DashBoard(
          userID: userID,// UserID Value
        )
        )
    );
  }
}