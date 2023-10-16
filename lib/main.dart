import 'package:nutriapp/routes/rotas.dart';
import 'package:nutriapp/util/botao.dart';
import 'package:flutter/material.dart';
import 'package:nutriapp/views/cadastros/cadastro_alimento.dart';
import 'package:nutriapp/views/cadastros/cadastro_cardapio.dart';
import 'package:nutriapp/views/cadastros/cadastro_usuario.dart';
import 'package:nutriapp/views/creditos.dart';

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
        home: const Home(),
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
  final String nomeUsuario = "Seu Nome";
  final String emailUsuario = "seu.email@example.com";

  final List<Widget> _telas = [
    // const CadastroUsuario(),
    const CadastroAlimento(),
    const CadastroCardapio(),
  ]; // Lista de telas para os diferentes tipos de cadastro


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriPlus'),
      ),
      body: _telas[_currentIndex], // Exibe a tela correspondente à aba ativa
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 200, // Altura do cabeçalho personalizado
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue, // Cor de fundo do cabeçalho
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo-app.png', // Substitua pelo caminho da sua imagem de logotipo
                    ),
                    Text(
                      nomeUsuario,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      emailUsuario,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Cadastro de Usuário'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CadastroUsuario(),
                ));
              },
            ),
            ListTile(
              title: const Text('Créditos'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Creditos(),
                ));
              },
            ),
            ListTile(
              title: const Text('Sair'),
              onTap: () {
                // Implemente o código de saída aqui
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Índice da aba ativa
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Atualiza a aba ativa ao tocar em um item do BottomNavigationBar
          });
        },
        items: const [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Usuário',
          // ),
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