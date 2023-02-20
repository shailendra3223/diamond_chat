
import 'package:diamond_chat/preferance/PrefsConst.dart';
import 'package:diamond_chat/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/UpdateProfileController.dart';

class ProfilePage extends GetView {
     UpdateProfileController _controller = Get.put(UpdateProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Edit Profile")),
        actions: <Widget>[
          IconButton(
              onPressed: () {

                // _controller.updateDeviceIdData("11", PrefsConst.deviceId);
              _controller.updateDeviceIdData();
              },
              icon: const Icon(Icons.logout_rounded)),
        ],
        backgroundColor: const Color(0xff003399),
      ),
      body: GetBuilder<UpdateProfileController>(
        init: _controller,
        builder: (value) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  InkWell(
                    onTap: (() {
                      _showPicker(context);
                    }),
                    child:value.image==null? Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(50)),
                      width: 100,
                      height: 100,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ):value.image!=null?Container(
                      decoration: BoxDecoration(shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(value.image!.path.toString()))
                      ),
                      height: 80,
                      width: 80,
                    ):Container(
                      decoration: BoxDecoration(shape: BoxShape.circle,
                          image: DecorationImage(image: FileImage(value.image!))
                      ),
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 50),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.85,
                    height: 55,
                    color: const Color(0xff003399),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      value.checkProfile();
                      // _submit();
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          letterSpacing: 1,
                          fontSize: 18.0),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _controller.imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _controller.imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
