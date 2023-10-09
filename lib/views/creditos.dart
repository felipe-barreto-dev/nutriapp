import 'package:nutriapp/model/FormaGeometrica.dart';
import 'package:flutter/material.dart';

import '../routes/rotas.dart';

class Creditos extends StatefulWidget {
  const Creditos({super.key});

  @override
  CreditosState createState() => CreditosState();
}

class CreditosState extends State<Creditos> {
  void _onItemTapped(int index) {
    if (index == 0) {
      Rotas.pop(context);
    } else if (index == 1) {
      Rotas.call(context, "/principal")();
    }
  }

  @override
  Widget build(BuildContext context) {
    final FormaGeometrica formaGeometrica =
        ModalRoute.of(context)!.settings.arguments as FormaGeometrica;

    final area = formaGeometrica.area;
    final geometria = formaGeometrica.geometria;

    return MaterialApp(
      title: 'Área do $geometria',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Área do $geometria'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Área do $geometria',
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$area',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal,
          selectedItemColor: Colors.black,
          currentIndex: 1,
          selectedFontSize: 20,
          unselectedFontSize: 20,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.error, color: Colors.black),
              label: 'Corrigir',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black),
              label: 'Novo Cálculo',
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
