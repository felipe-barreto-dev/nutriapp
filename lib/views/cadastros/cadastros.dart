import 'package:flutter/material.dart';
import 'package:nutriapp/views/formas/circulo.dart';
import 'package:nutriapp/views/formas/quadrado.dart';
import 'package:nutriapp/views/formas/retangulo.dart';

class Cadastros extends StatefulWidget {
  const Cadastros({super.key});

  @override
  CirculoState createState() => CirculoState();
}

class CirculoState extends State<Cadastros> {
  int _currentIndex = 0; // Índice da aba ativa

  final List<Widget> _telas = [
    const Circulo(),
    const Quadrado(),
    const Retangulo(),
  ]; // Lista de telas para os diferentes tipos de cadastro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastros'),
      ),
      body: _telas[_currentIndex], // Exibe a tela correspondente à aba ativa
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Índice da aba ativa
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Atualiza a aba ativa ao tocar em um item do BottomNavigationBar
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Alimento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Cardápio',
          ),
        ],
      ),
    );
  }
}
