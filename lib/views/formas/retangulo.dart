import 'package:nutriapp/views/formas/tela_padrao.dart';
import 'package:flutter/material.dart';

import '../../model/FormaGeometrica.dart';
import '../../routes/rotas.dart';
import '../../util/entrada_numero.dart';
import '../../util/botao.dart';
import '../../util/grafico_referencia.dart';

class Retangulo extends StatefulWidget {
  const Retangulo({super.key});

  @override
  RetanguloState createState() => RetanguloState();
}

class RetanguloState extends State<Retangulo> {
  final TextEditingController _baseController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  void _calcularAreaRetangulo() {
    double base = double.tryParse(_baseController.text) ?? 0.0;
    double altura = double.tryParse(_alturaController.text) ?? 0.0;
    FormaGeometrica geometria =
        FormaGeometrica.retangulo(base: base, altura: altura);
    Rotas.pushNamed(context, '/resultado', geometria);
  }

  @override
  Widget build(BuildContext context) {
    return TelaPadrao('Cálculo da Área do Retângulo', <Widget>[
      const GraficoReferencia('assets/images/formula-area-do-retangulo.png'),
      CaixaDeNumero('Base do retângulo', _baseController),
      CaixaDeNumero('Altura do retângulo', _alturaController),
      BotaoCalcular("Calcular", _calcularAreaRetangulo),
    ]);
  }
}
