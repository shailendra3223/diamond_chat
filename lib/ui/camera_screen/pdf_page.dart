import 'package:diamond_chat/controller/chat_user_wise_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PdfViewerPage extends GetView<ChatUserWiseController> {
  ChatUserWiseController controller = Get.find();
  String? path;


  PdfViewerPage(this.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 1.0),
        itemCount: controller.chatDataUser.length,
        itemBuilder: (context, index) {
          return
        },
      ),
    );
  }
}
