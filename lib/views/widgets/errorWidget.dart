import 'package:flutter/material.dart';

Widget errmsg(String text) {
  //error message widget.
  return Container(
    alignment: Alignment.center,
    child: Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: Icon(Icons.error_outline_sharp)),
            Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            )
          ],
        ),
      ),
    ),
  );
}