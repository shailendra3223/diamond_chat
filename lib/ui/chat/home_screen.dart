import 'dart:io';
import 'package:diamond_chat/controller/home_controller.dart';
import 'package:diamond_chat/ui/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../profile/profile.dart';

class HomeScreen extends GetView<ChatController> {
  final ChatController _controller = Get.put(ChatController());
  dynamic chatUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 8,
            leading: GetBuilder<ChatController>(
              init: _controller,
              builder: (value) {
                return IconButton(
                    color: const Color(0xff012132),
                    onPressed: () async {
                      await Get.to(() => ProfilePage());
                      value.setProfileData();
                    },
                    icon: value.image != null
                        ?
                    //CircleAvatar(backgroundImage:NetworkImage(value.items!.result![0].profileImgPath.toString()))
                    CircleAvatar(backgroundImage: FileImage(value.image!))
                        : const Icon(
                            Icons.account_circle_rounded,
                            size: 40,
                          ));
              },
            ),
            title: const Text(
              'Diamond Chat',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              GetBuilder<ChatController>(builder: (value) {
                return value.chatSelected
                    ?IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.white,
                        onPressed: () {
                          value.deleteAll(chatUserId);
                          _controller.update();
                        },
                      )
                    : Container();
              }),
            ]),
        body: GetBuilder<ChatController>(
          init: _controller,
          builder: (value) {
            if (value.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          return value.items!=null?value.items!.result!.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.items!.result!.length,
                  itemBuilder: (context, index) {
                    var data = value.items!.result![index];
                    chatUserId = data.chatUserId;
                    return InkWell(
                      onTap: () => Get.to(() => ChatScreen(
                            i: index,
                            name: data.fullName.toString(),
                            image: data.profileImgPath.toString(),

                          ),arguments: data.chatUserId),
                      child: GestureDetector(
                        onLongPress: () {
                          value.selectUserListItem(index);
                          controller.update();
                        },
                        child: Container(
                          color:data.isSelected!?Colors.grey:Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    data.profileImgPath!.toString()),
                                // child: Padding(
                                //   padding: const EdgeInsets.all(10.0),
                                //   child: Image.network(
                                //       data.profileImgPath!.toString(),
                                //       fit: BoxFit.fitWidth),
                                // )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  data.fullName.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              data.createdDate.toString(),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            data.message.toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),


                                      ],
                                    )),
                              ),

                            ],
                          ),

                        ),
                      ),
                    );
                  },
                )
                : const Center(
                    child: Text("No Data Found"),
                  ):Container();
          },
        ));
  }
}
