import 'package:get/get.dart';
import 'package:nutriapp/login/loginView.controller.dart'; 

class LoginBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => LoginController());
  }
}