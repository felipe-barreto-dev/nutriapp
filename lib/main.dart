import 'package:nutriapp/routes/rotas.dart';
import 'package:nutriapp/util/botao.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraGeometrica());
}

class CalculadoraGeometrica extends StatelessWidget {
  const CalculadoraGeometrica({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nutriapp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const FormasGeometricas(title: 'Nutriapp'),
        routes: Rotas.carregar());
  }
}

class FormasGeometricas extends StatelessWidget {
  const FormasGeometricas({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Botao("Cadastros", Rotas.call(context, "/cadastros")),
              const SizedBox(height: 16.0), // Adiciona espaço entre os botões
              Botao("Consultas", Rotas.call(context, "/consultas")),
              const SizedBox(height: 16.0), // Adiciona espaço entre os botões
              Botao("Compartilhamentos", Rotas.call(context, "/compartilhamentos")),
              const SizedBox(height: 16.0), // Adiciona espaço entre os botões
              Botao("Créditos", Rotas.call(context, "/creditos")),
              const SizedBox(height: 16.0), // Adiciona espaço entre os botões
              Botao("Sair", Rotas.call(context, "/login")),
            ],
          ),
        ),
      ),
    );
  }
}
