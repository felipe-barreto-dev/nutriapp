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
          crossAxisAlignment: CrossAxisAlignment.end,
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
              onPressed: _pickImage, // Chama a função para selecionar uma imagem
              child: const Text('Escolher Foto'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Nome'),
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
  
    void _compartilhaRegistro(int userId) {
      final usuario = _registros.firstWhere((element) => element['id'] == userId);

      final userName = usuario['nome'];
      final birthDate = DateTime.parse(usuario['data_nascimento']);

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
          : ListView.builder(
              itemCount: _registros.length,
              itemBuilder: (context, index) {
                final alimento = _registros[index];
                final String photoPath = alimento['foto'];

                Widget leadingWidget; // Widget que será exibido no lugar da imagem

                if (photoPath.isNotEmpty) {
                  // Se houver uma imagem, exibe a imagem
                  leadingWidget = Image.file(
                    File(photoPath),
                    width: 72.0,
                    height: 72.0,
                    fit: BoxFit.cover,
                  );
                } else {
                  // Se não houver imagem, você pode escolher outro widget, por exemplo, um ícone
                  leadingWidget = const Icon(Icons.fastfood); // Substitua pelo ícone desejado
                }

                return Card(
                  color: const Color.fromARGB(255, 237, 250, 211),
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    leading: SizedBox(
                      width: 72.0,
                      height: 72.0,
                      child: leadingWidget,
                    ),
                    title: Text(alimento['nome']),
                    subtitle: Text(alimento['categoria'] + " - " + alimento['tipo']),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showOptionsModal(alimento['id']), // Abre o modal de opções
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
