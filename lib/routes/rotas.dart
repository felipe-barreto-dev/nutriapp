import 'package:flutter/material.dart';
import 'package:nutriapp/views/cadastros/cadastro_usuario.dart';
import 'package:nutriapp/views/creditos.dart';
import 'package:nutriapp/views/login.dart';

import '../main.dart';

class Rotas {
  static Map<String, Widget Function(BuildContext)> carregar() {
    return {
      '/cadastro-usuario': (context) => const CadastroUsuario(),
      '/creditos': (context) => const Creditos(),
      '/login': (context) => const Login(),
      '/principal': (context) => const Home()
    };
  }

  static void Function() call(BuildContext context, String rota) {
    return () {
      Navigator.pushNamed(context, rota);
    };
  }

  static void pushNamed(BuildContext context, String rota,
      [Object data = Object]) {
    Navigator.pushNamed(context, rota, arguments: data);
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
