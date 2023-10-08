import 'package:nutriapp/model/FormaGeometrica.dart';
import 'package:nutriapp/util/entrada_numero.dart';
import 'package:nutriapp/views/formas/tela_padrao.dart';
import 'package:flutter/material.dart';

import '../../routes/rotas.dart';
import '../../util/botao.dart';
import '../../util/grafico_referencia.dart';

class Quadrado extends StatefulWidget {
  const Quadrado({super.key});

  @override
  QuadradoState createState() => QuadradoState();
}

class QuadradoState extends State<Quadrado> {
  final TextEditingController _ladoController = TextEditingController();

  void _calcularAreaQuadrado() {
    double lado = double.tryParse(_ladoController.text) ?? 0.0;
    FormaGeometrica geometria = FormaGeometrica.quadrado(lado: lado);
    Rotas.pushNamed(context, '/resultado', geometria);
  }

  @override
  Widget build(BuildContext context) {
    return TelaPadrao('Cálculo da Área do Quadrado', <Widget>[
      const GraficoReferencia('assets/images/area-quadrado.png'),
      CaixaDeNumero('Lado do quadrado', _ladoController),
      BotaoCalcular("Calcular", _calcularAreaQuadrado)
    ]);
  }
}
