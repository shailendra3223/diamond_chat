import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/pagecontroller.dart';
import 'game_page/game_page.dart';


class StartQuizPage extends GetView<gamePageController> {
  final gamePageController _controller = Get.put(gamePageController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
       body: Column(
        children: [
          Center(child: Image.asset("assets/animation_quiz.gif",height: 300,width: 500,)),
          Center(child: Image.asset("assets/animation_home.gif",height: 300,)),
          Expanded(
              child: Center(
                  child: RawMaterialButton(
                    onPressed: () {
                      Get.to(()=>GamePageScreen());
                    },
                    shape: const StadiumBorder(),
                    fillColor: Colors.pink[400],
                    child: const Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      child: Text(
                        "PLAY & WIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
              )
          ),

        ],
      ),
    );
  }
}
