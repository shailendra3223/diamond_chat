import 'dart:convert';
import 'dart:io';
import 'package:diamond_chat/model/chat/chat_data_user_wise.dart';
import 'package:diamond_chat/model/chat/delete_single_chat.dart';
import 'package:diamond_chat/model/chat/forward_chat_user_response.dart';
import 'package:diamond_chat/model/login_response/login_data.dart';
import 'package:diamond_chat/model/chat/homepage_response.dart';
import 'package:diamond_chat/preferance/PrefsConst.dart';
import 'package:diamond_chat/preferance/sharepreference_helper.dart';
import 'package:diamond_chat/ui/logout/update_device_id_response.dart';
import 'package:diamond_chat/ui/profile/update_profile_post_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../client/dioClient.dart';

import '../model/chat/delete_all_chat.dart';
import '../model/chat/save_chat_response.dart';
import '../ui/profile/user_profile.dart';
import '../utils/constant.dart';
import '../utils/constantBaseUrl.dart';

 class ApiService {
  static var client = http.Client();

  static final DioClient _dioClient = DioClient();

  /*TODO------------------- Login -------------------TODO*/
  static Future<LoginResponse> login(String userNameId,String userPassword, String deviceId) async {
    try {
      final body = {
        "UserNameId": "$userNameId",
        "UserPassword": "$userPassword",
        "DeviceId": "$deviceId"
      };
      print('loginResponse $body');
      var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/Login',data: body);
      print('loginResponse $response');
      if (response["message"] == Constant.SUCCESS) {
        return LoginResponse.fromJson(response);
      }
      else{
        throw Exception('Invalid UserId Or Password!');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception(e);
    }
  }

  /*TODO-------------------  Chat user List -------------------TODO*/
  static Future<HomePageResponse> userList() async {
    try {
      final userId = await SharedPreferencesHelper().getString(PrefsConst.userId);
      var response = await _dioClient.get('${ConstantBaseUrl.baseurl}chat/GetChatList',queryParameters: {"userID":userId.toString()});
      print("userList $response");
      print(response["message"]);
      if (response["message"] == Constant.SUCCESS) {
        return HomePageResponse.fromJson(response);
      }
      else{
        throw Exception('No data Found');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception(e);
    }
  }

  /*TODO-------------------  GetNotificationCount -------------------TODO*/
  static Future<CommonChatResponse> getNotification() async {
    try {
      final userId = await SharedPreferencesHelper().getString(PrefsConst.userId);
      var response = await _dioClient.get('${ConstantBaseUrl.baseurl}chat/GetNotificationCount',queryParameters: {"userID":userId.toString()});
      print("getNotification $response");
      print(response["message"]);
      if (response["message"] == Constant.SUCCESS) {
        return CommonChatResponse.fromJson(response);
      }
      else{
        throw Exception('No data Found');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception(e);
    }
  }

  /*TODO------------------- Forward Chat user List -------------------TODO*/
  static Future<ForwardChatUserResponse> getForwardCharUserList() async {
    try {
       final userId = await SharedPreferencesHelper().getString(PrefsConst.userId);
      var response = await _dioClient.get('${ConstantBaseUrl.baseurl}chat/GetMobileUserList?userId=${userId.toString()}');
      print("userList $response");
      print(response["message"]);
      if (response["message"] == Constant.SUCCESS) {
        return ForwardChatUserResponse.fromJson(response);
      }
      else{
        throw Exception('No data Found');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception(e);
    }
  }

  /*TODO------------------- Forward Chat Data user Wise -------------------TODO*/
  static Future<ChatDataUserWise> chatUserWise(dynamic chatUserId) async {
    print(chatUserId);
    try {
      final body = {
        'userId': await SharedPreferencesHelper().getString(PrefsConst.userId),
        "pageNumber":"1",
        "chatUserId":chatUserId,

      };
      var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/GetChatUserWise',data: body);
      print('GetChatUserWise $response');
      if (response["message"] == Constant.SUCCESS) {
        return ChatDataUserWise.fromJson(response);
      }
      else{
        throw Exception('Failed To Update Device Id!');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception(e);
    }
  }



  /*TODO------------------- UserProfile -------------------TODO*/
  static Future<UserProfile> geUserProfile() async {
    try {
      final userId = await SharedPreferencesHelper().getString(PrefsConst.userId);
      var response = await _dioClient.get('${ConstantBaseUrl.baseurl}chat/GetMobileProfileImg',queryParameters: {"userID":userId.toString()});
      if (kDebugMode) {
        print("hdasdasdad "+response);
      }
      if (response["message"] == Constant.SUCCESS) {
        return UserProfile.fromJson(response);
      }
      else{
        throw Exception('No data Found');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception(e);
    }
  }

  /*TODO------------------- updateDeviceId -------------------TODO*/
  static Future<UpdateDeviceId> updateDeviceId() async {
    try {
      final body = {
       'userId': await SharedPreferencesHelper().getString(PrefsConst.userId),
        "deviceId": "",

      };
      var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/UpdateDeviceId',data: body);
      if (kDebugMode) {
        print('updateDeviceId $response');
      }
      if (response["message"] == Constant.SUCCESS) {
        return UpdateDeviceId.fromJson(response);
      }
      else{
        throw Exception('Failed To Update Device Id!');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception(e);
    }
  }


  /*TODO------------------- updateProfilePost -------------------TODO*/
  static Future<UpdateProfilePost> updateProfilePost(File file) async {
     String fileName = file.path.split('/').last;

     try {
       /*final body= {
         "UserId": await SharedPreferencesHelper().getString(PrefsConst.userId),
         "FileData": file
       };*/
       FormData formData =  FormData.fromMap({
         'UserId': await SharedPreferencesHelper().getString(PrefsConst.userId),
         'FileData':await MultipartFile.fromFile(file.path,
             filename: fileName)
       });

       var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/UpdateMobileProfileImg',data: formData);
       if (kDebugMode) {
         print('FileDataList $response');
       }
       if (response["message"] == Constant.SUCCESS) {
         return UpdateProfilePost.fromJson(response);
       }
       else{
         throw Exception('Failed To Update Device Id!');
       }
     } on Error catch (e) {
       if (kDebugMode) {
         print('Error: $e');
       }
       throw Exception(e);
     }
   }

   /*TODO Save Chat TODO*/
  static Future<SaveChatResponse> saveChatData(int userChatId,String message,{File? file}) async {
    String fileName = "";
    if(file!=null){
      fileName = file!.path.split('/').last;
    }
    FormData formData;
    try {
      if(fileName!=""){
         formData =  FormData.fromMap({
          'UserId': await SharedPreferencesHelper().getString(PrefsConst.userId),
          'FileData':await MultipartFile.fromFile(file!.path,
              filename: fileName),
          // "ChatId":chatId,
          "ChatUserId":userChatId,
          "Message":message,
        });
      }else{
         formData =  FormData.fromMap({
          'UserId': await SharedPreferencesHelper().getString(PrefsConst.userId),
          // 'FileData':await MultipartFile.fromFile(file.path,
          //     filename: fileName),
          // "ChatId":chatId,
          "ChatUserId":userChatId,
          "Message":message,
        });
      }


      var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/SaveChat',data: formData);
      print('SaveChatResponse $response');
      if (response["message"] == Constant.SUCCESS) {
        return SaveChatResponse.  fromJson(response);
      }
      else{
        throw Exception('Failed To Update Device Id!');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw Exception(e);
    }
  }

  /*TODO------------------- deleteAllChat -------------------TODO*/
  static Future<DeleteAllChatResponse> deleteAllChat(String chatUserId) async {
    try {
      final body = {
        'userId': await SharedPreferencesHelper().getString(PrefsConst.userId),
        'chatUserId':chatUserId,
      };
      print(body.toString());
      var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/DeleteAllChat',data: body);
      if (response["message"] == Constant.SUCCESS) {
        return DeleteAllChatResponse.fromJson(response);
      }
      else{
        throw Exception('Failed To Update Device Id!');
      }
    } on Error catch (e) {
      print('Error: $e');
      throw Exception(e);
    }
  }
  /*TODO------------------- updateDeviceId -------------------TODO*/
  static Future<CommonChatResponse> deleteChat(String chatId) async {
    try {
      final body = {
        'userId': await SharedPreferencesHelper().getString(PrefsConst.userId),
        "ChatId": chatId.toString(),

      };
      var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/DeleteChat',data: body);

      if (response["message"] == Constant.SUCCESS) {
        return CommonChatResponse.fromJson(response);
      }
      else{
        throw Exception('Failed To Update Device Id!');
      }
    } on Error catch (e) {
      print('Error: $e');
      throw Exception(e);
    }
  }

  /*TODO------------------- updateDeviceId -------------------TODO*/
  static Future<CommonChatResponse> mobileForwardChat(int chatId,dynamic chatUserId) async {
    try {
      final body = {
        'userId': await SharedPreferencesHelper().getString(PrefsConst.userId),
        "messageId": chatId.toString(),
        "chatUserId": chatUserId,

      };
      print("dfssfdfdsfsd "+ body.toString());
      var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/MobileForwandChat',data: body);

      if (response["message"] == Constant.SUCCESS) {
        return CommonChatResponse.fromJson(response);
      }
      else{
        throw Exception('Failed To Update Device Id!');
      }
    } on Error catch (e) {
      print('Error: $e');
      throw Exception(e);
    }
  }


}
