import 'package:nutriapp/model/FormaGeometrica.dart';
import 'package:nutriapp/util/entrada_numero.dart';
import 'package:nutriapp/views/tela_padrao.dart';
import 'package:flutter/material.dart';

import '../../routes/rotas.dart';
import '../../util/botao.dart';
import '../../util/grafico_referencia.dart';

class CompartilhamentoCardapio extends StatefulWidget {
  const CompartilhamentoCardapio({super.key});

  @override
  CompartilhamentoCardapioState createState() => CompartilhamentoCardapioState();
}

class CompartilhamentoCardapioState extends State<CompartilhamentoCardapio> {
  final TextEditingController _raioController = TextEditingController();

  void _calcularAreaCompartilhamentoCardapio() {
    double raio = double.tryParse(_raioController.text) ?? 0.0;
    FormaGeometrica geometria = FormaGeometrica.circulo(raio: raio);
    Rotas.pushNamed(context, '/resultado', geometria);
  }

  @override
  Widget build(BuildContext context) {
    return TelaPadrao('Compartilhamento de cardápio', <Widget>[
      const GraficoReferencia('assets/images/area-circulo.png'),
      CaixaDeNumero('Raio do círculo', _raioController),
      BotaoCalcular("Calcular", _calcularAreaCompartilhamentoCardapio)
    ]);
  }
}
