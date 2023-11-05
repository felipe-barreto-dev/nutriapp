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
  String? _errorText;

  late DateTime _selectedDate;

  Future<void> _insereRegistro() async {
    if (_nameController.text.isEmpty || _birthdayDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Nome e Data de Nascimento são obrigatórios.'),
      ));
    } else {
      await DatabaseHelper.insereUsuario(
          _nameController.text, _selectedDate, _photoController.text);
      _exibeTodosRegistros();

      // Limpa os campos
      _nameController.text = '';
      _birthdayDateController.text = '';
      _photoController.text = '';

      // Atualiza o índice para 0 (tela de login) após o cadastro bem-sucedido
      setState(() {
        _currentIndex = 0;
      });
    }
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
    _selectedDate = DateTime.now();
    _exibeTodosRegistros();
  }

  Widget _buildUserList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
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
    final DateTime now = DateTime.now();
    final DateTime initialDate = DateTime(1900);

    // Redefine a data selecionada para a data atual
    _selectedDate = now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate.isBefore(initialDate) ? initialDate : _selectedDate,
      firstDate: initialDate,
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthdayDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color.fromARGB(255, 202, 240, 231),
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color.fromARGB(255, 40, 106, 86),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
      body: _currentIndex == 0
          ? _buildLoginScreen()
          : _currentIndex == 1
              ? _buildCadastroScreen()
              : null,
    );
  }

  Widget _buildLoginScreen() {
    return Column(
      children: [
        Image.asset('assets/images/logo+name.png'),
        const Divider(
          thickness: 1,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        const Text(
          'Selecione ou crie um usuário abaixo:\n',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Color.fromARGB(255, 40, 106, 86),
          ),
        ),
        if (_isLoading) CircularProgressIndicator(),
        if (!_isLoading && _registros.isEmpty)
          Text("Nenhum usuário cadastrado"),
        if (!_isLoading && _registros.isNotEmpty)
          Expanded(child: _buildUserList()),
      ],
    );
  }

  Widget _buildCadastroScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _photoController.text.isNotEmpty
                    ? FileImage(File(_photoController.text))
                    : null,
                child: _photoController.text.isEmpty
                    ? Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 40, 106, 86),
                ),
              ),
              child: const Text('Escolher Foto'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _birthdayDateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Data de Nascimento',
                suffixIcon: IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            if (_errorText != null)
              Text(
                _errorText!,
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 40, 106, 86),
                ),
              ),
              onPressed: () async {
                await _insereRegistro();
              },
              child: Text('Novo usuário'),
            )
          ],
        ),
      ),
    );
  }
}
