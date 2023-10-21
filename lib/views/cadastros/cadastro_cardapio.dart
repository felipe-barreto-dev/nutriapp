import 'dart:io';

import 'package:nutriapp/helpers/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:nutriapp/util/foto_perfil.dart';

class CadastroCardapio extends StatefulWidget {
  const CadastroCardapio({super.key});

  @override
  CadastroCardapioState createState() => CadastroCardapioState();
}

class CadastroCardapioState extends State<CadastroCardapio> {
  // Retorna todos os registros da tabela
  List<Map<String, dynamic>> _registros = [];
  late DateTime _selectedDate;

  // Aparece enquanto os dados não são carregados
  bool _isLoading = true;

  //Essa função retorna todos os registros da tabela
  void _exibeTodosRegistros() async {
    final data = await DatabaseHelper.exibeTodosAlimentos();
    setState(() {
      _registros = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //Atualiza a lista de registros quando o aplicativo é iniciado
    _exibeTodosRegistros();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  // Esta função será acionada quando o botão for pressionado
  // Também será acionado quando um item for inserido, atualizado ou removido
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> Criando um novo item
      // id != null -> Atualizando um item existente
      final registroExistente =
          _registros.firstWhere((element) => element['id'] == id);
      _nameController.text = registroExistente['nome'];
      _categoryController.text = registroExistente['categoria'];
      _photoController.text = registroExistente['foto'];
      _typeController.text = registroExistente['tipo'];
    }


    // Função para exibir o seletor de data
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
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
                // Isso impedirá que o teclado programável cubra os campos de texto
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Nome'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // ProfilePicture(
                  // size: 100.0,
                  // onPictureSelected: (File image) {
                  //   // Aqui você pode implementar a lógica para lidar com a imagem selecionada
                  //   print('Imagem selecionada: ${image.path}');
                  // }),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // ElevatedButton(
                  //   onPressed: () => _selectDate(context),
                  //   child: Text('Selecione uma data'),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Nome'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _photoController,
                    decoration: const InputDecoration(hintText: 'Foto'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(hintText: 'Categoria'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _typeController,
                    decoration: const InputDecoration(hintText: 'Tipo'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
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
                      _categoryController.text = '';
                      _typeController.text = '';
                      _photoController.text = '';

                      // Fecha o modal de inserção/alteração
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Novo registro' : 'Atualizar'),
                  )
                ],
              ),
            ));
  }

  // Insere um novo registro
  Future<void> _insereRegistro() async {
    await DatabaseHelper.insereAlimento(
        _nameController.text, _photoController.text, _categoryController.text, _typeController.text);
    _exibeTodosRegistros();
  }

  // Atualiza um registro
  Future<void> _atualizaRegistro(int id) async {
    await DatabaseHelper.atualizaAlimento(
        id, _nameController.text, _photoController.text, _categoryController.text, _typeController.text);
    _exibeTodosRegistros();
  }

  // Remove um registro
  void _removeRegistro(int id) async {
    await DatabaseHelper.removeAlimento(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Registro removido com sucesso!'),
    ));
    _exibeTodosRegistros();
  }
      

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          :  ListView.builder(
              itemCount: _registros.length,
              itemBuilder: (context, index) => Card(
                color: Color.fromARGB(255, 237, 250, 211),
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    title: Text(_registros[index]['title']),
                    subtitle: Text(_registros[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_registros[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _removeRegistro(_registros[index]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
