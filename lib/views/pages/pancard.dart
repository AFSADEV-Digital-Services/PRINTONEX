import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/services/add_images.dart';
import 'package:printonex_final/services/validation.dart';

class PanCard extends StatefulWidget {
  const PanCard({Key? key}) : super(key: key);

  @override
  State<PanCard> createState() => _PanCardState();
}

class _PanCardState extends State<PanCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _aadharTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _addressTextController = TextEditingController();
    final _focusEmail = FocusNode();
  final _focusPhone = FocusNode();
  final _focusAadhar = FocusNode();
  final _focusAddress = FocusNode();
  final _focusName = FocusNode();
  List<String> selectedimages = [];
  List<String> images = [];

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const AppText(
          text: "Apply Pan Card Or Correction",
          color: Colors.black54,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Column(
            children: [
              Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color(0xffff8a00),
                      Color(0xffe52e71),
                    ],
                  )),
              height: ResponsiveFile.screenHeight/15,
              child: Center(
                child: Text("PAN CARD APPLY/CORRECTION", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
              ),
            ),
              Container(
                color: Color(0xff201c29),
                height: ResponsiveFile.screenHeight/1-200,
                width: ResponsiveFile.screenWidth,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: ResponsiveFile.height10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveFile.height20),
                          child: Text(
                            "Name",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveFile.font19),
                          ),
                        ),
                        SizedBox(height: ResponsiveFile.height10-5),
                        TextFormField(
                            controller: _nameTextController,
                            focusNode: _focusName,
                            autofillHints: [AutofillHints.name],
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left:
                                    ResponsiveFile.height20 + 10),
                                //focusColor: Colors.greenAccent,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveFile.height20 + 5),
                                  borderSide: const BorderSide(
                                      color: Colors.greenAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                //border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                        SizedBox(height: ResponsiveFile.height10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveFile.height20),
                          child: Text(
                            "Aadhar No.",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveFile.font19),
                          ),
                        ),
                        SizedBox(height: ResponsiveFile.height10-5),
                        TextFormField(
                            controller: _aadharTextController,
                            focusNode: _focusAadhar,
                            autofillHints: [AutofillHints.creditCardNumber],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left:
                                    ResponsiveFile.height20 + 10),
                                //focusColor: Colors.greenAccent,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveFile.height20 + 5),
                                  borderSide: const BorderSide(
                                      color: Colors.greenAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                //border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                        SizedBox(height: ResponsiveFile.height10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveFile.height20),
                          child: Text(
                            "Email",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveFile.font19),
                          ),
                        ),
                        SizedBox(height: ResponsiveFile.height10-5),
                        TextFormField(
                            controller: _emailTextController,
                            focusNode: _focusEmail,
                            autofillHints: [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                Validator.validateEmail(
                                  email: value,
                                ),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left:
                                    ResponsiveFile.height20 + 10),
                                //focusColor: Colors.greenAccent,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveFile.height20 + 5),
                                  borderSide: const BorderSide(
                                      color: Colors.greenAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                //border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                        SizedBox(height: ResponsiveFile.height10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveFile.height20),
                          child: Text(
                            "Phone Number",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveFile.font19),
                          ),
                        ),
                        SizedBox(height: ResponsiveFile.height10-5),
                        TextFormField(
                            controller: _phoneTextController,
                            focusNode: _focusPhone,
                            autofillHints: [AutofillHints.telephoneNumber],
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left:
                                    ResponsiveFile.height20 + 10),
                                //focusColor: Colors.greenAccent,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveFile.height20 + 5),
                                  borderSide: const BorderSide(
                                      color: Colors.greenAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                //border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),

                        SizedBox(height: ResponsiveFile.height10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveFile.height20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                "* Upload Aadhar,Photo and Signature",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveFile.font19),
                              ),

                              IconButton(onPressed: (){
                                _awaitReturnValueFromSecondScreen(context);
                              }, icon: Icon(Icons.add_a_photo,color: Colors.white,)),


                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          child: GridView.builder(
                            itemCount: selectedimages.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, i) {
                              return Center(
                                child: CachedNetworkImage(
                                  imageUrl: selectedimages[i],
                                  fit: BoxFit.contain,

                                  errorWidget: (context, url, error) =>
                                  const Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                    size: 120,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: ResponsiveFile.height20),
                        InkWell(
                          onTap: () async {
                            _focusEmail.unfocus();
                            _focusAddress.unfocus();
                            _focusAadhar.unfocus();
                            _focusName.unfocus();
                            _focusPhone.unfocus();

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isProcessing = true;
                              });
                              // bool isSuccess =
                              // await authProvider.signInUsingEmailPassword(
                              //   email: _emailTextController.text,
                              //   password: _passwordTextController.text,
                              // );

                              setState(() {
                                _isProcessing = false;
                              });
                              // if (isSuccess) {
                              //   Navigator.pushReplacement(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //           const MainScreen()));
                              // }
                            }
                          },
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 5 * 2,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),

                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xfffbb448),
                                        Color(0xfff7892b)
                                      ])),
                              child: _isProcessing
                                  ? SizedBox(
                                height: ResponsiveFile.height20,
                                width: ResponsiveFile.height20,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.orange[100],
                                  valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                      Colors.deepOrangeAccent),
                                ),
                              )
                                  : Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize: ResponsiveFile.font19,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color(0xffff8a00),
                        Color(0xffe52e71),
                      ],
                    )),
                height: ResponsiveFile.screenHeight/15,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Pay Now ₹250 or Visit to Pay — AFSADEV Digital Services , New Checkon Maring Ld-795001", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ),
              )
            ],
          )

        ],
      ),
    );
  }
  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddImages(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      images = result;
      for (int i = 0; i < images.length; i++) {
        selectedimages.add(images[i].toString());
      }
    });
    print(selectedimages);
  }
}
