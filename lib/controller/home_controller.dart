import 'dart:io';

import 'package:diamond_chat/model/chat/delete_all_chat.dart';
import 'package:diamond_chat/model/chat/homepage_response.dart';
import 'package:diamond_chat/model/chat/forward_chat_user_response.dart';
import 'package:diamond_chat/preferance/PrefsConst.dart';
import 'package:diamond_chat/preferance/sharepreference_helper.dart';
import 'package:diamond_chat/ui/profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apimodule/api_service.dart';
import '../model/chat/delete_single_chat.dart';
import '../model/chat/save_chat_response.dart';
import 'chat_user_wise_controller.dart';



class ChatController extends GetxController{
  HomePage? items;
  UserProfile? userprofile;
  ForwardChatUserResponse? forwardChatUserResponse ;
  List<DeleteSingleChatResponse> deleteAllChat =[];

  List<SaveChatResponse> saveChatResponse = [];
  bool isIconVisible = false;
  dynamic chatUserId;
  int selectedIndex = -1;
  ChatUserWiseController chatUserWiseController = new ChatUserWiseController();
  bool isLoading = true;
  File? image;
  bool chatSelected = false;
  dynamic chatId;

  @override
  void onInit() {
    // TODO: implement onInit
    getUserDetails();

    getProfile();
    getUserForwardChatList();
    update();
    super.onInit();

  }

  void setProfileData() async {

    final path = await SharedPreferencesHelper().getString(PrefsConst.PROFILEPATH);
    if(path!=null){
      image = File(path);
      getProfile();

      update();
    }

  }
  void setLoading(bool value){
    isLoading = value;
    update();

  }

  void refreshPage() {
    update(["refresh"]);
  }


  /*TODO------------------- Get Profile -------------------TODO*/
  void getProfile() async{
    try{
      setLoading(true);
      var profileList = await ApiService.geUserProfile();
      if(profileList.result!=null){
        userprofile=profileList;
        update();
        setLoading(false);
      }
      print(profileList);
    }catch(e){
      setLoading(false);
    }
  }

  /*TODO------------------- Chat user List -------------------TODO*/
  void getUserDetails() async{
    try{
      setLoading(true);
      var responseList = await ApiService.userList();
      if(responseList.result!=null){
        items=responseList;
        update();
        setLoading(false);
      }
      print(responseList);
    }catch(e){
      setLoading(false);
    }
  }

  /*TODO------------------- Forward Chat user List -------------------TODO*/
  void getUserForwardChatList() async{
    try{
      setLoading(true);
      var response = await ApiService.getForwardCharUserList();
      if(response.result!=null){
        forwardChatUserResponse=response;
        update();
        setLoading(false);
      }
      print(response);
    }catch(e){
      setLoading(false);
    }
  }

/*TODO------------------- Save Chat -------------------TODO*/
  Future<void> saveChat(int chatId,String userChatId,String message) async {
    try {
      setLoading(true);
      final SaveChatResponse response = await ApiService.saveChatData(File(image!.absolute.path),chatId,userChatId,message);
      print(response.message);
      update();
      setLoading(false);
    } catch (e) {
      print(e.toString());
      setLoading(false);

      // Handle exception
    }
  }

/*TODO------------------- forwardMessage -------------------TODO*/
  Future<void> forwardMessageList(int chatId,String userChatId) async {
    try {
      setLoading(true);
      final DeleteSingleChatResponse response = await ApiService.mobileForwardChat(chatId,userChatId);
      print(response.message);

      Get.back();
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
      final DeleteAllChatResponse deleteAllChatResponse = await ApiService.deleteAllChat(chatUserId);
      Get.snackbar("Delete Message Successfully", deleteAllChatResponse.message.toString(),
          backgroundColor: Colors.white,
          colorText: Colors.black);
      print(deleteAllChatResponse.toString());
      getUserDetails();
      update();
      setLoading(false);

    } catch (e) {
      print(e.toString());
      Get.snackbar("Failed To Delete!", "No More Message",
          backgroundColor: Colors.white,
          colorText: Colors.black);
      setLoading(false);
    }
  }

  void updateChatSelected() {
    for (var element in items!.result!) {
      print('selected is ' + element.isSelected.toString());
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
   forwardChatUserResponse!.result![index].isSelected =!forwardChatUserResponse!.result![index].isSelected!;
   update();
  }
  void selectUserListItem(int index){
    items!.result![index].isSelected =!items!.result![index].isSelected!;
    if(items!.result![index].isSelected!){
      chatId= 0 ;
    }

    updateChatSelected();

  }

  void forwardMessage(int chatID,String chatUserID){
   final selectedList = forwardChatUserResponse!.result!.where((element) => element.isSelected!);
   final List<int> list = selectedList.map((e) => e.chatUserID!).toList();
  // saveChat(chatID, list.join(','),message);
   forwardMessageList(chatID,list.join(','));

    Get.back();
   chatUserWiseController.userChatWiseData(int.parse(chatUserID));
  }

  void deleteAll(int iondex){
    final selectedDeleteList = items!.result!.where((element) => element.isSelected!);
    final List<int> deleteList = selectedDeleteList.map((e) => e.chatUserId!).toList();
    deleteAllChatData(deleteList.join(','));
  }
}