import 'package:nutriapp/util/grafico_referencia.dart';
import 'package:nutriapp/views/formas/tela_padrao.dart';
import 'package:flutter/material.dart';

import '../../model/FormaGeometrica.dart';
import '../../routes/rotas.dart';
import '../../util/botao.dart';
import '../../util/entrada_numero.dart';

class Triangulo extends StatefulWidget {
  const Triangulo({super.key});

  @override
  TrianguloState createState() => TrianguloState();
}

class TrianguloState extends State<Triangulo> {
  final TextEditingController _baseController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  void _calcularAreaTriangulo() {
    double base = double.tryParse(_baseController.text) ?? 0.0;
    double altura = double.tryParse(_alturaController.text) ?? 0.0;
    FormaGeometrica geometria =
        FormaGeometrica.triangulo(base: base, altura: altura);
    Rotas.pushNamed(context, '/resultado', geometria);
  }

  @override
  Widget build(BuildContext context) {
    return TelaPadrao(
      'Cálculo da Área do Triângulo',
      <Widget>[
        const GraficoReferencia('assets/images/triangulo.png'),
        CaixaDeNumero('Base do triângulo', _baseController),
        CaixaDeNumero('Altura do triângulo', _alturaController),
        BotaoCalcular("Calcular", _calcularAreaTriangulo),
      ],
    );
  }
}
