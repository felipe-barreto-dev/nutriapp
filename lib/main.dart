import 'dart:convert';

import 'package:nutriapp/routes/rotas.dart';
import 'package:flutter/material.dart';
import 'package:nutriapp/util/custom_drawer.dart';
import 'package:nutriapp/views/cadastros/cadastro_alimento.dart';
import 'package:nutriapp/views/cadastros/cadastro_cardapio.dart';
import 'package:get/get.dart';
import 'package:nutriapp/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nutriapp',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const Login(),
        routes: Rotas.carregar());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0; // Índice da aba ativa
  Map<String, dynamic>? userData;

  final List<Widget> _telas = [
    Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90.0), // Define o raio dos cantos
      ),
      child: const CadastroAlimento(),
    ),
    Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90.0), // Define o raio dos cantos
      ),
      child: const CadastroCardapio(),
    ),
  ]; // Lista de telas para os diferentes tipos de cadastro

  void _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('selectedUser');
    if (userDataString != null) {
      setState(() {
        userData = json.decode(userDataString);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Implemente a lógica para retornar à tela de login
          Get.off(Login()); // Isso irá navegar para a tela de login
          return false; // Impede a ação de retorno padrão
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('NutriPlus'),
            backgroundColor: const Color.fromARGB(255, 131, 196, 181),
          ),
          body:
              _telas[_currentIndex], // Exibe a tela correspondente à aba ativa
          drawer: CustomDrawer(currentIndex: _currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex, // Índice da aba ativa
            backgroundColor: const Color.fromARGB(255, 131, 196, 181),
            unselectedItemColor: const Color.fromARGB(255, 40, 106, 86),
            selectedItemColor:
                Colors.white, // Altera a cor dos itens sem seleção para verde
            onTap: (index) {
              setState(() {
                _currentIndex =
                    index; // Atualiza a aba ativa ao tocar em um item do BottomNavigationBar
              });
            },
            items: const [
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
        ));
  }
}
