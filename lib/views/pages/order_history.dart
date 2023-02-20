import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}
class Item {
  final String name;
  final String deliveryTime;
  final String oderId;
  final String oderAmount;
  final String paymentType;
  final String address;
  final String cancelOder;
  final String payment_status;

  Item(
      {required this.name,
        required this.deliveryTime,
        required this.oderId,
        required this.oderAmount,
        required this.paymentType,
        required this.address,
        required this.cancelOder,
        required this.payment_status
      });
}
class _OrderHistoryState extends State<OrderHistory>  {
  List list = ['12', '11'];
  bool checkboxValueA = true;
  bool checkboxValueB = false;
  bool checkboxValueC = false;
  late VoidCallback _showBottomSheetCallback;

  getData() async {
    print("Taped---------------");
    final auth = FirebaseAuth.instance;
    dynamic user;
    String userEmail, uid;
    user = auth.currentUser!;
    uid = user.uid;
    QuerySnapshot bannersRef =
    await FirebaseFirestore.instance.collection('orders').doc('$uid').collection('$uid').get();
    setState(() {
      for (int g = 0; g < bannersRef.docs.length; g++) {
        itemList.add(
            Item(
                name: bannersRef.docs[g]["email"].toString(),
                deliveryTime: bannersRef.docs[g]["dileveryon"].toString(),
                oderId: bannersRef.docs[g]["orderid"].toString(),
                oderAmount: bannersRef.docs[g]["amount"].toString(),
                paymentType: bannersRef.docs[g]["payment_type"].toString(),
                payment_status: bannersRef.docs[g]["payment_status"].toString(),
                address: bannersRef.docs[g]["address"].toString(),
                cancelOder: bannersRef.docs[g]["order_status"].toString()),
          );
      }
    });
    print(itemList.toString());
    return bannersRef.docs;

  }

  List<Item> itemList = <Item>[];
  @override
  void initState() {
    super.initState();
    getData();
  }
  // String toolbarname = 'Fruiys & Vegetables';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {


    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          backgroundColor: Colors.greenAccent,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("Order History",
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(Icons.refresh, color: Color(0xFF545D68)),
                onPressed: () {
                  getData();
                },
              ),
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (BuildContext cont, int ind) {
              return SafeArea(
                  child: Column(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),

                        child: Card(
                            elevation: 5.0,
                            child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 15.0, 10.0, 10.0),
                                child: GestureDetector(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        // three line description
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            itemList[ind].name,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(top: 3.0),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'To Deliver On :'
                                             ,
                                            style: TextStyle(
                                                fontSize: 13.0, color: Colors.black54),
                                          ),
                                        ),
                                        Divider(
                                          height: 10.0,
                                          color: Colors.amber.shade500,
                                        ),

                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                padding: EdgeInsets.all(3.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      'Order Id',
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.black54),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 3.0),
                                                      child: Text(
                                                        '#'+itemList[ind].oderId,
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black87),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                            Container(
                                                padding: EdgeInsets.all(3.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      'Order Amount',
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.black54),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 3.0),
                                                      child: Text(
                                                        '₹ '+itemList[ind].oderAmount,
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black87),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                                padding: EdgeInsets.all(3.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      'Payment Status',
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.black54),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 3.0),
                                                      child: Text(
                                                        itemList[ind].payment_status,
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black87),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                                padding: EdgeInsets.all(3.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      'Payment Type',
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.black54),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 3.0),
                                                      child: Text(
                                                        itemList[ind].paymentType,
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black87),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Divider(
                                          height: 10.0,
                                          color: Colors.amber.shade500,
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              size: 20.0,
                                              color: Colors.amber.shade500,
                                            ),
                                            Text(itemList[ind].address,
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black54)),
                                          ],
                                        ),
                                        Divider(
                                          height: 10.0,
                                          color: Colors.amber.shade500,
                                        ),
                                        Container(
                                            child: _status(itemList[ind].cancelOder))
                                      ],
                                    ))))),
                  ]));
            }));
  }

  _verticalDivider() => Container(
    padding: EdgeInsets.all(2.0),
  );

  Widget _status(status) {
    if (status == 'Cancel Order') {
      return FlatButton.icon(
          label: Text(
            status,
            style: TextStyle(color: Colors.red),
          ),
          icon: const Icon(
            Icons.highlight_off,
            size: 18.0,
            color: Colors.red,
          ),
          onPressed: () {
            // Perform some action
          });
    } else {
      return FlatButton.icon(
          label: Text(
            status,
            style: TextStyle(color: Colors.green),
          ),
          icon: const Icon(
            Icons.check_circle,
            size: 18.0,
            color: Colors.green,
          ),
          onPressed: () {
            // Perform some action
          });
    }
    if (status == "3") {
      return Text('Process');
    } else if (status == "1") {
      return Text('Order');
    } else {
      return Text("Waiting");
    }
  }

  erticalD() => Container(
    margin: EdgeInsets.only(left: 10.0, right: 0.0, top: 0.0, bottom: 0.0),
  );

  bool a = true;
  String mText = "Press to hide";
  double _lowerValue = 1.0;
  double _upperValue = 100.0;

  void _visibilitymethod() {
    setState(() {
      if (a) {
        a = false;
        mText = "Press to show";
      } else {
        a = true;
        mText = "Press to hide";
      }
    });
  }
}
