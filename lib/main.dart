import 'package:nutriapp/views/login/login.bindings.dart';
import 'package:nutriapp/routes/rotas.dart';
import 'package:flutter/material.dart';
import 'package:nutriapp/views/cadastros/cadastro_alimento.dart';
import 'package:nutriapp/views/cadastros/cadastro_cardapio.dart';
import 'package:nutriapp/views/cadastros/cadastro_usuario.dart';
import 'package:nutriapp/views/creditos.dart'; 
import 'package:get/get.dart';
import 'package:nutriapp/views/login/login.view.dart';

void main() {
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: LoginBindings(),
        debugShowCheckedModeBanner: false,
        title: 'Nutriapp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginView(),
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
    const CadastroAlimento(),
    const CadastroCardapio(),
  ]; // Lista de telas para os diferentes tipos de cadastro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriPlus'),
        backgroundColor: const Color.fromARGB(255, 131, 196, 181),
      ),
      body: _telas[_currentIndex], // Exibe a tela correspondente à aba ativa
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 158, 209, 197),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 200, // Altura do cabeçalho personalizado
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255), // Cor de fundo do cabeçalho
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
                        color: Color.fromARGB(255, 40, 106, 86),
                        // verde escuro logo
                        // color: Color.fromARGB(255, 131, 196, 181),
                        // verde claro
                        // color: Color.fromARGB(255, 158, 209, 197),
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
              title: const Text(
                  'Home',     
                  style: TextStyle(
                    fontSize: 20, // Altere o tamanho da fonte desejado aqui
                  ),
              ),
              textColor: const Color.fromARGB(255, 255, 255, 255),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Home(),
                ));
              },
            ),
            ListTile(
              title: const Text(
                  'Cadastro de Usuário',     
                  style: TextStyle(
                    fontSize: 20, // Altere o tamanho da fonte desejado aqui
                  ),
              ),
              textColor: const Color.fromARGB(255, 255, 255, 255),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CadastroUsuario(),
                ));
              },
            ),
            ListTile(
              title: const Text(
                  'Créditos',     
                  style: TextStyle(
                    fontSize: 20, // Altere o tamanho da fonte desejado aqui
                  ),
              ),
              textColor: const Color.fromARGB(255, 255, 255, 255),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Creditos(),
                ));
              },
            ),
            ListTile(
            title: const Text(
                  'Sair',     
                  style: TextStyle(
                    fontSize: 20, // Altere o tamanho da fonte desejado aqui
                  ),
              ),
              textColor: const Color.fromARGB(255, 255, 255, 255),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Índice da aba ativa
        backgroundColor: const Color.fromARGB(255, 131, 196, 181),
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Atualiza a aba ativa ao tocar em um item do BottomNavigationBar
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood, color: Color.fromARGB(255, 255, 255, 255)),
            label: 'Alimento',
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu, color: Color.fromARGB(255, 255, 255, 255)),
            label: 'Cardápio',
          ),
        ],
      ),
    );
  }
}