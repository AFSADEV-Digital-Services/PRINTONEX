import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
class PdfApi {
  static Future<File> generateCenteredText(String text, String url1, String url2) async {
    final pdf = Document();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final netImage1 = await networkImage(url1);
    final netImage2 = await networkImage(url2);
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => <Widget>[
      //   UrlLink(
      //   destination: 'https://afsadev.in/Download/PrintoNexOnline.apk',
      //   child: Text(
      //     'PRINTONEX ONLINE',
      //     style: TextStyle(
      //       decoration: TextDecoration.underline,
      //       color: PdfColors.blue,
      //     ),
      //   ),
      // ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Center(
            child: Container(
                alignment: Alignment.center,
                height: Get.height/4,
                width: Get.width/1.5,

                child: Center(
                  child: Image(netImage2),
                )
            ),
          ),
          SizedBox(height: 5,),
          Center(
            child: Container(
                alignment: Alignment.center,

                width: Get.width/1.5,
                height: Get.height/4,
                child: Center(
                  child:  Image(netImage1),
                )
            ),
          ),

        ],
        footer: (context) {
          final text = 'Page ${context.pageNumber} of ${context.pagesCount}';

          return Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: Text(
              "Printed At: PRINTONEX ONLINE",
              style: TextStyle(color: PdfColors.black, fontSize: 5),
            ),
          );


        },
      ),
    );

    return saveDocument(name: 'aadharPdf_Printonex_$fileName.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    print(file.toString());



    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}