import 'package:flutter/material.dart';
import 'package:nutriapp/views/consultas/consulta_alimento.dart';
import 'package:nutriapp/views/consultas/consulta_cardapio.dart';
import 'package:nutriapp/views/consultas/consulta_usuario.dart';

class Consultas extends StatefulWidget {
  const Consultas({super.key});

  @override
  CirculoState createState() => CirculoState();
}

class CirculoState extends State<Consultas> {
  int _currentIndex = 0; // Índice da aba ativa

  final List<Widget> _telas = [
    const ConsultaUsuario(),
    const ConsultaAlimento(),
    const ConsultaCardapio(),
  ]; // Lista de telas para os diferentes tipos de consulta

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas'),
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
