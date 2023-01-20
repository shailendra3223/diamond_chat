import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:diamond_chat/game_page/result_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/pagecontroller.dart';
import '../model/questions_example.dart';
import 'login.dart';


class GamePageScreen extends GetView<gamePageController> {
   gamePageController _controller = Get.put(gamePageController());
  late ConfettiController _controllerCenter;
  GamePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    return Scaffold(
      appBar: AppBar(title:const Center(child:  Text("Game",),),
        backgroundColor: Colors.grey[400],
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            onPressed: () {
              Get.to(()=>LoginPage());
            },
          )
        ],),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Card(
            color: Colors.grey[100],
            elevation: 15,
            semanticContainer: true,
            shadowColor: Colors.black12,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),

            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: GetBuilder<gamePageController>(
                builder: (value) {
                  return PageView.builder(
                      controller: value.controller,
                      onPageChanged: (page) {
                        if (page == questions.length - 1) {
                          value.btnText = "Result";
                          value.answered = false;
                        }
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                         // value.SetTimer();
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                  children: [
                                    Row(
                                        children: [
                                          Text(
                                            "Question ${index + 1}/10",
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]
                                    ),
                                    const Spacer(),
                                  ]
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: double.infinity,
                                height: 140.0,
                                child: Text(
                                  "${questions[index].question}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                margin:const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                              ),
                              const SizedBox(height: 30,),
                              Align(
                                alignment: Alignment.center,
                                child: ConfettiWidget(
                                  confettiController: _controllerCenter,
                                  blastDirectionality: BlastDirectionality
                                      .explosive,
                                  shouldLoop:
                                  true,
                                  blastDirection: pi,
                                  particleDrag: 0.05,
                                  emissionFrequency: 0.05,
                                  numberOfParticles: 20,
                                  gravity: 0.05,
                                  colors: const [
                                    Color(0xff4FCAA9),
                                    Color(0xff0190DE),
                                    Color(0xffDF3075),
                                    Color(0xffE71827),
                                    Color(0xff7CDEDF),
                                    Color(0xffFDE976)
                                  ], // manually specify the colors to be used
                                ),
                              ),

                              for (int i = 0; i < questions[index].answers!.length; i++)
                                InkWell(
                                  onTap: !value.answered
                                      ? () {
                                    if (questions[index]
                                        .answers!
                                        .values
                                        .toList()[i]) {
                                      value.score++;
                                      _controllerCenter.play();
                                      value.OnPlayAudio();
                                      print("yes");
                                    } else {
                                      print("no");
                                      value.WorngAnswer();
                                      value.OnPlayAudioWorng();
                                    }
                                    value.UpdateQuestionAnswer();
                                  }
                                      : null,
                                  child: Container(
                                    width: double.infinity,
                                    height: 50.0,
                                    margin:const EdgeInsets.only(
                                        bottom: 20.0, left: 12.0, right: 12.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey,width: 1.0),
                                          borderRadius: BorderRadius.circular(30.0),
                                          color: value.btnPressed
                                              ? questions[index].answers!.values.toList()[i]
                                              ? Colors.green
                                              : Colors.red
                                              : Colors.pink[50],
                                        ),
                                        child: Center(
                                          child: Text(questions[index].answers!.keys.toList()[i],
                                            style:const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              const Spacer(),
                              RawMaterialButton(
                                onPressed: () {
                                  if (value.controller?.page?.toInt() == questions.length - 1) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ResultPage(value.score)));
                                  } else {
                                    value.controller?.nextPage(duration: 600.milliseconds, curve: Curves.ease);
                                    value.UpdateQuestionData();
                                  }
                                },
                                shape:const StadiumBorder(),
                                fillColor: Colors.pink[400],
                                padding:const EdgeInsets.all(15.0),
                                child: Text(
                                  value.btnText,
                                  style:const TextStyle(color: Colors.white,fontSize: 16.0),
                                ),
                              )
                            ]);
                      });
                },
              ),
            ),
          ),
          GetBuilder<gamePageController>(
              builder: (value) {
                return Column(
                  children: [
                    Visibility(visible: value.showRight,
                      child: Image.asset("assets/animation_right_answer.gif",height: 600,),
                    ),
                    Visibility(visible: value.wrongAnswer,
                      child: Image.asset("assets/img/wrong_answer.gif",height: 500,),),
                  ],
                );
              }
          )
        ],
      ),
    );

  }
}
