import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:printonex_final/views/pages/payment.dart';


import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {

  final String price, fileurl, product, producturl;
  Checkout({required this.price, required this.fileurl,required this.product,required this.producturl});


  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String address = '';
  late String total;
  var priceController = TextEditingController();
  var random = Random().nextInt(500000);
  var checkoutapi= "https://afsadev.in/api/checkout.php";
  String _address = '';
  String _pincode='';
  String _phone= '';
  String? _loginAuth;

 _determinePosition() async {
   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   print(position.toString());
  }
  @override
  void initState() {
    super.initState();

    //_loginAuth;
     //LoginPage();


  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
          alignment: Alignment.bottomCenter,
          height: 70.0,
          child: Card(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.info, color: Colors.greenAccent,), onPressed: null),
                      Text(
                        'Total' ,
                        style: TextStyle(fontSize: 17.0, color: Colors.black),
                      ),
                      Text(
                        '₹ ' ,
                        style: TextStyle(fontSize: 17.0, color: Colors.black),
                      ),
                      Text(
                        widget.price.toString(),
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),


                    ],

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.center,

                    child: OutlinedButton(

                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: Colors.greenAccent),
                      ),
                      child: const Text('CONFIRM ORDER',style: TextStyle(fontSize: 17.0, color: Colors.greenAccent),),

                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Payment(fileurl: widget.fileurl, price: widget.price, producturl: widget.producturl, product: widget.product, address: "Not Fill",)));
                     },
                    ),
                  ),
                ),
              ],
            ),
          )),
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
        title: Text("Checkout",
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Color(0xFF545D68))),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.notifications_none, color: Color(0xFF545D68)),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body:


           Stack(
            children: [
              Column(

                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      margin: EdgeInsets.all(5.0),
                      child: Card(
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // three line description
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  'Delivery',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.play_circle_outline,
                                                      color: Colors.greenAccent,
                                                    ),
                                                    onPressed: null)
                                              ],
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  'Payment',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black38),
                                                ),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.check_circle,
                                                      color: Colors.black38,
                                                    ),
                                                    onPressed: null)
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              )))),
                  Container(
                    alignment: Alignment.topLeft,
                    margin:
                    EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
                    child: Text(
                      'Delivery Address',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _determinePosition();
                    },
                    child: Container(
                        height: 165.0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            // margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 165.0,
                            width: MediaQuery.of(context).size.width,

                            child: Card(
                              elevation: 3.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 12.0,
                                            top: 5.0,
                                            right: 0.0,
                                            bottom: 5.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Text(
                                              '',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            // _verticalDivider(),
                                            Text(
                                              _address+"-"+_pincode,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
                                            ),
                                            // _verticalDivider(),
                                            Text(
                                              _phone,
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
                                            ),
                                            // _verticalDivider(),
                                            Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 00.0,
                                                  top: 05.0,
                                                  right: 0.0,
                                                  bottom: 5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Delivery Address',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black26,
                                                    ),
                                                  ),
                                                  // _verticalD(),
                                                  // Checkbox(
                                                  //   value: checkboxValueA,
                                                  //   onChanged: (bool value) {
                                                  //     setState(() {
                                                  //       checkboxValueA = value;
                                                  //     });
                                                  //   },
                                                  // ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),

                  Container(
                    alignment: Alignment.topLeft,
                    margin:
                    EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        Divider(height: 15.0),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 12.0, top: 5.0, right: 12.0, bottom: 5.0),
                    height: 170.0,

                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Expanded(
                              child: Container(
                                child: Text("Total Amount",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Text('₹'+widget.price ,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),

                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              Expanded(
                                child: Container(
                                  child: Text("Delivery Charge",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text("₹ 50",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],

                    ),

                  ),

                  //bottomNavigationBar: BottomBar(),
                ],
              ),
            ],
    ),




    );
  }
}







