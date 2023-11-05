import 'package:flutter/material.dart';
import 'package:nutriapp/util/custom_drawer.dart';

class Creditos extends StatefulWidget {
  const Creditos({Key? key});

  @override
  CreditosState createState() => CreditosState();
}

class CreditosState extends State<Creditos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(currentIndex: 1),
      appBar: AppBar(
        title: const Text("Créditos"),
        backgroundColor: const Color.fromARGB(255, 131, 196, 181),
      ),
      body: Column(
        children: <Widget>[
          Image.asset(
              'assets/images/logo+name.png'), // Substitua pelo caminho da sua imagem
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Projeto desenvolvido para a disciplina de Programação para Dispositivos Móveis. Professor: Luiz Felipe.\nIntegrantes do grupo:',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18, // Ajuste o tamanho da fonte conforme desejado
                color: const Color.fromARGB(255, 40, 106, 86),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CreditItem(name: 'Breno Mazzini Costa'),
          CreditItem(name: 'Felipe Barreto Pereira'),
          CreditItem(name: 'Gabrielle de Oliveira Bussi'),
          CreditItem(name: 'Luiz Felipe Barbosa Arruda'),
          CreditItem(name: 'Millena de Souza Netto'),
          CreditItem(name: 'Rafael Claro Ramiro'),
        ],
      ),
    );
  }
}

class CreditItem extends StatelessWidget {
  final String name;

  const CreditItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
        child: Text(
          name,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 131, 196, 181),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
