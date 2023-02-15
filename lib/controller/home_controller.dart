import 'dart:async';
import 'dart:io';

import 'package:diamond_chat/model/chat/delete_all_chat.dart';
import 'package:diamond_chat/model/chat/homepage_response.dart';
import 'package:diamond_chat/model/chat/forward_chat_user_response.dart';
import 'package:diamond_chat/preferance/PrefsConst.dart';
import 'package:diamond_chat/preferance/sharepreference_helper.dart';
import 'package:diamond_chat/ui/profile/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apimodule/api_service.dart';
import '../model/chat/delete_single_chat.dart';
import '../model/chat/save_chat_response.dart';
import 'chat_user_wise_controller.dart';

class HomeController extends GetxController {
  HomePageResponse? items;
  ForwardChatUserResponse? forwardChatUserResponse;

  List<CommonChatResponse> deleteAllChat = [];
  CommonChatResponse? commonChatResponse;
  bool isIconVisible = false;
  dynamic chatUserId;
  int selectedIndex = -1;
  bool isSelected = false;
  bool isLoading = true;
  List<bool> selected = [];
  File? image;
  bool chatSelected = false;
  dynamic chatId;
  Timer? timer;

  @override
  void onInit() {
    // TODO: implement onInit
    getUserDetails();

    getUserForwardChatList();
   // timer = Timer.periodic(const Duration(seconds: 10), (Timer t) =>    getNotificationCount());
    update();
    super.onInit();
  }

  void setProfileData() async {
    final path =
        await SharedPreferencesHelper().getString(PrefsConst.PROFILEPATH);
    if (path != null) {
      image = File(path);
      update();
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  void refreshPage() {
    update(["refresh"]);
  }

  /*TODO------------------- Chat user List -------------------TODO*/
  void getUserDetails() async {
    try {
      setLoading(true);
      var responseList = await ApiService.userList();
      if (responseList.result != null) {
        items = responseList;
        update();
        setLoading(false);
      }
      print(responseList);
    } catch (e) {
      setLoading(false);
    }
  }


  /*TODO------------------- GetNotificationCount -------------------TODO*/
  void getNotificationCount() async {
    try {
      setLoading(true);
      var responseList = await ApiService.getNotification();
      if (responseList.result != null) {
        commonChatResponse = responseList;
        update();
        setLoading(false);
      }
      print(responseList);
    } catch (e) {
      setLoading(false);
    }
  }


  /*TODO------------------- Forward Chat user List -------------------TODO*/
  void getUserForwardChatList() async {
    try {
      setLoading(true);
      var response = await ApiService.getForwardCharUserList();
      if (response.result != null) {
        forwardChatUserResponse = response;
        for (int i = 0; i < forwardChatUserResponse!.result!.length; i++) {
          selected.add(false);
          update();
        }
        update();
        setLoading(false);
      }
      print(response);
    } catch (e) {
      setLoading(false);
    }
  }

/*TODO------------------- forwardMessage -------------------TODO*/
  Future<void> forwardMessageList(int chatId, String userChatId) async {
    try {
      setLoading(true);
      final CommonChatResponse response =
          await ApiService.mobileForwardChat(chatId, userChatId);
      print(response.message);
      update();
      setLoading(false);
    } catch (e) {
      print(e.toString());
      setLoading(false);
      // Handle exception
    }
  }

  /*TODO DeleteAll Chat TODO */
  Future<void> deleteAllChatData(String chatUserId) async {
    try {
      setLoading(true);
      final DeleteAllChatResponse deleteAllChatResponse =
          await ApiService.deleteAllChat(chatUserId);
      Get.snackbar("Delete Message Successfully",
          deleteAllChatResponse.message.toString(),
          backgroundColor: Colors.white, colorText: Colors.black);
      print(deleteAllChatResponse.toString());
      getUserDetails();
      update();
      setLoading(false);
    } catch (e) {
      print(e.toString());
      Get.snackbar("Failed To Delete!", "No More Message",
          backgroundColor: Colors.white, colorText: Colors.black);
      setLoading(false);
    }
  }

  void updateChatSelected() {
    for (var element in items!.result!) {
      if (kDebugMode) {
        print('selected is ${element.isSelected}');
      }
      if (element.isSelected!) {
        chatSelected = true;
        break;
      } else {
        chatSelected = false;
      }
      update();
    }
  }

  void selectItem(int index) {
    // forwardChatUserResponse!.result![index].isSelected =!forwardChatUserResponse!.result![index].isSelected!;
    selected[index] = !selected[index];
    update();
  }

  void selectUserListItem(int index) {
    items!.result![index].isSelected = !items!.result![index].isSelected!;
    if (items!.result![index].isSelected!) {
      chatId = 0;
    }

    updateChatSelected();
  }

  void forwardMessage(int chatID) {
    for (int i = 0; i < forwardChatUserResponse!.result!.length; i++) {
      for (int i = 0; i < selected.length; i++) {
        if (selected[i]) {
          print(selected[i]);
          print(forwardChatUserResponse!.result![i].chatUserID);
          forwardMessageList(chatID,
              forwardChatUserResponse!.result![i].chatUserID.toString());
          selected.removeAt(i);
          selected.add(false);
        } else {
          print("inside else");
        }
      }
    }
    // final selectedList = forwardChatUserResponse!.result!.where((element) => element.isSelected!);
    // final List<int> list = selectedList.map((e) => e.chatUserID!).toList();
    // // saveChat(chatID, list.join(','),message);
    // forwardMessageList(chatID,list.join(','));
    // for(int i=0;i<forwardChatUserResponse!.result!.length;i++){
    //   selected.removeAt(i);
    //   selected.add(false);
    // }
    // Get.back();
  }

  void deleteAll(int iondex) {
    final selectedDeleteList =
        items!.result!.where((element) => element.isSelected!);
    final List<int> deleteList =
        selectedDeleteList.map((e) => e.chatUserId!).toList();
    deleteAllChatData(deleteList.join(','));
  }
}
