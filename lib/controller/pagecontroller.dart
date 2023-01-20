import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class gamePageController extends GetxController{
  // ignore: non_constant_identifier_names
  int question_pos = 0;
  int score = 0;
  bool btnPressed = false;
  PageController? controller;
  String btnText = "Next Question";
  bool answered = false;
  int timer = 15;
  String showtime = "15";
  bool canceltime = false;
  bool showRight = false;
  bool wrongAnswer = false;
  late AnimationController _controller;

  late Animation animation;

  double beginAnim = 0.0;

  double endAnim = 1.0;

@override
  void onInit() {
    // TODO: implement onInit
  controller = PageController(initialPage: 0);
    super.onInit();
  }

  void clearData(){
  answered = false;
  update();
  }

  // ignore: non_constant_identifier_names
  void ResetFunction(){
  btnPressed = false;
  answered = false;
  btnText = "next Question";
  update();
  }
  void UpdateQuestionData(){
    btnText = "Next Question";
    btnPressed = false;
    clearData();
    update();
  }
  // ignore: non_constant_identifier_names
  void UpdateQuestionAnswer(){
  btnPressed= true;
  answered = true;
  clearData();
  update();
  }

  void RightAnswer(){
   showRight = true;
    update();
    Future.delayed(const Duration(seconds: 2),(){
      showRight = false;
      update();
    });
  }
  // ignore: non_constant_identifier_names
  void WorngAnswer(){
  wrongAnswer = true;
  update();
  Future.delayed(const Duration(seconds: 2),(){
    wrongAnswer = false;
    update();
  });
  }
  void OnPlayAudio() {
    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
     audioPlayer.open(Audio("assets/audio/right_answer.mp3"));
     update();
    Future.delayed(const Duration(seconds: 2),(){
      audioPlayer.stop();
      update();
    });
  }
  // ignore: non_constant_identifier_names
  void OnPlayAudioWorng() {
    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
    audioPlayer.open(Audio("assets/audio/wrong.mp3"));
    update();
    Future.delayed(const Duration(seconds: 2),(){
      audioPlayer.stop();
      update();
    });
  }
  void SetTimer(){
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
        if (timer < 1) {
          t.cancel();
          controller!.nextPage( duration: const Duration(milliseconds: 50),
              curve: Curves.easeInExpo);
        } else if (canceltime == true) {
          t.cancel();
        } else {
          timer = timer - 1;
          update();
        }
        showtime = timer.toString();
        update();

    });
  }

}