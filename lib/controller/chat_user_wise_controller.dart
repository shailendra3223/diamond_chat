import 'package:diamond_chat/model/chat/chat_data_user_wise.dart';
import 'package:diamond_chat/model/chat/delete_single_chat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../apimodule/api_service.dart';
import '../preferance/PrefsConst.dart';
import '../preferance/sharepreference_helper.dart';

class ChatUserWiseController extends GetxController{
  List<ChatListUserWiseModel> chatDataUser = [];
  List<DeleteSingleChatResponse> deleteChat = [];
  dynamic chatUserId;
  dynamic chatId;
  // int selectedIndex = -1;
  bool chatSelected = false;

  bool isLoading = true;
  @override
  void onInit() {
    // TODO: implement onInit
    chatUserId = Get.arguments;
    userChatWiseData(chatUserId);
    chatId = Get.arguments;
    update();
    print(chatUserId.toString()+'===========================');

    super.onInit();
  }

  void setLoading(bool value){
    isLoading = value;
    update();

  }
  void updateChatSelected(){
    for (var element in chatDataUser) {
      print('selected is '+element.isSelected.toString());
      if(element.isSelected!){
        chatSelected = true;
        break;
      }else{
        chatSelected = false;
      }
      update();
    }
  }

  Future<void> userChatWiseData(int chatUserId) async {
    try {
      setLoading(true);
      final ChatDataUserWise response = await ApiService.chatUserWise(chatUserId);
      chatDataUser = response.result!.chatListUserWiseModel!;
      update();
      setLoading(false);

    } catch (e) {
      print(e.toString());
      setLoading(false);

    }
  }



  /*TODO Delete Chat TODO*/
  Future<void> deleteChatData(String chatId) async {
    try {
      setLoading(true);
      final DeleteSingleChatResponse deleteSingleChatResponse = await ApiService.deleteChat(chatId);
      Get.snackbar("Delete Message Successfully", deleteSingleChatResponse.message.toString(),
          backgroundColor: Colors.white,
          colorText: Colors.black);
      userChatWiseData(chatUserId);
      update();
      setLoading(false);

    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      setLoading(false);
    }
  }


  void updateColor(List<ChatListUserWiseModel> chatData,Color color) {

    for(int i=0;i<chatData.length;i++){

    }

  }
  void selectItem(int index) {
    print(index);
    chatDataUser[index].isSelected =!chatDataUser[index].isSelected!;
    final List<bool> list = chatDataUser.map((e) => e.isSelected!).toList();
    print(list.map((e) => e.toString()));
    if(chatDataUser[index].isSelected!){
      chatId= chatDataUser[index].chatId;
    }


    updateChatSelected();

    update();
  }

  void singleMessageDelete(int index){
    final selectedList = chatDataUser.where((element) => element.isSelected!);
    final List<int> list = selectedList.map((e) => e.chatId!).toList();
    deleteChatData(list.join(','));
  }


}