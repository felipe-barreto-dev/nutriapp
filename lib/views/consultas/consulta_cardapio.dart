import 'package:nutriapp/model/FormaGeometrica.dart';
import 'package:nutriapp/util/entrada_numero.dart';
import 'package:nutriapp/views/tela_padrao.dart';
import 'package:flutter/material.dart';

import '../../routes/rotas.dart';
import '../../util/botao.dart';
import '../../util/grafico_referencia.dart';

class ConsultaCardapio extends StatefulWidget {
  const ConsultaCardapio({super.key});

  @override
  ConsultaCardapioState createState() => ConsultaCardapioState();
}

class ConsultaCardapioState extends State<ConsultaCardapio> {
  final TextEditingController _raioController = TextEditingController();

  void _calcularAreaConsultaCardapio() {
    double raio = double.tryParse(_raioController.text) ?? 0.0;
    FormaGeometrica geometria = FormaGeometrica.circulo(raio: raio);
    Rotas.pushNamed(context, '/resultado', geometria);
  }

  @override
  Widget build(BuildContext context) {
    return TelaPadrao('Consulta de cardápio', <Widget>[
      const GraficoReferencia('assets/images/area-circulo.png'),
      CaixaDeNumero('Raio do círculo', _raioController),
      BotaoCalcular("Calcular", _calcularAreaConsultaCardapio)
    ]);
  }
}
