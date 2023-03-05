
import 'dart:io';
import 'dart:typed_data';
import 'package:diamond_chat/controller/chat_user_wise_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';

class ImageReceiver extends GetView<ChatUserWiseController> {
  ChatUserWiseController controller = Get.find();
  final String? imagePath;
  final String? fileName;

  // final File? file;
  final String? filepath;
  int? index;


  ImageReceiver({super.key,  this.imagePath, this.filepath,this.fileName,this.index});

  _save() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      var response = await Dio().get(imagePath!,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "Image"
      );
      Get.snackbar("Success", "Downloaded Successfully",
          backgroundColor: Colors.white,
          colorText: Colors.black);
      if (kDebugMode) {
        print(result);
      }
    }
  }



  void downLoadPdf() async {
   /* String extension = "pdf";
    switch(extension){
      case "pdf":
        extension = "Pdf";
        break;
      case "Docx":
        extension = "docx";
    }*/
    Dio dio = Dio();

    String savePath = "/storage/emulated/0/Download/${fileName}"; // Replace with your desired file path

    try {
      var response = await dio.get(
        filepath.toString(),
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      File file = File(savePath);
      await file.writeAsBytes(response.data, flush: true);
      print("PDF file downloaded successfully!");
    } catch (e) {
      print("Error downloading PDF file: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async{
              if(imagePath!=null){
                _save();
              }else{
                // downloadFile(filepath.toString(),'');
                downLoadPdf();
              }


            },)
        ],
      ),
      body: Center(
        child:
       imagePath!= null? InteractiveViewer(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imagePath!),
                fit: BoxFit.contain,
              ),
            ),
          )
        ):WebView(
         allowsInlineMediaPlayback: true,
         javascriptMode: JavascriptMode.unrestricted,
         initialUrl: filepath,
       )

      )
    );
  }
}
