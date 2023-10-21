import 'package:nutriapp/helpers/database_helper.dart';
import 'package:flutter/material.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  CadastroUsuarioState createState() => CadastroUsuarioState();
}

class CadastroUsuarioState extends State<CadastroUsuario> {
  // Retorna todos os registros da tabela
  List<Map<String, dynamic>> _registros = [];

  // Aparece enquanto os dados não são carregados
  bool _isLoading = true;

  //Essa função retorna todos os registros da tabela
  void _exibeTodosRegistros() async {
    final data = await DatabaseHelper.exibeTodosUsuarios();
    setState(() {
      _registros = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _exibeTodosRegistros();
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
                    controller: _photoController,
                    decoration: const InputDecoration(hintText: 'Foto'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context), // Add this line
                    child: Text('Selecione uma data'),
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
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
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
                    subtitle: Text(_registros[index]['data_nascimento']),
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
