import 'dart:io';

import 'package:diamond_chat/controller/chat_controller.dart';
import 'package:diamond_chat/model/user_model.dart';
import 'package:diamond_chat/ui/chat/chat_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../preferance/PrefsConst.dart';
import '../../preferance/pref.dart';
import '../profile/profile.dart';

class userChatListPage extends StatelessWidget {
  final ChatController _controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 8,
          leading: IconButton(
                  color: const Color(0xff012132),
                  onPressed: ()async {
                    await Get.to(() => ProfilePage());
                    _controller.setProfileData();
                  },
                  icon: _controller.image != null
                      ? CircleAvatar(backgroundImage: FileImage(_controller.image!))
                      : const Icon(
                    Icons.account_circle_rounded,
                    size: 40,
                  )),
          title: const Text(
            'Inbox',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: GetBuilder<ChatController>(
          init: _controller,
          builder: (value) {
            if (value.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: value.items[0].result!.length,
              itemBuilder: (context, index) {
                var data = value.items[0].result![index];
                return InkWell(
                  onTap: () => Get.to(() => ChatScreen()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: CircleAvatar(
                              radius: 36,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.network(
                                    data.profileImgPath!.toString(),
                                    fit: BoxFit.contain),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.65,
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
                                            fontWeight: FontWeight.bold,
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
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
