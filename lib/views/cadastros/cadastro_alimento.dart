import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:nutriapp/helpers/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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
  List<Map<String, dynamic>> _filteredRegistros = []; // Lista filtrada
  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController(); // Controlador do campo de busca

  //Essa função retorna todos os registros da tabela
  void _exibeTodosRegistros() async {
    final data = await DatabaseHelper.exibeTodosAlimentos();
    setState(() {
      _registros = data;
      _filteredRegistros = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //Atualiza a lista de registros quando o aplicativo é iniciado
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
  final TextEditingController _photoController = TextEditingController();
  String _typeController = tipos.first;
  String _categoryController = categorias.first;

  Widget _buildCategoriaSelector() {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width - 30,
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
      width: MediaQuery.of(context).size.width - 30,
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

  void _showForm(int? id) async {
    if (id != null) {
      final registroExistente = _registros.firstWhere((element) => element['id'] == id);
      _nameController.text = registroExistente['nome'];
      _categoryController = registroExistente['categoria'];
      _photoController.text = registroExistente['foto'];
      _typeController = registroExistente['tipo'];
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
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 40, 106, 86),
                radius: 60,
                backgroundImage: _photoController.text.isNotEmpty
                    ? FileImage(File(_photoController.text))
                    : null,
                child: _photoController.text.isEmpty
                    ? const Icon(Icons.dinner_dining, size: 60, color: Colors.white)
                    : null,
              ),
            ),
            ElevatedButton(
              onPressed: _pickImage, // Chama a função para selecionar uma imagem
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 40, 106, 86))),
              child: const Text('Escolher Foto'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 20),
            const Text('Categoria', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildCategoriaSelector(), // Adicione aqui o DropdownButton de Categoria
            const SizedBox(height: 20),
            const Text('Tipo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            const SizedBox(height: 20),
            _buildTipoSelector(), // Adicione aqui o DropdownButton de Tipo
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 40, 106, 86))),
              onPressed: () async {
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
  
    void _compartilhaRegistro(int userId) {
      final usuario = _registros.firstWhere((element) => element['id'] == userId);
      final userName = usuario['nome'];

      final shareText = 'Nome: $userName\nIdade: anos';

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
              ),
            ],
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    labelText: 'Buscar alimentos por nome',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredRegistros.length,
                  itemBuilder: (context, index) {
                    final alimento = _filteredRegistros[index];
                    final String photoPath = alimento['foto'];

                    return Card(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      margin: const EdgeInsets.all(7.5),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color.fromARGB(255, 158, 209, 197), width: 2.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: const Color.fromARGB(255, 255, 255, 255),
                          leading: SizedBox(
                            width: 72.0,
                            height: 72.0,
                            child: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 40, 106, 86),
                              backgroundImage: photoPath.isNotEmpty
                                  ? FileImage(File(photoPath))
                                  : null,
                              child: !photoPath.isNotEmpty
                                  ? const Icon(Icons.dinner_dining, size: 30, color: Colors.white)
                                  : null,
                            ),
                          ),
                          title: Text(alimento['nome']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Categoria: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('${alimento['categoria']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Tipo: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('${alimento['tipo']}'),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () => _showOptionsModal(alimento['id']),
                          ),
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
