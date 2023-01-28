import 'dart:convert';
import 'package:diamond_chat/model/login_response/login_data.dart';
import 'package:diamond_chat/model/user_model.dart';
import 'package:diamond_chat/preferance/PrefsConst.dart';
import 'package:diamond_chat/preferance/sharepreference_helper.dart';
import 'package:diamond_chat/ui/logout/update_device_id_response.dart';
import 'package:http/http.dart' as http;

import '../client/dioClient.dart';

import '../ui/profile/user_profile.dart';
import '../utils/constant.dart';
import '../utils/constantBaseUrl.dart';

 class ApiService {
  static var client = http.Client();

  static final DioClient _dioClient = DioClient();

  static Future<LoginResponse> login(String userNameId,String userPassword, String deviceId) async {
    try {
      final body = {
        "UserNameId": "$userNameId",
        "UserPassword": "$userPassword",
        "DeviceId": "$deviceId"
      };
      var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/Login',data: body);
      print('login $response');
      if (response["message"] == Constant.SUCCESS) {
        return LoginResponse.fromJson(response);
      }
      else{
        throw Exception('Invalid UserId Or Password!');
      }
    } on Error catch (e) {
      print('Error: $e');
      throw Exception(e);
    }
  }


  static Future<UserList> userList() async {
    try {
      final userId = await SharedPreferencesHelper().getString(PrefsConst.userId);
      var response = await _dioClient.get('${ConstantBaseUrl.baseurl}chat/GetChatList',queryParameters: {"userID":userId.toString()});
      print("userList $response");
      print(response["message"]);
      if (response["message"] == Constant.SUCCESS) {
        return UserList.fromJson(response);
      }
      else{
        throw Exception('No data Found');
      }
    } on Error catch (e) {
      print('Error: $e');
      throw Exception(e);
    }
  }

  /*TODO UserProfile TODO */
  static Future<UserProfile> userProfile() async {
    try {
      final userId = await SharedPreferencesHelper().getString(PrefsConst.userId);
      var response = await _dioClient.get('${ConstantBaseUrl.baseurl}chat/GetMobileProfileImg',queryParameters: {'userId':userId.toString()});
      print("userProfile" +response);
      if (response["message"] == Constant.SUCCESS) {
        return UserProfile.fromJson(response);
      }
      else{
        throw Exception('No data Found');
      }
    } on Error catch (e) {
      print('Error: $e');
      throw Exception(e);
    }
  }
/*TODO Update Device ID TODO */
  static Future<UpdateDeviceId> updateDeviceId() async {
    try {
      final body = {
       'userId': await SharedPreferencesHelper().getString(PrefsConst.userId),
        "deviceId": "123345",

      };
      var response = await _dioClient.post('${ConstantBaseUrl.baseurl}chat/UpdateDeviceId',data: body);
      print('updateDeviceId $response');
      if (response["message"] == Constant.SUCCESS) {
        return UpdateDeviceId.fromJson(response['result']);
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
