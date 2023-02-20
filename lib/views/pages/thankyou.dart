import 'package:flutter/material.dart';
import 'package:printonex_final/views/pages/order_history.dart';

class Thankyou extends StatefulWidget {
  final fileurl;
  Thankyou({ this.fileurl});

  @override
  State<Thankyou> createState() => _ThankyouState();
}

class _ThankyouState extends State<Thankyou> {
  timeout() async{
    await Future.delayed(const Duration(seconds: 10), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderHistory(),
          ));
    });
  }
  @override
  void initState() {
    super.initState();
    timeout();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 100, right: 100, top: 100),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('images/success.png')
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Order Completed",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                            "Your order is completed Please Check Your mail for file/invoice/bill.",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3a3a3b),
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 100, right: 100, top: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.greenAccent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                textStyle: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderHistory(),
                                  ));
                            },
                            child: Center(
                              child: Text(
                                "Order History",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
