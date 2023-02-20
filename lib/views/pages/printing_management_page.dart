import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printonex_final/consts/responsive_file.dart';
import 'package:printonex_final/consts/text_class.dart';
import 'package:printonex_final/views/pages/checkout.dart';


enum SingingCharacter { color, black }

class PrintCustomizer extends StatefulWidget {
  final List selectedImages;
  const PrintCustomizer({ required this.selectedImages});

  @override
  State<PrintCustomizer> createState() => _PrintCustomizerState();
}

class _PrintCustomizerState extends State<PrintCustomizer> {
  bool isAdButtonDisabled= false;
  SingingCharacter? printingtype = SingingCharacter.black;
  String? _mySelection = '2';
  late String price;
  //String? printType;
  var papertypeshow = 'A4';
  var color = ['Colour', 'Black'];
  var Colorshow = 'Colour';
  var subtotal = 0.0.obs;
  var copies = "1";
  var url = "https://afsadev.in/api/print_cat.php";
  List _product = [];
  List<String> selectedimages = [];
  var sumlive = 0.0.obs;
  var cost = 0.0.obs;

  static PrintCustomizer instance = Get.find();

  Future<String> product() async {
    var res =
    await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      _product = resBody;
    });

    if (kDebugMode) {
      print(resBody);
    }

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    product();
    setState(() {
      var images = widget.selectedImages;
      for (int i = 0; i < images.length; i++) {
        selectedimages.add(images[i].toString());
      }
    });
    print(selectedimages.toString());
    print(widget.selectedImages.toString());
  }

  loadPaperFromApi() async {
    var response = await http.get(Uri.parse(url));
    var productsJson = json.decode(response.body);
    print(productsJson);
    // print(productsJson[i]);

    return productsJson;

    // echo json_encode($list);
  }

  calcost(id) async {
    var response = await http.get(Uri.parse(url + "?id=" + id));
    var jsondata = json.decode(response.body);
    price = jsondata['price'];
    return cost(sumlive.value + int.parse(price));
  }

  TotalSum(cost) {
    return subtotal(subtotal.value * int.parse(cost));
  }



  @override
  void dispose() {
    product();
    copiesController;
    super.dispose();
  }

  int _count = 0;
  void _addCount() {
    setState(() {
      _count++;
      copiesController.text = (_count).toString();
      subtotal(cost * _count);
    });
  }

  void _removeCount() {
    setState(() {


      if (_count <= 1) {
        _count=1;
        copiesController.text = (_count).toString();
        subtotal(cost * _count);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.greenAccent,
            content: AppText(
              text: "You cannot tap more than 1",
              color: Colors.black54,
              size: ResponsiveFile.font16,
            ),
          ),
        );
      }else{
        _count--;
        copiesController.text = (_count).toString();
        subtotal(cost * _count);
      }
    });
  }


  int selectedIndex = 2;
  final copiesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.transparent,
        height: ResponsiveFile.height120,
        child: Column(
          children: [
            subTotalWidget(),
            SizedBox(
              height: ResponsiveFile.height10 / 2,
            ),
            checkoutWidget(),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Customize Print",
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: ResponsiveFile.height20,
                color: const Color(0xFF545D68))),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon:
              const Icon(Icons.add_shopping_cart, color: Color(0xFF545D68)),
              onPressed: () {},
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(ResponsiveFile.radius20),
          ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeLeft: true,
        removeRight: true,
        child: ListView(
          children: [
            imagePreviewWidget(),
            SizedBox(
              width: ResponsiveFile.screenWidth,
              height: ResponsiveFile.height20,
            ),
            paperTypeWidget(),
            SizedBox(
              width: ResponsiveFile.screenWidth,
              height: ResponsiveFile.height20,
            ),
            paperNumberWidget(),
            SizedBox(
              width: ResponsiveFile.screenWidth,
              height: ResponsiveFile.height20,
            ),
            // if (_mySelection == "1")
            //   Padding(
            //     padding:
            //         EdgeInsets.symmetric(horizontal: ResponsiveFile.height20),
            //     child: Row(
            //       children: [
            //         AppText(
            //             text: "Printing Type:",
            //             size: ResponsiveFile.font16,
            //             fontWeight: FontWeight.bold),
            //     Expanded(
            //       child: ListTile(
            //         leading: Radio(
            //
            //             value: 1,
            //             groupValue: printType,
            //             onChanged: (value){
            //               setState(() {
            //                 printType = value.toString();
            //               });
            //             },
            //           ),
            //       ),
            //     ),
            //       Expanded(
            //         child: ListTile(
            //         leading:  Radio(
            //
            //             value: 2,
            //             groupValue: printType,
            //             onChanged: (value){
            //               setState(() {
            //                 printType = value.toString();
            //               });
            //             },
            //           ),
            //     ),
            //       ),
            //
            //         // Padding(
            //         //   padding: EdgeInsets.only(left: ResponsiveFile.height15),
            //         //   child: ClipRRect(
            //         //     borderRadius:
            //         //         BorderRadius.circular(ResponsiveFile.radius20),
            //         //     child: InkWell(
            //         //       onTap: () {
            //         //         setState(() {
            //         //           selectedIndex = 2;
            //         //           TotalSum(selectedIndex.toString());
            //         //         });
            //         //       },
            //         //       child: Container(
            //         //         height: ResponsiveFile.height80 / 2,
            //         //         width: ResponsiveFile.height80,
            //         //         alignment: Alignment.center,
            //         //         decoration: (selectedIndex == 2)
            //         //             ? const BoxDecoration(
            //         //                 gradient: LinearGradient(
            //         //                   colors: [
            //         //                     Color(0xffff416c),
            //         //                     Color(0xffFF4B2B),
            //         //                     Color(0xffff9c2b),
            //         //                     Color(0xfffff42b),
            //         //                   ],
            //         //                   stops: [0.8, 0.2, 0.2, 0.8],
            //         //                 ),
            //         //               )
            //         //             : BoxDecoration(
            //         //                 borderRadius: BorderRadius.circular(
            //         //                     ResponsiveFile.radius20),
            //         //                 gradient: const LinearGradient(
            //         //                   colors: [
            //         //                     Color(0xff41ff84),
            //         //                     Color(0xff2bffdf),
            //         //                   ],
            //         //                   stops: [0.4, 0.9],
            //         //                 ),
            //         //                 boxShadow: const [
            //         //                     BoxShadow(
            //         //                       color: Colors.grey,
            //         //                       blurRadius: 5.0,
            //         //                     ),
            //         //                   ]),
            //         //         child: AppText(
            //         //             text: "Color",
            //         //             size: ResponsiveFile.font14,
            //         //             color: Colors.white),
            //         //       ),
            //         //     ),
            //         //   ),
            //         // ),
            //         // Padding(
            //         //   padding: EdgeInsets.only(left: ResponsiveFile.height10),
            //         //   child: ClipRRect(
            //         //     borderRadius:
            //         //         BorderRadius.circular(ResponsiveFile.radius20),
            //         //     child: InkWell(
            //         //       onTap: () {
            //         //         setState(() {
            //         //           selectedIndex = 1;
            //         //           TotalSum(selectedIndex.toString());
            //         //         });
            //         //       },
            //         //       child: Container(
            //         //         height: ResponsiveFile.height80 / 2,
            //         //         width: ResponsiveFile.height80 + 10,
            //         //         alignment: Alignment.center,
            //         //         decoration: (selectedIndex == 1)
            //         //             ? BoxDecoration(
            //         //                 borderRadius: BorderRadius.circular(
            //         //                     ResponsiveFile.radius20),
            //         //                 gradient: const LinearGradient(
            //         //                   colors: [Colors.black54, Colors.grey],
            //         //                   stops: [0.4, 0.9],
            //         //                 ),
            //         //               )
            //         //             : BoxDecoration(
            //         //                 borderRadius: BorderRadius.circular(
            //         //                     ResponsiveFile.radius20),
            //         //                 gradient: const LinearGradient(
            //         //                   colors: [Colors.black54, Colors.grey],
            //         //                   stops: [0.4, 0.9],
            //         //                 ),
            //         //                 border: Border.all(),
            //         //                 boxShadow: const [
            //         //                     BoxShadow(
            //         //                       color: Colors.grey,
            //         //                       blurRadius: 5.0,
            //         //                     ),
            //         //                   ]),
            //         //         child: AppText(
            //         //             text: "Black/White",
            //         //             size: ResponsiveFile.font14,
            //         //             color: Colors.white),
            //         //       ),
            //         //     ),
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   )
            // else
            //   Padding(
            //     padding:
            //         EdgeInsets.symmetric(horizontal: ResponsiveFile.height20),
            //     child: Row(
            //       children: [
            //         AppText(
            //             text: "Printing Type:",
            //             size: ResponsiveFile.font16,
            //             fontWeight: FontWeight.bold),
            //         Padding(
            //           padding: EdgeInsets.only(left: ResponsiveFile.height15),
            //           child: Container(
            //             height: ResponsiveFile.height80 / 2,
            //             width: ResponsiveFile.height80,
            //             alignment: Alignment.center,
            //             decoration: BoxDecoration(
            //                 borderRadius:
            //                     BorderRadius.circular(ResponsiveFile.radius20),
            //                 gradient: const LinearGradient(
            //                   colors: [Color(0xffff416c), Color(0xffFF4B2B)],
            //                   stops: [0.4, 0.9],
            //                 )),
            //             child: AppText(
            //                 text: "Color",
            //                 size: ResponsiveFile.font14,
            //                 color: Colors.white),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Stack imagePreviewWidget() {
    return Stack(
      children: [
        SizedBox(
          height: ResponsiveFile.height480,
          width: ResponsiveFile.screenWidth,
          child: CachedNetworkImage(
              imageUrl: widget.selectedImages.toString(),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.fill),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: ResponsiveFile.screenWidth,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ResponsiveFile.height30),
                    topRight: Radius.circular(ResponsiveFile.height30))),
            padding: EdgeInsets.symmetric(
                vertical: ResponsiveFile.height10,
                horizontal: ResponsiveFile.height20),
            child: Row(
              children: [

                AppText(
                  text: "fdsfdsf",
                  fontWeight: FontWeight.w300,
                  size: ResponsiveFile.font16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding paperNumberWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveFile.height20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: AppText(
                text: "No Of Copies:",
                size: ResponsiveFile.font16,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: Colors.greenAccent,
                  onPrimary: Colors.black54),
              child: const Icon(Icons.remove),
              onPressed: () {
                _removeCount();
              },
            ),
          ),
          // Flexible(
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 10.0),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //             colors: [Colors.greenAccent, Colors.redAccent]),
          //         border: Border.all(
          //           color: Colors.cyanAccent,
          //         ),
          //         borderRadius: BorderRadius.circular(32),
          //       ),
          //       //padding: EdgeInsets.only(left:5.0, bottom: 5),
          //       alignment: Alignment.center,
          //       height: 40,
          //       width: 90,
          //       child: TextField(
          //         keyboardType: TextInputType.number,
          //           textAlignVertical: TextAlignVertical.center,
          //           textAlign: TextAlign.center,
          //           // onChanged: (_count) {
          //           //   //set username  text on change
          //           //   TotalSum(_count);
          //           //   copies = _count;
          //           // },
          //           //Email Fillled,
          //           controller: copiesController,
          //           decoration: InputDecoration(
          //               contentPadding: new EdgeInsets.symmetric(
          //                   horizontal: 8.0, vertical: 8.0),
          //               // contentPadding:
          //               // EdgeInsets.only(left: 25.0),
          //               //focusColor: Colors.red,
          //               focusedBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(25),
          //                 borderSide: BorderSide(color: Colors.red),
          //               ),
          //               enabledBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(25),
          //                 borderSide: BorderSide(
          //                   color: Colors.white,
          //                 ),
          //               ),
          //               //border: InputBorder.none,
          //               fillColor: Colors.white,
          //               filled: true)),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: AppText(
                text: _count.toString(), size: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: Colors.greenAccent,
                  onPrimary: Colors.black54),
              child: const Icon(Icons.add),
              onPressed: () {
                _addCount();
                // TotalSum(_count);
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding paperTypeWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveFile.height20,
      ),
      child: Row(
        children: [
          AppText(
              text: "Paper type:",
              size: ResponsiveFile.font16,
              fontWeight: FontWeight.bold),
          SizedBox(
            width: ResponsiveFile.height20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: DropdownButton<String>(
              items: _product.map((item) {
                return DropdownMenuItem(
                  value: item['id'].toString(),
                  child: AppText(text: item['cat_titile']),
                );
              }).toList(),
              onChanged: (String? newVal) {
                setState(() {
                  calcost(newVal);
                  _mySelection = newVal;
                });
              },
              value: _mySelection,
            ),
          ),
        ],
      ),
    );
  }

  Padding subTotalWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveFile.height10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "SubTotal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveFile.font20 / 1.12,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Rs. $subtotal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveFile.font20 / 1.12,
                ),
              ),
              Text(
                "Subtotal does not include shipping Charge",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveFile.font14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding checkoutWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveFile.height10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent,
                elevation: 5,
                padding: EdgeInsets.symmetric(vertical: ResponsiveFile.height10),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(ResponsiveFile.radius20 / 2),
                  side: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Checkout(price: '', fileurl: '', producturl: '', product: 'PRINTING',)));

              },
              child: AppText(
                  text: "Checkout",
                  color: Colors.black54,
                  size: ResponsiveFile.font19),
            ),
          ),
        ],
      ),
    );
  }
}
