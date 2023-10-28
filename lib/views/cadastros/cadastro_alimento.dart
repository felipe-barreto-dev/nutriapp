import 'dart:io';

import 'package:nutriapp/helpers/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:nutriapp/util/foto_perfil.dart';

const List<String> categorias = <String>['Café', 'Almoço', 'Janta'];
const List<String> tipos = <String>['Bebida', 'Proteína', 'Carboidrato', 'Fruta', 'Grão'];
class CadastroAlimento extends StatefulWidget {
  const CadastroAlimento({super.key});

  @override
  CadastroAlimentoState createState() => CadastroAlimentoState();
}

class CadastroAlimentoState extends State<CadastroAlimento> {
  // Retorna todos os registros da tabela
  List<Map<String, dynamic>> _registros = [];
  late DateTime _selectedDate;

  // Aparece enquanto os dados não são carregados
  bool _isLoading = false;

  //Essa função retorna todos os registros da tabela
  void _exibeTodosRegistros() async {
    final data = await DatabaseHelper.exibeTodosAlimentos();
    print(data);
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
  final TextEditingController _photoController = TextEditingController();
  String _typeController = tipos.first;
  String _categoryController = categorias.first;

  Widget _buildCategoriaSelector() {
    return DropdownMenu<String>(
      initialSelection: _categoryController,
      onSelected: (String? newValue) {
        setState(() {
          _categoryController = newValue!; 
        });
      },
      dropdownMenuEntries: categorias.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }


  Widget _buildTipoSelector() {
    return DropdownMenu<String>(
      initialSelection: _typeController,
      onSelected: (String? newValue) {
        setState(() {
          _typeController = newValue!; 
        });
      },
      dropdownMenuEntries: tipos.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }

  // Esta função será acionada quando o botão for pressionado
  // Também será acionado quando um item for inserido, atualizado ou removido
  void _showForm(int? id) async {
    if (id != null) {
      final registroExistente = _registros.firstWhere((element) => element['id'] == id);
      _nameController.text = registroExistente['nome'];
      _categoryController = registroExistente['categoria'];
      _photoController.text = registroExistente['foto'];
      _typeController = registroExistente['tipo'];
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Nome'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _photoController,
              decoration: const InputDecoration(hintText: 'Foto'),
            ),
            const SizedBox(height: 20),
            _buildCategoriaSelector(), // Adicione aqui o DropdownButton de Categoria
            const SizedBox(height: 20),
            _buildTipoSelector(), // Adicione aqui o DropdownButton de Tipo
            const SizedBox(height: 20),
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
                _categoryController = '';
                _typeController = '';
                _photoController.text = '';

                // Fecha o modal de inserção/alteração
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Novo alimento' : 'Atualizar'),
            )
          ],
        ),
      ),
    );
  }

  // Insere um novo registro
  Future<void> _insereRegistro() async {
    await DatabaseHelper.insereAlimento(
        _nameController.text, _photoController.text, _categoryController, _typeController);
    _exibeTodosRegistros();
  }

  // Atualiza um registro
  Future<void> _atualizaRegistro(int id) async {
    await DatabaseHelper.atualizaAlimento(
        id, _nameController.text, _photoController.text, _categoryController, _typeController);
    _exibeTodosRegistros();
  }

  // Remove um registro
  void _removeRegistro(int id) async {
    await DatabaseHelper.removeAlimento(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Alimento removido com sucesso!'),
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
                    title: Text(_registros[index]['nome']),
                    subtitle: Text(_registros[index]['categoria']),
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
