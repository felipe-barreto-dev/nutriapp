import 'package:flutter/material.dart';
import 'package:nutriapp/main.dart';
import 'package:nutriapp/util/custom_drawer.dart';
import 'package:nutriapp/views/cadastros/cadastro_usuario.dart';

class Creditos extends StatefulWidget {
  const Creditos({super.key});

  @override
  CreditosState createState() => CreditosState();
}

class CreditosState extends State<Creditos> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Créditos',
      home: Scaffold(
        drawer: const CustomDrawer(currentIndex: 1),
        appBar: AppBar(
          title: const Text("Créditos"),
          backgroundColor: const Color.fromARGB(255, 131, 196, 181),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Breno Mazzini Costa',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Felipe Barreto Pereira',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Gabrielle de Oliveira Bussi',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Luiz Felipe Barbosa Arruda',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Millena de Souza Netto',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 20),
              Text(
                'Rafael Claro Ramiro',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)
              ),
            ],
          ),
        )
      ),
    );
  }
}
