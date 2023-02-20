
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageReceiver extends StatelessWidget {
  final String imagePath;
  int index = 1;
  ImageReceiver({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async{
              final imagePath = await File(
                  "/storage/emulated/0/Download/P&P ${"image$index"}.png")
                  .create();
            //  await imagePath.writeAsBytes(imagePath);
              Get.snackbar("Success", "Downloaded Successfully",
                  backgroundColor: Colors.white,
                  colorText: Colors.black);
              final status = await Permission.storage.request();

              if (status.isGranted) {
                final externalDir = await getExternalStorageDirectory();
                final id = await FlutterDownloader.enqueue(
                  url: "https:/${imagePath.path}",
                  savedDir: externalDir!.path,
                  fileName: "download",
                  showNotification: false,
                  openFileFromNotification: false,
                );
              } else {
                print("Permission deined");
              }
            },)
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imagePath),
        ),
      ),
    );
  }
}
