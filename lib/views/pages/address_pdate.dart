import 'package:flutter/material.dart';

class AddressUpdate extends StatefulWidget {
  const AddressUpdate({Key? key}) : super(key: key);

  @override
  State<AddressUpdate> createState() => _AddressUpdateState();
}

class _AddressUpdateState extends State<AddressUpdate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text("Open Popup"),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Login'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Message',
                              icon: Icon(Icons.message ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    RaisedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          // your code
                        })
                  ],
                );
              });
        },
      ),
    );
  }
}
