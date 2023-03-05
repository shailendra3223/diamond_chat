import 'package:diamond_chat/model/chat/forward_chat_user_response.dart';
import 'package:diamond_chat/ui/chat/chat_screen.dart';
import 'package:diamond_chat/ui/chat/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';

class ForwordUserListChat extends GetView {
  final HomeController _controller = Get.put(HomeController());
  int chatID;

  ForwordUserListChat({super.key, required this.chatID});


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _controller.clearList();
        return true;
      },
      child: GetBuilder<HomeController>(
          init: _controller,
          builder: (value) {
            return Scaffold(
                appBar: AppBar(
                  title: const Center(child: Text("Forward Message ")),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      onPressed: () {
                        value.forwardMessage(chatID);
                        Get.offAll(() => HomeScreen());
                        //value.refreshPage();
                      },
                    )

                  ],),
                body:
                (value.isLoading) ?
                const Center(
                  child: CircularProgressIndicator(),
                ) :

                value.forwardChatUserResponse != null ? value
                    .forwardChatUserResponse!.result!.isNotEmpty
                    ? RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 1));
                    value.refreshPage();
                    value.getUserForwardChatList(true);
                    value.getUserDetails(true);
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.forwardChatUserResponse!.result!.length,
                    itemBuilder: (context, index) {
                      var data = value.forwardChatUserResponse!.result![index];
                      if (value.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return InkWell(
                        onTap: () {
                          value.selectItem(index);
                        },
                        child: ListTile(
                          leading: SizedBox(
                            width: 50,
                            height: 53,
                            child: Stack(
                              children: [
                                data.profileImgPath!.isNotEmpty &&
                                    data.profileImgPath != null ? CircleAvatar(
                                  radius: 23,
                                  backgroundColor: Colors.blueGrey[200],
                                  backgroundImage: NetworkImage(
                                      data.profileImgPath.toString()),
                                  // child: Image.network(data.profileImgPath.toString(),
                                  //   height: 30,
                                  //   width: 30,
                                  // ),
                                ) : Container(),
                                data.isSelected! ? const Positioned(
                                  bottom: 4,
                                  right: 5,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.teal,
                                    radius: 11,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                )
                                    : Container()
                              ],
                            ),
                          ),
                          title: Text(
                            data.fullName.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : const Center(
                  child: Text("No Data Found"),
                ) : SizedBox()

            );
          }
      ),
    );
  }
}
