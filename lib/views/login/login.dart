import 'dart:io';

import 'package:nutriapp/helpers/database_helper.dart';
import 'package:nutriapp/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  List<Map<String, dynamic>> _registros = [];
  bool _isLoading = true;

  void _exibeTodosRegistros() async {
    final data = await DatabaseHelper.exibeTodosUsuarios();
    setState(() {
      _registros = data;
      _isLoading = false;
    });
  }

  void _saveSelectedUser(Map<String, dynamic> usuario) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(usuario);

    prefs.setString('selectedUser', userData);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Home()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bem-vindo, ${usuario['nome']}!'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _exibeTodosRegistros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 158, 209, 197),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 202, 240, 231),
        toolbarHeight: 100,
        title: const Text(
          'Bem-vindo!',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 40,
            color: Color(0xFF2A8F83),
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo+name.png', // Substitua pelo caminho da sua imagem de logotipo
            ),
            const Divider(
              thickness: 1,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            const Text(
              'Selecione ou crie um usuário abaixo:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Color.fromARGB(255, 40, 106, 86),
              ),
            ),
            if (_isLoading) // Show a loading indicator
              CircularProgressIndicator(),
            if (!_isLoading && _registros.isEmpty) // Show a message if no records are found
              Text("Nenhum usuário cadastrado"),
            if (!_isLoading && _registros.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _registros.length,
              itemBuilder: (context, index) {
                final usuario = _registros[index];
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      _saveSelectedUser(usuario);
                    },
                    child: Card(
                      child: ListTile(
                        leading: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircleAvatar(
                            backgroundImage: FileImage(
                              File(usuario['foto']),
                            ),
                          ),
                        ),
                        title: Text(usuario['nome']),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
