import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutriapp/views/login/login.dart';
import 'package:nutriapp/main.dart';
import 'package:nutriapp/views/cadastros/cadastro_usuario.dart';
import 'package:nutriapp/views/creditos.dart';

class CustomDrawer extends StatefulWidget {
  final int currentIndex;

  const CustomDrawer({required this.currentIndex, Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

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
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 158, 209, 197),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 200, // Altura do cabeçalho personalizado
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(
                    255, 255, 255, 255), // Cor de fundo do cabeçalho
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo-app.png', // Substitua pelo caminho da sua imagem de logotipo
                  ),
                  CircleAvatar(
                    radius:
                        25, // Ajuste o raio para controlar o tamanho do CircleAvatar
                    backgroundImage: userData!['foto'].isNotEmpty
                        ? FileImage(File(userData!['foto']))
                        : null,
                    child: userData!['foto'].isEmpty
                        ? const Icon(Icons.person,
                            size: 25, color: Colors.white)
                        : null,
                  ),
                  Text(
                    userData!['nome'],
                    style: const TextStyle(
                      color: Color.fromARGB(255, 40, 106, 86),
                      // verde escuro logo
                      // color: Color.fromARGB(255, 131, 196, 181),
                      // verde claro
                      // color: Color.fromARGB(255, 158, 209, 197),
                      fontSize: 20,
                    ),
                  )
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
                fontSize: 20,
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
                fontSize: 20,
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
                builder: (context) => const Login(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
