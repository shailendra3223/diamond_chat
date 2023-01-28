import 'dart:io';

import 'package:diamond_chat/model/user_model.dart';
import 'package:diamond_chat/preferance/PrefsConst.dart';
import 'package:diamond_chat/preferance/sharepreference_helper.dart';
import 'package:diamond_chat/ui/profile/user_profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apimodule/api_service.dart';



class ChatController extends GetxController{
  List<UserList> items = [];
  List<UserProfile> userprofile = [];

  bool isLoading = true;
  File? image;
  @override
  void onInit() {
    // TODO: implement onInit
    getUserDetails();
    setProfileData();
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


/*TODO Profile TODO*/
  void getProfile() async{
    try{
      setLoading(true);
      var profileList = await ApiService.userProfile();
      if(profileList.result!=null){
        userprofile.add(profileList);
        update();
        setLoading(false);
      }
      print(profileList);
    }catch(e){
      setLoading(false);
    }
  }

  void getUserDetails() async{
    try{
      setLoading(true);
      var responseList = await ApiService.userList();
      if(responseList.result!=null){
        items.add(responseList);
        update();
        setLoading(false);
      }
      print(responseList);
    }catch(e){
      setLoading(false);
    }
  }




}