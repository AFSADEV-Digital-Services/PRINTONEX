import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:printonex_final/views/pages/thankyou.dart';


enum SingingCharacter { cash, online }

class Payment extends StatefulWidget {
  final userid, price, fileid;
  Payment({this.userid, this.price, this.fileid});
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  SingingCharacter? paymentmode = SingingCharacter.cash;
paymentcheck(amount){

if (paymentmode==SingingCharacter.cash){
Navigator.of(context).push(MaterialPageRoute(
builder: (context) => Thankyou()));
}
else{
initiateTransaction(amount);
}
}
  final TextEditingController _controller = TextEditingController();

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
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        child: Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.info,
                              color: Colors.greenAccent,
                            ),
                            onPressed: null),
                        Text(
                          'Total :',
                          style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' \₹'+ widget.price,
                          style: TextStyle(fontSize: 17.0, color: Colors.black),
                        ),
                      ],
                    )),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1.0, color: Colors.greenAccent),
                          ),
                          child: const Text(
                            'PROCESS',
                            style: TextStyle(
                                fontSize: 17.0, color: Colors.greenAccent),
                          ),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            String amount = widget.price;
                            paymentcheck(amount);
                            //initiateTransaction(amount);
                          },
                        ),
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
          title: Text("Payment",
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
        body: Column(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              'Delivery',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black38),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                Icons.play_circle_outline,
                                                color: Colors.black38,
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
                                                color: Colors.black),
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                Icons.check_circle,
                                                color: Colors.greenAccent,
                                              ),
                                              onPressed: null)
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ],
                        )))),
            VerticalDivider(),
            Container(
                margin: EdgeInsets.all(10.0),
                child: Card(
                  child: Container(
                    color: Colors.green.shade100,
                    child: Container(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                        child: Text(
                            "GET EXTRA 5% OFF* with MONEY bank Simply Pay Online T&C.",
                            maxLines: 10,
                            style: TextStyle(
                                fontSize: 13.0, color: Colors.black87))),
                  ),
                )),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                  left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
              child: Text(
                'Payment Method',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            VerticalDivider(),
            Container(
                // height: 264.0,
                margin: EdgeInsets.all(10.0),
                child: Card(
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Container(

                        child: RadioListTile<SingingCharacter>(
                          title: Text("Online"),
                          subtitle: Text("Paytm/ GPay/ AmazonPay"),
                          tileColor: MaterialStateColor.resolveWith((states) => Colors.white ),
                          activeColor: MaterialStateColor.resolveWith((states) => Colors.greenAccent ),
                          selectedTileColor: MaterialStateColor.resolveWith((states) => Colors.orange),
                          secondary: Icon(Icons.credit_card),
                          value: SingingCharacter.online,
                          groupValue: paymentmode,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              paymentmode = value;
                            });
                          },
                        ),
                      ),
                      Divider(),
                      Container(

                          child: RadioListTile<SingingCharacter>(
                            secondary: Icon(Icons.wallet_travel),
                            title: Text("Cash"),
                            subtitle: Text("Cash On Delivery/ Cash On Shop"),
                            tileColor: MaterialStateColor.resolveWith((states) => Colors.white ),
                            activeColor: MaterialStateColor.resolveWith((states) => Colors.greenAccent),
                            selectedTileColor: MaterialStateColor.resolveWith((states) => Colors.orange),
                            value: SingingCharacter.cash,
                            groupValue: paymentmode,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                paymentmode = value;
                              });
                            },
                          )),
                    ],
                  )),
                )),

          ],
        ));
  }

  void initiateTransaction(String amount) async {
    Map<String, dynamic> body = {
      'amount': amount,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.parse("https://afsadev.in/api/payment/generate_token.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );

    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      var bodyJson = jsonDecode(res.body);
      //  on success of txtoken generation api
      //  start transaction

      var response = AllInOneSdk.startTransaction(
        bodyJson['mid'], // merchant id  from api
        bodyJson['orderId'], // order id from api
        amount, // amount
        bodyJson['txnToken'], // transaction token from api
        "", // callback url
        false, // isStaging
        false, // restrictAppInvoke
      ).then((value) {
        //  on payment completion we will verify transaction with transaction verify api
        //  after payment completion we will verify this transaction
        //  and this will be final verification for payment

        print(value);
        verifyTransaction(bodyJson['orderId']);
      }).catchError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body),
        ),
      );
    }
  }

  void verifyTransaction(String orderId) async {
    Map<String, dynamic> body = {
      'orderId': orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.parse("https://afsadev.in/api/payment/verify_transaction.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );

    print(res.body);
    print(res.statusCode);
// json decode
    var verifyJson = jsonDecode(res.body);
//  display result info > result msg

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(verifyJson['body']['resultInfo']['resultMsg']),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
