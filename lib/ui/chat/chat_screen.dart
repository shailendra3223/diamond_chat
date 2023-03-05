import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:diamond_chat/ui/camera_screen/show_image_file.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../controller/chat_user_wise_controller.dart';
import 'forword_user_list_chat.dart';

class ChatScreen extends GetView<ChatUserWiseController> {
  int? i;
  dynamic? name;
  String? image;
  dynamic chatId;
  final ChatUserWiseController _controller = Get.put(ChatUserWiseController());
  TextEditingController editingController = TextEditingController();
  bool show = false;
  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final isVisible = true.obs;
  ChatScreen({Key? key, this.i, this.name, this.image}) : super(key: key);


// ...


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatUserWiseController>(
        init: _controller,
        builder: (value) {
          /*   if(value.chatDataUser.isNotEmpty){
            _scrollController.animateTo(
                _scrollController
                    .position.maxScrollExtent,
                duration: const Duration(
                    milliseconds: 300),
                curve: Curves.easeOut);
          }*/
          return Scaffold(
              backgroundColor: Colors.indigo[50],
              appBar: AppBar(
                leadingWidth: 70,
                title: Text(name),
                /*leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 150,
                backgroundImage: NetworkImage(
                  image!,
                ),
              ),
            ),*/
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(image!),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  if (value.chatSelected)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () {
                        _controller.singleMessageDelete(chatId);
                      },
                    ),
                  if (value.chatSelected)
                    IconButton(
                      icon: const Icon(Icons.reply),
                      color: Colors.white,
                      onPressed: () {
                        Get.to(() => ForwordUserListChat(
                              chatID: value.chatId,
                            ));
                      },
                    )
                ],
              ),
              body:
                  /*     if (value.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }*/
                  RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  value.refreshPage();
                  value.userChatWiseData(value.chatUserId);
                  // value.sendMessage(editingController.text);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: WillPopScope(
                    onWillPop: () {
                      if (show) {
                        show = false;
                        _controller.update();
                      } else {
                        Navigator.pop(context);
                      }
                      return Future.value(false);
                    },
                    child: Column(
                      children: [
                        Expanded(
                          // height: MediaQuery.of(context).size.height - 140,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: value.chatDataUser.length + 1,
                            controller: value.scrollController,
                            itemBuilder: (BuildContext context, int index) {
                              print("this was image=================");
                              if (index == value.chatDataUser.length) {
                                return Container(
                                  height: 70,
                                );
                              }
                              // print(value.selectedIndex);
                              var data = value.chatDataUser[index];
                              chatId = data.chatId;
                              /*  String dateString = data.createdDate.toString();
                              DateFormat format =  DateFormat("yyyy/MM/dd h:mma");
                              DateTime date = format.parse(dateString);
                              DateFormat timeFormat =  DateFormat("h:mm a");
                              String timeString = timeFormat.format(date);*/

                              String url = data.chatFilePath.toString();
                              String filenamePath = url.substring(url.lastIndexOf("/") + 1).replaceAll("]", "");
                              print(name); // Output: PolicyCopy.pdf
                              return GestureDetector(
                                onLongPress: () {
                                  if (!value.chatSelected || data.isSelected!) {
                                    value.selectItem(index);
                                  }

                                  // controller.update();
                                },
                                child: Align(
                                    alignment: data.isSender!
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      color: data.isSelected!
                                          ? Colors.grey
                                          : Colors.transparent,
                                      child: Column(
                                        children: [
                                          data.chatFilePath!.isNotEmpty ? Column(
                                                  children: data.chatFilePath!.map((e) => Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 15.0, vertical: 5),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: MediaQuery.of(context).size.height /3.1,
                                                                width: MediaQuery.of(context).size.width /2.3,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                                  // color: Colors.cyan.shade50
                                                                ),
                                                                child: Card(
                                                                  margin:
                                                                      const EdgeInsets.all(5.0),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(15)),
                                                                  child: e.toString().toLowerCase().endsWith('.jpg') ||
                                                                          e.toString().toLowerCase().endsWith('.jpeg') ||
                                                                          e.toString().toLowerCase().endsWith('.png')
                                                                      ? ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.to(() => ImageReceiver(imagePath: e.toString()));
                                                                            },
                                                                            child:
                                                                                Image.network(
                                                                              e.toString(),
                                                                              fit: BoxFit.fitHeight,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : InkWell(
                                                                    onTap: ()async{
                                                                      String filePath = "http://docs.google.com/viewer?url=$e";
                                                                      Uri uri = Uri.parse(filePath);
                                                                      print(uri.toString());
                                                                      // if (!await launchUrl(uri)) {
                                                                      // throw Exception('Could not launch $uri');
                                                                      // }
                                                                      Get.to(()=>ImageReceiver(filepath:uri.toString(),index: index,fileName: filenamePath,));
                                                                      print(e.toString());
                                                                    },
                                                                        child: Column(
                                                                          children: [
                                                                            ClipRRect(
                                                                                borderRadius:
                                                                                    BorderRadius.circular(10.0),
                                                                                child: e.toString().toLowerCase().endsWith('.pdf')
                                                                                    ? Padding(padding: const EdgeInsets.all(30.0),
                                                                                  child: Image.asset("assets/img/pdf.png",
                                                                                  fit: BoxFit.contain,
                                                                                  ),
                                                                                      )
                                                                                    :
                                                                                    /*e.toString().toLowerCase().endsWith('.csv')?Padding(
                                                                                padding: const EdgeInsets.all(30.0),
                                                                                child: Image.asset(
                                                                                  "assets/img/csv.png",
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                                  ):*/
                                                                                    Padding(
                                                                                        padding: const EdgeInsets.all(30.0),
                                                                                        child: Image.asset(
                                                                                          "assets/img/doc.png",
                                                                                          fit: BoxFit.contain,
                                                                                        ),
                                                                                      ),
                                                                              ),
                                                                            // Visibility(
                                                                            //   visible: isVisible.value,
                                                                            //   child: IconButton(
                                                                            //     icon: Icon(Icons.download),
                                                                            //     onPressed: () {
                                                                            //       // hide the icon when it is clicked
                                                                            //       isVisible.value = false;
                                                                            //       // add your download logic here
                                                                            //     },
                                                                            //   ),
                                                                            //
                                                                            // ),
                                                                            Text(filenamePath,style: TextStyle(color:Colors.cyan.shade600,),)
                                                                          ],
                                                                        ),
                                                                      ),
                                                                ),
                                                              ),



                                                              Text(
                                                                  data.message.toString())
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                      .toList())
                                              :
                                          Card(

                                            // decoration: const BoxDecoration(
                                            //   color: Colors.white,
                                            //   borderRadius: BorderRadius.only(topLeft: Radius.circular(12),
                                            //         bottomLeft: Radius.circular(12),
                                            //     bottomRight: Radius.circular(12),
                                            //   ),
                                            // ),
                                            // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),

                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),

                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(right: 80.0, left: 10.0, top: 3.0, bottom: 14.0),
                                                  child: Column(
                                                    children: [

                                                      Text(data.message.toString(), style: const TextStyle(fontSize: 16.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Visibility(
                                                //   visible: data.isSender!,
                                                Positioned(bottom: 2, right: 6,
                                                    child: Row(
                                                      children: [
                                                        Text(data.createdDate.toString(), style: TextStyle(fontSize: 10.0,
                                                            color: Colors.grey.shade600),),
                                                        // SizedBox(width: 5,),
                                                        //   Icon(Icons.done_all,size: 20.0,)
                                                      ],
                                                    )
                                                ),
                                                //   )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    // : Text(""),
                                    ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 65,
                                    child: Card(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 5, bottom: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Form(
                                        key: _formKey,
                                        child: Center(
                                          child: TextFormField(
                                            controller: editingController,
                                            focusNode: focusNode,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 5,
                                            minLines: 1,
                                            // onChanged: (valueText) {
                                            //   value.updateText(valueText);
                                            // },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return value.toString();
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              errorStyle:
                                                  const TextStyle(height: 0.02),
                                              border: InputBorder.none,
                                              hintText: "Type a message ...",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade800),
                                              suffixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.attach_file),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          context: context,
                                                          builder: (builder) =>
                                                              bottomSheet(
                                                                  context));
                                                    },
                                                  ),
                                                  /*   IconButton(
                                                    icon: const Icon(
                                                        Icons.camera_alt),
                                                    onPressed: () {
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (builder) =>
                                                      //             CameraApp()));
                                                    },
                                                  ),*/
                                                ],
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 8,
                                      right: 2,
                                      left: 2,
                                    ),
                                    child: CircleAvatar(
                                      radius: 25,
                                      // backgroundColor: Color(0xFF128C7E),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            value.scrollController.animateTo(
                                                value.scrollController.position
                                                    .maxScrollExtent,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeOut);

                                            value.sendMessage(
                                                editingController.text);
                                            editingController.clear();
                                          } else {
                                            // Show the Toast message
                                            Get.snackbar("Message !!",
                                                "Please enter a message",
                                                backgroundColor: Colors.white,
                                                colorText: Colors.black);
                                          }
                                          // if (value
                                          //     .textFieldText.value.isEmpty) {
                                          //   Get.snackbar("Error",
                                          //       "Text field is empty");
                                          // } else {
                                          //
                                          // }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  Widget bottomSheet(
    context,
  ) {
    return GetBuilder<ChatUserWiseController>(
        init: _controller,
        builder: (value) {
          return SizedBox(
            height: 160,
            width: 400,
            child: Card(
              margin: const EdgeInsets.all(18.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconCreation(
                            Icons.insert_drive_file, Colors.indigo, "Document",
                            () async {
                          value.imgFromPdf();
                          Navigator.of(context).pop();
                        }),
                        const SizedBox(
                          width: 40,
                        ),
                        iconCreation(Icons.camera_alt, Colors.pink, "Camera",
                            () async {
                          value.imgFromCamera();
                          Navigator.of(context).pop();
                        }),
                        const SizedBox(
                          width: 40,
                        ),
                        iconCreation(
                            Icons.insert_photo, Colors.purple, "Gallery", () {
                          value.imgFromGallery();
                          Navigator.of(context).pop();
                          // Navigator.push(context,MaterialPageRoute(builder: (builder)=> CameraViewPage(path: value.image!.path,)));
                          //
                        }),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     iconCreation(Icons.headset, Colors.orange, "Audio"),
                    //     const SizedBox(
                    //       width: 40,
                    //     ),
                    //     iconCreation(Icons.location_pin, Colors.teal, "Location"),
                    //     const SizedBox(
                    //       width: 40,
                    //     ),
                    //     iconCreation(Icons.person, Colors.blue, "Contact"),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget iconCreation(
      IconData icons, Color color, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}
