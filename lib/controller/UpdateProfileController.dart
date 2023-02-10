import 'dart:io';
import 'package:diamond_chat/preferance/sharepreference_helper.dart';

import 'package:diamond_chat/ui/login/login.dart';
import 'package:diamond_chat/ui/profile/update_profile_post_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferance/PrefsConst.dart';
import '../../preferance/pref.dart';
import '../apimodule/api_service.dart';
import '../ui/chat/home_screen.dart';
import '../ui/logout/update_device_id_response.dart';
import '../ui/profile/user_profile.dart';
import '../utils/constant.dart';

class UpdateProfileController extends GetxController {
  final profileFormKey = GlobalKey<FormState>();
  bool isLoading = true;
  List<UserProfile> items = [];

  final ImagePicker imagePicker = ImagePicker();
  File? image;

  @override
  void onInit() {

    super.onInit();
    setProfileData();

  }

  void setProfileData() async {
      final path = await SharedPreferencesHelper().getString(PrefsConst.PROFILEPATH);
    if(path!=null){
      image = File(path);


      update();
    }

  }

  void setLoading(bool value){
    isLoading = value;
    update();

  }

  void checkProfile() async{
      if(image!=null){
        await SharedPreferencesHelper().setString(PrefsConst.PROFILEPATH, image!.path);
        updateProfilePostData();
      }
      Get.offAll(()=>HomeScreen());

  }

  void imgFromCamera() async {
     XFile? img = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    image = File(img!.path);
    update();
  }

  void imgFromGallery() async {
    XFile? img = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    image = File(img!.path);
    update();
  }

  
  /*TODO Logout TODO*/
  Future<void> updateDeviceIdData() async {
    try {
      final UpdateDeviceId response = await ApiService.updateDeviceId();
      Get.snackbar("Logout Successfully", "${response.message}",
          backgroundColor: Colors.white,
          colorText: Colors.black);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.clear();

         Get.offAll(()=>LoginPage());
         update();

    } catch (e) {
      print(e.toString());
      // Get.snackbar("Logout Successfully", 'Failed To Update Device Id!',
      //     backgroundColor: Colors.white,
      //     colorText: Colors.black);
      // Handle exception
    }
  }

  Future<void> updateProfilePostData() async {
    try {
      final UpdateProfilePost response = await ApiService.updateProfilePost(File(image!.absolute.path));
      Get.snackbar("Profile Change Successfully", "${response.message}",
          backgroundColor: Colors.white,
          colorText: Colors.black);
      update();
    } catch (e) {
      print(e.toString());
      Get.snackbar("Data Unsuccessfully", 'Failed To Update Device Id!',
          backgroundColor: Colors.white,
          colorText: Colors.black);
      // Handle exception
    }
  }
}
