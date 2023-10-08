import 'package:flutter/material.dart';
import 'package:nutriapp/views/cadastros/cadastros.dart';

import '../main.dart';
import '../views/formas/circulo.dart';
import '../views/formas/quadrado.dart';
import '../views/formas/retangulo.dart';
import '../views/formas/trapezio.dart';
import '../views/formas/triangulo.dart';
import '../views/resultado.dart';

class Rotas {
  static Map<String, Widget Function(BuildContext)> carregar() {
    return {
      '/cadastros': (context) => const Cadastros(),
      '/consultas': (context) => const Retangulo(),
      '/compartilhamentos': (context) => const Triangulo(),
      '/creditos': (context) => const Circulo(),
      '/login': (context) => const Trapezio(),
      '/principal': (context) => const CalculadoraGeometrica()
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
