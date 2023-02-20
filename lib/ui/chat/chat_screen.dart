import 'dart:io';

import 'package:diamond_chat/ui/camera_screen/camera_screen_view.dart';
import 'package:diamond_chat/ui/camera_screen/show_image_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/chat_user_wise_controller.dart';
import 'forword_user_list_chat.dart';

class ChatScreen extends GetView<ChatUserWiseController> {
  int? i;
  dynamic? name;
  String? image;
  dynamic chatId;
  final ChatUserWiseController _controller = Get.put(ChatUserWiseController());
  TextEditingController editingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool show = false;
  FocusNode focusNode = FocusNode();


  ChatScreen({Key? key, this.i, this.name, this.image}) : super(key: key);

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
                      const SizedBox(width: 4,),
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
                            itemCount: value.chatDataUser.length +1,
                            controller: _scrollController,
                            itemBuilder: (BuildContext context, int index) {
                              print("this was image=================");
                              if(index==value.chatDataUser.length){
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
                              return GestureDetector(
                                onLongPress: () {
                                  value.selectItem(index);
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
                                      data.chatFilePath!.isNotEmpty?
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height/2.3,
                                          width: MediaQuery.of(context).size.width/1.8,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                           // color: Colors.cyan.shade50
                                          ),
                                          child: Card(
                                            margin: const EdgeInsets.all(5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                            ),
                                            child:
                                           /* Column(
                                              children: [
                                                if (data.chatFilePath != null)
                                                  ...data.chatFilePath!.map(
                                                        (url) {
                                                      if (url.toLowerCase().endsWith('.pdf')) {
                                                        // display the PDF file
                                                        return PDFView(
                                                          filePath: url,
                                                        );
                                                      } else if (url.toLowerCase().endsWith('.jpg') ||
                                                          url.toLowerCase().endsWith('.jpeg') ||
                                                          url.toLowerCase().endsWith('.png')) {
                                                        // display the image file
                                                        return Image.network(
                                                         url,
                                                        );
                                                      }
                                                      return Container();
                                                    },
                                                  ),
                                              ],
                                            )*/
                                            data.chatFilePath!.contains('.pdf''csv''.doc')?
                                            ListView.separated(
                                              separatorBuilder: (context, index) => Divider(height: 1.0),
                                              itemCount: data.chatFilePath!.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  leading: Icon(Icons.insert_drive_file),
                                                  title: Text(
                                                    (index+1) as String,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Text(
                                                    '13.5 MB',
                                                    style: TextStyle(fontSize: 12.0),
                                                  ),
                                                  trailing: PopupMenuButton(
                                                    itemBuilder: (context) {
                                                      return [
                                                        PopupMenuItem(
                                                          child: Text('Open'),
                                                          value: 'open',
                                                        ),
                                                        PopupMenuItem(
                                                          child: Text('Download'),
                                                          value: 'Download',
                                                        ),
                                                      ];
                                                    },
                                               /*     onSelected: (value) {
                                                      if (value == 'open') {
                                                        // Handle share option
                                                        print('open document: ${_documentList[index]}');
                                                      } else if (value == 'download') {
                                                        // Handle delete option
                                                        setState(() {
                                                          _documentList.removeAt(index);
                                                        });
                                                        print('download document: ${_documentList[index]}');
                                                      }
                                                    },*/
                                                  ),
                                                  onTap: () {
                                                    // Handle document tap here
                                                   // print('Document tapped: ${_documentList[index]}');
                                                  },
                                                );
                                              },
                                            ): ClipRRect(
                                              borderRadius:BorderRadius.circular(10.0) ,
                                              child: InkWell(
                                                onTap: (){
                                                  Get.to(()=>ImageReceiver(imagePath:  data.chatFilePath![0].toString()));
                                                },
                                                child: Image.network(
                                                  data.chatFilePath![0].toString(),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),

                                        ),
                                      )
                                          :ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  45,
                                            ),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  bottomLeft:
                                                      Radius.circular(18),
                                                  bottomRight:
                                                      Radius.circular(12),
                                                ),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 80.0,
                                                            left: 10.0,
                                                            top: 5.0,
                                                            bottom: 20.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          data.message
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      16.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Visibility(
                                                  //   visible: data.isSender!,
                                                  Positioned(
                                                      bottom: 1,
                                                      right: 10,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            data.createdDate
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 10.0,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600),
                                                          ),
                                                          // SizedBox(width: 5,),
                                                          //   Icon(Icons.done_all,size: 20.0,)
                                                        ],
                                                      )),
                                                  //   )
                                                ],
                                              ),
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
                          child: Container(
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      child: Card(
                                        margin: const EdgeInsets.only(
                                            left: 2, right: 2, bottom: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: TextFormField(
                                          controller: editingController,
                                          focusNode: focusNode,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 5,
                                          minLines: 1,
                                          onChanged: (valueText) {
                                            value.updateText(valueText);
                                          },
                                          /*  onChanged: (value) {
                                            if (value.length > 0) {
                                              setState(() {
                                                sendButton = true;
                                              });
                                            } else {
                                              setState(() {
                                                sendButton = false;
                                              });
                                            }
                                          },*/
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Type a message",
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.attach_file),
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (builder) =>
                                                            bottomSheet(context));
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
                                                const EdgeInsets.all(5),
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
                                            if (value
                                                .textFieldText.value.isEmpty) {
                                              Get.snackbar("Error",
                                                  "Text field is empty");
                                            } else {
                                              _scrollController.animateTo(
                                                  _scrollController
                                                      .position.maxScrollExtent,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeOut);
                                              value.sendMessage(
                                                  editingController.text);
                                              editingController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  Widget bottomSheet(context,) {
    return GetBuilder<ChatUserWiseController>(
      init: _controller,
      builder: (value) {
        return SizedBox(
          height:160,
          width: 400,
          child: Card(
            margin: const EdgeInsets.all(18.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconCreation(
                          Icons.insert_drive_file, Colors.indigo, "Document",()async{
                        value.imgFromPdf();
                      }),
                      const SizedBox(
                        width: 40,
                      ),
                      iconCreation(Icons.camera_alt, Colors.pink, "Camera",()async{
                        value.imgFromCamera();
                        Navigator.of(context).pop();
                      }),
                      const SizedBox(
                        width: 40,
                      ),
                      iconCreation(Icons.insert_photo, Colors.purple, "Gallery",(){
                        value.imgFromGallery();

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
      }
    );
  }

  Widget iconCreation(IconData icons, Color color, String text,Function() onTap) {
    return InkWell(
      onTap:  onTap,
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
