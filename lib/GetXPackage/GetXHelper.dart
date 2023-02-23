import 'package:get/get.dart';

class GetXHelper extends GetxController{
  int which = 0;

  void checkText(String text){
    if(text.isNum){
      print('${text} is a Civil ID');
      which = 1;
    }
    else if(text.isEmpty){
      print('${text} is empty');
      which = 0;
    }
    else{
      print('${text} is a username');
      which = 2;
    }
    update();
  }

  login(){
    if(which == 1){
      return 1;
    }
    else if(which == 0){
      return 0;
    }
    else if(which == 2){
      return 2;
    }
  }
}