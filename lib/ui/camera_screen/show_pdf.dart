
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
class showPdf extends StatelessWidget {


  // final File? file;
  final String? filepath;




  // downLoadPdf(String filename) async{
  //
  //   final directory = await getExternalStorageDirectory();
  //   final downloadDirectory = Directory('${directory?.path}/Download/$filename');
  //   downloadDirectory.createSync(recursive: true);
  //
  //   Get.snackbar("Success", "Downloaded Successfully",
  //       backgroundColor: Colors.white,
  //       colorText: Colors.black);
  //   final status = await Permission.storage.request();
  //   print("sfedafsdfsdfdsfd "+downloadDirectory.toString());
  //
  // }

  Future<bool> downloadFile(String url, String fileName) async {
    try {
      if (await _requestPermission(Permission.storage)) {
        Directory? directory;
        directory = await getApplicationDocumentsDirectory();
        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/PDF_Download";
        directory = Directory(newPath);

        File saveFile = File(directory.path + "/$fileName");
        Get.snackbar("Success", "Downloaded Successfully",
            backgroundColor: Colors.white,
            colorText: Colors.black);
        if (kDebugMode) {
          print('dsaaaaaaaaaa '+saveFile.path);
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          await Dio().download(
            url,
            saveFile.path,


          );

        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }



  pdfFileView() async {
    String filePath = "http://docs.google.com/viewer?url=$filepath";
    Uri uri = Uri.parse(filePath);
    print(uri.toString());
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }


  const showPdf({super.key, this.filepath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Download"),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.download),
          //     onPressed: () async{
          //         // downloadFile(filepath.toString(),'');
          //         downloadFile(filepath.toString(),"sample.pdf");
          //
          //     },)
        //  ],
        ),
        body: Center(
            child: WebView(
              initialUrl: filepath,
            )

        )
    );
  }
}
