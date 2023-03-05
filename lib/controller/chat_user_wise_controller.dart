import 'dart:async';
import 'dart:io';
import 'package:diamond_chat/model/chat/chat_data_user_wise.dart';
import 'package:diamond_chat/model/chat/delete_single_chat.dart';
import 'package:diamond_chat/ui/camera_screen/camera_screen_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import '../apimodule/api_service.dart';
import '../model/chat/save_chat_response.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../utils/constantBaseUrl.dart';
import '../utils/firebaseService.dart';

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
  List<XFile> imageFileList = [];
  File? image;
  bool imageSet = false;
  int index = 0;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
   AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    chatUserId = Get.arguments;
    userChatWiseData(chatUserId,scrollToBottom: true);
    chatId = Get.arguments;
    updateText("");
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) =>  userChatWiseData(chatUserId));
    _getToken();
    connect();
    update();
  }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String deviceToken = "cBaR_lDpRRCpaRqtHUVQNR:APA91bEZDyhI8NO8qfBTJpU7ot6mo1hXIHZxI4wCzl_MwkXrYnAPKhweYHVB6sIRwXIwcXBAy1PXVEfw7ZTZyhxY6YGI1JozjjjhgIhmQOVoCwvkqWfN-QmKS0LcoURRHFETA4GAeLk5";




  String _fcmToken ="";

  Future<void> _getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

      _fcmToken = token!;
    update();
    print("FCM Token: $_fcmToken");
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
    final List<XFile> selectedImage = await imagePicker.pickMultiImage();

    if(selectedImage.isNotEmpty){
      if(selectedImage.contains(selectedImage.first)){
        imageFileList.addAll(selectedImage);
        Get.to(()=>CameraViewPage(path: selectedImage.map((e) => File(e.path)).toList(),));
      }else {
          imageFileList.remove(selectedImage.first);
      }

      }
   /* XFile? img = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if(img!=null){
      Get.to(()=>CameraViewPage(path: img.path,));
    }*/

    update();
  }

  void imgFromCamera() async {
    XFile? img = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if(img!.path.isNotEmpty){
      image = File(img.path);
      Get.to(()=>CameraViewPage(path:[File(img.path)],));
    }

      update();
  }

  void imgFromPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'pdf', 'txt'], // add any document file extensions you want to allow
    );
    if (result != null) {
      File image = File(result.files.single.path!);
      Get.to(()=>CameraViewPage(path:result.files.map((e) => File(e.path!)).toList(),));

    }

    // if(img!.path.isNotEmpty){
    //   image = File(img.path);
    //   Get.to(()=>CameraViewPage(path:img.path,));
    // }

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
  Future<void> userChatWiseData(int chatUserId,{bool scrollToBottom=false}) async {
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
      if(scrollToBottom){
        Future.delayed(const Duration(milliseconds: 300),(){
          scrollController.animateTo(
              scrollController
                  .position.maxScrollExtent,
              duration: const Duration(
                  milliseconds: 100),
              curve: Curves.easeOut);
        });
      }


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
    /*  Get.snackbar("Delete Message Successfully", deleteSingleChatResponse.message.toString(),
          backgroundColor: Colors.white,
          colorText: Colors.black);*/
      print(deleteSingleChatResponse);
      userChatWiseData(chatUserId);
      chatSelected = false;
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
  Future<void> saveChat(int userChatId, String message,{List<File>? file}) async {
    print(userChatId);
    print(message.toString());
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

  void sendMessage(String message,{List<File>? file}) async {
    saveChat(chatUserId,message,file: file);
    socket!.emit("message",
        {"message": message, "chatUserId": chatUserId,});

    FirebaseMessagingService().sendNotification('New Message', 'Hello!', deviceToken);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ));
      }
    });

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