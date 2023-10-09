import 'package:flutter/material.dart';
import 'package:nutriapp/views/compartilhamentos/compartilhamento_alimento.dart';
import 'package:nutriapp/views/compartilhamentos/compartilhamento_cardapio.dart';
import 'package:nutriapp/views/compartilhamentos/compartilhamento_usuario.dart';

class Compartilhamentos extends StatefulWidget {
  const Compartilhamentos({super.key});

  @override
  CirculoState createState() => CirculoState();
}

class CirculoState extends State<Compartilhamentos> {
  int _currentIndex = 0; // Índice da aba ativa

  final List<Widget> _telas = [
    const CompartilhamentoUsuario(),
    const CompartilhamentoAlimento(),
    const CompartilhamentoCardapio(),
  ]; // Lista de telas para os diferentes tipos de compartilhamento

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compartilhamentos'),
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
