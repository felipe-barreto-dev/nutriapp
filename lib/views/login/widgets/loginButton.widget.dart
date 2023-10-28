
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriapp/views/login/loginView.controller.dart';

class LoginButton extends GetView<LoginController> {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: () {controller.tryTologin();
      }, 
      child: const Text('Entrar'),
      );
  }
}