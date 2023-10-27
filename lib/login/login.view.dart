import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriapp/login/loginView.controller.dart';
import 'package:nutriapp/login/widgets/emailField.widget.dart';
import 'package:nutriapp/login/widgets/passwordField.widget.dart';
import 'widgets/loginButton.widget.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login')),),
      body: _body(),
    );
  }

  _body() {
    return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(
            height: Get.height / 3,
            ),
          EmailField(),
          SizedBox(height: 27),
          PasswordField(),
          SizedBox(height: 27),
          Divider(),
          SizedBox(height: 27), 
          LoginButton(), 
          ],
      );
  }
}