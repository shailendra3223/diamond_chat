import 'package:diamond_chat/game_page/game_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controller/pagecontroller.dart';



class ResultPage extends GetView<gamePageController> {
  gamePageController controller = Get.put(gamePageController());
int score;
ResultPage(this.score);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          Container(
            child: Image.asset("assets/animation_result.gif"),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Text(
            "Congratulations",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          const Text(
            "Your Total  Score is",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            "${score}",
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 85.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const  SizedBox(
            height: 70.0,
          ),
          RawMaterialButton(
            onPressed: () {
              Get.offAll(()=>GamePageScreen());
              controller.ResetFunction();
            },
            shape:const StadiumBorder(),
            fillColor: Colors.pink[400],
            padding:const EdgeInsets.all(18.0),
            child:const Text(
              "Repeat the quiz",
              style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

  }
}



