import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriapp/main.dart'; 

class LoginController extends GetxController{
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  static const email = 'admin@admin.com';
  static const password = 'admin';

  void tryTologin() {
    switch(emailInput.text) {
      case email:
        checkPassword(); 
        break;
      case '':
        printError('Insira um email');  
        break;
      default: 
      printError('Email não encontrado');
    }
    
  }

  void checkPassword(){
    switch(passwordInput.text){
      case password: 
        login();
        break; 
      case '': 
        printError('Insira uma senha');
        break;
      default:
      printError('Senha incorreta');
    }
  } 
  
  void login(){
    Get.to(const Home());
  }

  void printError(String error){
    print(error);
  }
}