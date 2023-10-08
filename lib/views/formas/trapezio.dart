import 'package:nutriapp/views/formas/tela_padrao.dart';
import 'package:flutter/material.dart';

import '../../model/FormaGeometrica.dart';
import '../../routes/rotas.dart';
import '../../util/entrada_numero.dart';
import '../../util/botao.dart';
import '../../util/grafico_referencia.dart';

class Trapezio extends StatefulWidget {
  const Trapezio({super.key});

  @override
  TrapezioState createState() => TrapezioState();
}

class TrapezioState extends State<Trapezio> {
  final TextEditingController _baseMenorController = TextEditingController();
  final TextEditingController _baseMaiorController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  void _calcularAreaTrapezio() {
    double baseMenor = double.tryParse(_baseMenorController.text) ?? 0.0;
    double baseMaior = double.tryParse(_baseMaiorController.text) ?? 0.0;
    double altura = double.tryParse(_alturaController.text) ?? 0.0;
    FormaGeometrica geometria = FormaGeometrica.trapezio(
        baseMenor: baseMenor, baseMaior: baseMaior, altura: altura);
    Rotas.pushNamed(context, '/resultado', geometria);
  }

  @override
  Widget build(BuildContext context) {
    return TelaPadrao('Cálculo da Área do Trapézio', <Widget>[
      const GraficoReferencia('assets/images/trapezio.png'),
      CaixaDeNumero('Base menor do trapézio', _baseMenorController),
      CaixaDeNumero('Base maior do trapézio', _baseMaiorController),
      CaixaDeNumero('Altura do trapézio', _alturaController),
      BotaoCalcular("Calcular", _calcularAreaTrapezio),
    ]);
  }
}
