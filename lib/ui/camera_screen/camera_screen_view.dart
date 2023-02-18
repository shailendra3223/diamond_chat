import 'dart:io';

import 'package:diamond_chat/controller/chat_user_wise_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraViewPage extends GetView<ChatUserWiseController> {
  ChatUserWiseController chatUserWiseController = Get.find();
  
   CameraViewPage({Key? key,  this.path}) : super(key: key);
  final String? path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
       /* actions: [
          IconButton(
              icon: const Icon(
                Icons.crop_rotate,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.title,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.edit,
                size: 27,
              ),
              onPressed: () {}),
        ],*/
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                File(path!),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width/1.18,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      maxLines: 6,
                      minLines: 1,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add Caption....",
                          prefixIcon: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.white,
                            size: 27,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                    ),
                  ),
                  ),
                  InkWell(
                    onTap: (){
                      if(path!.isNotEmpty){
                        chatUserWiseController.saveChat(chatUserWiseController.chatUserId, "",file: File(path!));
                        Get.back();
                        Get.back();

                      }

                    },
                    child: CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.tealAccent[700],
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
