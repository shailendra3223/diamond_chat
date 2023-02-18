import 'dart:async';
import 'dart:io';

import 'package:diamond_chat/model/chat/chat_data_user_wise.dart';
import 'package:diamond_chat/model/chat/delete_single_chat.dart';
import 'package:diamond_chat/ui/camera_screen/camera_screen_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../apimodule/api_service.dart';
import '../model/chat/save_chat_response.dart';
import '../preferance/PrefsConst.dart';
import '../preferance/sharepreference_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../utils/constantBaseUrl.dart';

class ChatUserWiseController extends GetxController{
  List<ChatListUserWiseModel> chatDataUser = [];
  List<CommonChatResponse> deleteChat = [];
  dynamic chatUserId;
  dynamic chatId;
  // int selectedIndex = -1;
  bool chatSelected = false;
  List<SaveChatResponse> saveChatResponse = [];
  bool isLoading = true;
  final textFieldText = "".obs;
  Timer? timer;
  final ScrollController scrollController = ScrollController();
  IO.Socket? socket;
  bool show = false;
  final ImagePicker imagePicker = ImagePicker();
  File? image;
  bool imageSet = false;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    chatUserId = Get.arguments;
    userChatWiseData(chatUserId);
    chatId = Get.arguments;

    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) =>  userChatWiseData(chatUserId));
    connect();
    update();
  }

  void connect() {
    // MessageModel messageModel = MessageModel(sourceId: widget.sourceChat.id.toString(),targetId: );
    socket = IO.io("http://192.168.0.106:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.emit("message", chatUserId);
    socket!.onConnect((data) {
      print("Connected");
      socket!.on("message", (msg) {
        print(msg);
        userChatWiseData(chatUserId);
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        update();
      });
    });
    if (kDebugMode) {
      print(socket!.connected);
    }
    update();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  void setLoading(bool value){
    isLoading = value;
    update();

  }

   setShow(bool value){
    show = value;
    update();

  }
/*TODO------------- Camera and Gallery Add  ------------------TODO*/
  void imgFromGallery() async {
    XFile? img = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    Get.to(()=>CameraViewPage(path: img!.path,));
    update();
  }

  void imgFromCamera() async {
    XFile? img = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if(img!.path.isNotEmpty){
      image = File(img.path);
    }

      update();
  }

  /*TODO------------- Camera and Gallery End  ------------------TODO*/

  /*TODO------------- updateText  ------------------TODO*/
  void updateText(String newText) {
    textFieldText.value = newText;
  }

  void refreshPage() {
    update(["refresh"]);
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
  /*TODO userChatWiseData TODO*/
  Future<void> userChatWiseData(int chatUserId) async {
    try {
      setLoading(true);
      final ChatDataUserWise response = await ApiService.chatUserWise(chatUserId);
      List<ChatListUserWiseModel> list = response.result!.chatListUserWiseModel!;
      for(int i =0; i<chatDataUser.length;i++){
        if(i<list.length){
          if(chatDataUser[i].chatId==list[i].chatId){
            list[i].isSelected= chatDataUser[i].isSelected!;
          }
        }
      }
      chatDataUser = list;
      // if(chatDataUser.isNotEmpty){
      //
      // }
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
      final CommonChatResponse deleteSingleChatResponse = await ApiService.deleteChat(chatId);
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


  /*TODO------------------- Save Chat -------------------TODO*/
  Future<void> saveChat(int userChatId, String message,{File? file}) async {
    print(userChatId);
    print(file);
    print("------------------------");
    try {
      setLoading(true);
      final SaveChatResponse response = await ApiService.saveChatData(
       userChatId, message,file: file);

      // File(image!.absolute.path)
      saveChatResponse.add(response);
      // if(response.status==200){
      //
      // }
      userChatWiseData(chatUserId);
      setLoading(false);
      update();
    } catch (e) {
      print(e.toString());
      setLoading(false);

      // Handle exception
    }
  }

  void sendMessage(String message,{File? file}) {

    saveChat(chatUserId,message,file: file);
    socket!.emit("message",
        {"message": message, "chatUserId": chatUserId,});

   update();
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