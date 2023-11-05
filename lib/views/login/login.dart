import 'package:nutriapp/helpers/database_helper.dart';
import 'package:nutriapp/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  List<Map<String, dynamic>> _registros = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayDateController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  late DateTime _selectedDate;

  // Insere um novo registro
  Future<void> _insereRegistro() async {
    await DatabaseHelper.insereUsuario(
        _nameController.text, _selectedDate, _photoController.text);
    _exibeTodosRegistros();
  }

  // Atualiza um registro
  Future<void> _atualizaRegistro(int id) async {
    await DatabaseHelper.atualizaUsuario(
        id, _nameController.text, _selectedDate, _photoController.text);
    _exibeTodosRegistros();
  }

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

  Widget _buildUserList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _registros.length,
      itemBuilder: (context, index) {
        final usuario = _registros[index];
        return Padding(
          padding: const EdgeInsets.all(7),
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
                    radius: 40,
                    backgroundImage: usuario['foto'].isNotEmpty
                        ? FileImage(File(usuario['foto']))
                        : null,
                    child: usuario['foto'].isEmpty
                        ? const Icon(Icons.person, size: 30, color: Colors.white)
                        : null,
                  ),
                ),
                title: Text(usuario['nome']),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _photoController.text = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthdayDateController.text =
            "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      SingleChildScrollView(
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
            if (!_isLoading && _registros.isNotEmpty) _buildUserList(),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120, // Defina a largura desejada para o Container
              height: 120, // Defina a altura desejada para o Container
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _photoController.text.isNotEmpty
                    ? FileImage(File(_photoController.text))
                    : null,
                child: _photoController.text.isEmpty
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 40, 106, 86))), // Chama a função para selecionar uma imagem
              child: const Text('Escolher Foto')
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _birthdayDateController,
              decoration: InputDecoration(
                hintText: 'Data de Nascimento',
                suffixIcon: IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 40, 106, 86))),
              onPressed: () async {
                // Salva o registro
                await _insereRegistro();

                // Limpa os campos
                _nameController.text = '';
                _birthdayDateController.text = '';
                _photoController.text = '';

                // Fecha o modal de inserção/alteração
                Navigator.of(context).pop();
              },
              child: Text('Novo usuário'),
            )
          ],
      ),
      ),
    ];

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Índice da aba ativa
        backgroundColor: const Color.fromARGB(255, 131, 196, 181),
        unselectedItemColor: const Color.fromARGB(255, 40, 106, 86), // Set unselected items to white
        selectedItemColor: Colors.white, // Set selected items to dark green
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Atualiza a aba ativa ao tocar em um item do BottomNavigationBar
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Cadastro',
          ),
        ],
      ),
      body: _telas[_currentIndex],
    );
  }
}
