import 'package:diamond_chat/model/chat/chat_data_user_wise.dart';
import 'package:diamond_chat/model/chat/homepage_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/chat_user_wise_controller.dart';
import 'forword_user_list_chat.dart';

class ChatScreen extends GetView<ChatUserWiseController> {
  int? i;
  dynamic? name;
  String? image;
  dynamic chatId;
  bool show = false;
  final ScrollController _scrollController = ScrollController();
  final ChatUserWiseController _controller = Get.put(ChatUserWiseController());
  TextEditingController editingController = TextEditingController();

  ChatScreen(
      {Key? key,  this.i,  this.name,  this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 150,
            backgroundImage: NetworkImage(
              image!,
            ),
          ),
        ),
        actions: <Widget>[
          GetBuilder<ChatUserWiseController>(
            builder: (value) {
              return value.chatSelected
                  ? IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.white,
                onPressed: () {
                  _controller.singleMessageDelete(chatId);
                },
              )
                  : Container();
            },
          ),
          GetBuilder<ChatUserWiseController>(
            builder: (value) {
        /*      if (value.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }*/
              return value.chatSelected
                  ? IconButton(
                      icon: const Icon(Icons.reply),
                      color: Colors.white,
                      onPressed: () {
                        Get.to(() => ForwordUserListChat(
                              chatID: value.chatId,
                            ));
                      },
                    )
                  : Container();
            },
          ),

        ],
      ),
      body: GetBuilder<ChatUserWiseController>(
        init: _controller,
        builder: (value) {
          // if (value.isLoading) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              value.refreshPage();
              value.userChatWiseData(value.chatUserId);
              // value.sendMessage(editingController.text);
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: WillPopScope(
                onWillPop: () {
                  if (show) {
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
                        itemCount: value.chatDataUser.length,
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
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
                                      // Card(
                                      //   margin: const EdgeInsets.all(3),
                                      //   shape: RoundedRectangleBorder(
                                      //       borderRadius:
                                      //           BorderRadius.circular(30)),
                                      //   child: Image.network(
                                      //     data.chatFilePath![0].toString(),
                                      //     width: 250,
                                      //     fit: BoxFit.fitHeight,
                                      //   ),
                                      // ),
                                      Card(
                                        color: Colors.white,
                                        elevation: 8,
                                        shadowColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14)),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 120.0,
                                                  left: 10.0,
                                                  top: 5.0,
                                                  bottom: 20.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    data.message.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16.0),
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
                                                      data.createdDate.toString(),
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors
                                                              .grey.shade600),
                                                    ),
                                                    // SizedBox(width: 5,),
                                                    //   Icon(Icons.done_all,size: 20.0,)
                                                  ],
                                                )),
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
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 60,
                            child: Card(
                                margin: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                elevation: 8,
                                child: TextFormField(
                                  controller: editingController,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  onChanged: (valueText){
                                    value.updateText(valueText);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Type a message ...",
                                    /*   prefixIcon: IconButton(
                                        icon:const Icon(Icons.emoji_emotions),
                                      onPressed: () {
                                          // Get.to(()=>HomePage());
                                      },
                                    ),*/
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.attach_file)),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.camera_alt))
                                      ],
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(15),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, right: 5, left: 2),
                            child: CircleAvatar(
                              radius: 25,
                              child: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  if (value.textFieldText.value.isEmpty) {
                                    Get.snackbar("Error", "Text field is empty");
                                  } else {
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                        const Duration(milliseconds: 200),
                                        curve: Curves.easeOut);
                                    value.sendMessage(editingController.text);
                                    editingController.clear();
                                  }

                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
