
import 'package:diamond_chat/model/chat/forward_chat_user_response.dart';
import 'package:diamond_chat/model/chat/homepage_response.dart';
import 'package:diamond_chat/ui/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';

class ForwordUserListChat extends StatelessWidget {
  final ChatController _controller = Get.put(ChatController());
  int chatID;
   ForwordUserListChat({super.key,required this.chatID});
  List<ForwardChatUserResponse> groupmember = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Center(child:  Text("Diamond chat ")),
        actions: <Widget>[
          GetBuilder<ChatController>(
            builder: (value){
              // if (value.isLoading) {
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
              return   IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white,
                onPressed: () {
                  value.forwardMessage(chatID,value.items!.message.toString());
                  //value.refreshPage();
                },
              );
            },

          )

        ],),
        body: GetBuilder<ChatController>(
          init: _controller,
          builder: (value) {
            if (value.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return value.forwardChatUserResponse!=null?value.forwardChatUserResponse!.result!.isNotEmpty?RefreshIndicator(
              onRefresh: () async{
                await Future.delayed(Duration(seconds: 1));
                value.refreshPage();
                value.getUserDetails();
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: value.forwardChatUserResponse!.result!.length ,
                itemBuilder: (context, index) {
                  var data = value.forwardChatUserResponse!.result![index];
                  if (value.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return InkWell(
                    onTap: (){
                      value.selectItem(index);


                    },
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 53,
                        child: Stack(
                          children: [
                            data.profileImgPath!.isNotEmpty&&data.profileImgPath!=null?CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.blueGrey[200],
                              backgroundImage: NetworkImage(data.profileImgPath.toString()),
                              // child: Image.network(data.profileImgPath.toString(),
                              //   height: 30,
                              //   width: 30,
                              // ),
                            ):Container(),
                            value.selected[index]!?const Positioned(
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
                            ):Container()
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
            ):const Center(
              child: Text("No Data Found"),
            ):Container();
          },
        ));
  }
}
