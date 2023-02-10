import 'package:diamond_chat/apimodule/api_service.dart';
import 'package:diamond_chat/model/login_response/login_data.dart';
import 'package:diamond_chat/preferance/PrefsConst.dart';
import 'package:diamond_chat/preferance/pref.dart';
import 'package:diamond_chat/preferance/sharepreference_helper.dart';
import 'package:diamond_chat/ui/login/login.dart';
import 'package:diamond_chat/ui/logout/update_device_id_response.dart';
import 'package:diamond_chat/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../game_page/game_page.dart';
import '../ui/chat/home_screen.dart';


class LoginController extends GetxController {
  var isLoggedIn = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit


    super.onInit();
  }


  Future<void> login(String username, String password, String deviceId) async {
    try {
      final LoginResponse response = await ApiService.login(username,password,deviceId);
      Get.snackbar("Login Successfully", "${Constant.SUCCESS}",
          backgroundColor: Colors.white,
          colorText: Colors.black);
      await SharedPreferencesHelper().setString(PrefsConst.userId, response.result!.userId.toString());
      await SharedPreferencesHelper().setBool(PrefsConst.logInSaved, true);
      Get.to(()=>HomeScreen());


    } catch (e) {
      print(e.toString());
      Get.snackbar("Invalid UserId Or Password!", 'Wrong username and password',
          backgroundColor: Colors.white,
          colorText: Colors.black);
      // Handle exception
    }
  }



}
