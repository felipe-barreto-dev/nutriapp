import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:nutriapp/helpers/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:nutriapp/util/custom_drawer.dart';
import 'package:share_plus/share_plus.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  CadastroUsuarioState createState() => CadastroUsuarioState();
}

class CadastroUsuarioState extends State<CadastroUsuario> {
  // Retorna todos os registros da tabela
  List<Map<String, dynamic>> _registros = [];
  List<Map<String, dynamic>> _filteredRegistros = []; // Lista filtrada

  final TextEditingController _searchController = TextEditingController(); // Controlador do campo de busca

  // Aparece enquanto os dados não são carregados
  bool _isLoading = true;

  //Essa função retorna todos os registros da tabela
  void _exibeTodosRegistros() async {
    final data = await DatabaseHelper.exibeTodosUsuarios();
    setState(() {
      _registros = data;
      _filteredRegistros = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _exibeTodosRegistros();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Filtra a lista de registros com base no texto digitado no campo de busca
    final searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredRegistros = _registros
          .where((registro) => registro['nome'].toLowerCase().contains(searchText))
          .toList();
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayDateController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  late DateTime _selectedDate;

  // Esta função será acionada quando o botão for pressionado
  // Também será acionado quando um item for inserido, atualizado ou removido
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> Criando um novo item
      // id != null -> Atualizando um item existente
      final registroExistente =
          _registros.firstWhere((element) => element['id'] == id);
          _nameController.text = registroExistente['nome'];
      
          final existingDate = registroExistente['data_nascimento'];
          _selectedDate = DateTime.parse(existingDate);
          _birthdayDateController.text = existingDate;
      
          _photoController.text = registroExistente['foto'];
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

    Future<void> _pickImage() async {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _photoController.text = pickedFile.path;
        });
      }
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120, // Defina a largura desejada para o Container
                    height: 120, // Defina a altura desejada para o Container
                    child: CircleAvatar(
                      radius: 60, // Ajuste o raio para controlar o tamanho do CircleAvatar
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
                      if (id == null) {
                        await _insereRegistro();
                      }

                      if (id != null) {
                        await _atualizaRegistro(id);
                      }

                      // Limpa os campos
                      _nameController.text = '';
                      _birthdayDateController.text = '';
                      _photoController.text = '';

                      // Fecha o modal de inserção/alteração
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Novo usuário' : 'Atualizar'),
                  )
                ],
              ),
            ));
  }

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

    // Remove um registro
    void _removeRegistro(int id) async {
      await DatabaseHelper.removeUsuario(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Usuário removido com sucesso!'),
      ));
      _exibeTodosRegistros();
    }

    void _compartilhaRegistro(int userId) {
      final usuario = _registros.firstWhere((element) => element['id'] == userId);

      final userName = usuario['nome'];
      final birthDate = DateTime.parse(usuario['data_nascimento']);
      final age = calculateAge(birthDate);

      final shareText = 'Nome: $userName\nIdade: $age anos';

      Share.share(shareText, subject: 'Dados do Usuário'); // Compartilha os dados do usuário
    }

    void _showOptionsModal(int id) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context); // Fecha o modal
                  _showForm(id); // Abre o formulário de edição
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Deletar'),
                onTap: () {
                  Navigator.pop(context); // Fecha o modal
                  _removeRegistro(id); // Remove o registro
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartilhar'),
                onTap: () {
                  Navigator.pop(context); // Fecha o modal
                  _compartilhaRegistro(id); // Implemente a lógica de compartilhamento
                },
              )
            ],
          );
        },
      );
    }

  int calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    final age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      return age - 1;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(currentIndex: 1),
      appBar: AppBar(
        title: const Text("Cadastro de usuário"),
        backgroundColor: const Color.fromARGB(255, 131, 196, 181),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar usuários por nome',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _filteredRegistros.length,
                    itemBuilder: (context, index) {
                      final usuario = _filteredRegistros[index];
                      final birthDate = DateTime.parse(usuario['data_nascimento']);
                      final age = calculateAge(birthDate);
              
                      return Card(
                        color: const Color.fromARGB(255, 237, 250, 211),
                        margin: const EdgeInsets.all(7.5),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color.fromARGB(255, 158, 209, 197), width: 2.0), // Define a borda verde
                          borderRadius: BorderRadius.circular(4.0), // Define o raio dos cantos
                        ),
                        child: ListTile(
                          leading: SizedBox(
                            width: 72.0, // Largura desejada
                            height: 72.0, // Altura desejada
                            child: SizedBox(
                              child: CircleAvatar(
                                  backgroundColor: const Color.fromARGB(255, 40, 106, 86),
                                  radius: 60, // Ajuste o raio para controlar o tamanho do CircleAvatar
                                  backgroundImage: usuario['foto'].isNotEmpty
                                      ? FileImage(File(usuario['foto']))
                                      : null,
                                  child: usuario['foto'].isEmpty
                                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                                      : null,
                                )
                              ),
                            ),
                          tileColor: const Color.fromARGB(255, 255, 255, 255),
                          title: Text(usuario['nome']),
                          subtitle: Text('Idade: $age anos'),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () => _showOptionsModal(usuario['id']), // Abre o modal de opções
                          ),
                        ),
                      );
                    },
                  ),
              ),
            ],
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 40, 106, 86),
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
