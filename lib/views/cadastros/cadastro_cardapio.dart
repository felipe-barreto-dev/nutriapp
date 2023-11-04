import 'dart:io';

import 'package:nutriapp/helpers/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

const List<String> categorias = <String>['Café', 'Almoço', 'Janta'];
const List<String> tipos = <String>['Bebida', 'Proteína', 'Carboidrato', 'Fruta', 'Grão'];

class CadastroCardapio extends StatefulWidget {
  const CadastroCardapio({Key? key}) : super(key: key);

  @override
  CadastroCardapioState createState() => CadastroCardapioState();
}

class CadastroCardapioState extends State<CadastroCardapio> {
  List<Map<String, dynamic>> _registros = [];
  List<Map<String, dynamic>> _filteredRegistros = [];
  List<Map<String, dynamic>> _alimentosCafe = [];
  List<Map<String, dynamic>> _alimentosAlmoco = [];
  List<Map<String, dynamic>> _alimentosJanta = [];
  List<Map<String, dynamic>> _usuarios = [];

  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  final Set<int> selectedCafeDaManha = <int>{};
  final Set<int> selectedAlmoco = <int>{};
  final Set<int> selectedJanta = <int>{};
  final Set<int> selectedUsuario = <int>{};

  void toggleAlimento(int id, String mealType) {
    Set<int> selectedSet;

    if (mealType == 'Café') {
      selectedSet = selectedCafeDaManha;
    } else if (mealType == 'Almoço') {
      selectedSet = selectedAlmoco;
    } else if (mealType == 'Janta') {
      selectedSet = selectedJanta;
    } else {
      return;
    }

    if (selectedSet.contains(id)) {
      selectedSet.remove(id);
    } else {
      if (selectedSet.length < 3) {
        selectedSet.add(id);
      } else {
        // Implemente um tratamento para lidar com o caso de seleção de mais de 3 alimentos.
      }
    }
  }

  void toggleUsuario(int id) {
    if (selectedUsuario.contains(id)) {
      selectedUsuario.remove(id);
    } else {
      if (selectedUsuario.length < 3) {
        selectedUsuario.add(id);
      } else {
        // Implemente um tratamento para lidar com o caso de seleção de mais de 3 alimentos.
      }
    }
  }

  void _exibeTodosRegistros() async {
    final data = await DatabaseHelper.exibeTodosCardapios();
    setState(() {
      _registros = data;
      _filteredRegistros = data;
      _isLoading = false;
    });
  }

  void _exibeTodosAlimentos() async {
    final data = await DatabaseHelper.exibeTodosAlimentos();
    setState(() {
      _alimentosCafe = data.where((element) => element['categoria'] == 'Café').toList();
      _alimentosAlmoco = data.where((element) => element['categoria'] == 'Almoço').toList();
      _alimentosJanta = data.where((element) => element['categoria'] == 'Janta').toList();
      _isLoading = false;
    });
  }

  void _exibeTodosUsuarios() async {
    final data = await DatabaseHelper.exibeTodosUsuarios();
    setState(() {
      _usuarios = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _exibeTodosRegistros();
    _exibeTodosAlimentos();
    _exibeTodosUsuarios();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredRegistros = _registros
          .where((registro) => registro['nome'].toLowerCase().contains(searchText))
          .toList();
    });
  }

  void _showForm(int? id) async {
    if (id != null) {
      final registroExistente = _registros.firstWhere((element) => element['id'] == id);
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          'Selecione o usuário:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: ListView.builder(
                            itemCount: _usuarios.length,
                            itemBuilder: (context, index) {
                              final usuario = _usuarios[index];
                              final isChecked = selectedUsuario.contains(usuario['id']);

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(File(usuario['foto'])),
                                ),
                                title: Text(usuario['nome']),
                                // subtitle: Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text('Categoria: ${usuario['categoria']}'),
                                //     Text('Tipo: ${usuario['tipo']}'),
                                //   ],
                                // ),
                                trailing: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      toggleUsuario(usuario['id']);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Selecione os alimentos para o café da manhã:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: ListView.builder(
                            itemCount: _alimentosCafe.length,
                            itemBuilder: (context, index) {
                              final alimento = _alimentosCafe[index];
                              final isChecked = selectedCafeDaManha.contains(alimento['id']);

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(File(alimento['foto'])),
                                ),
                                title: Text(alimento['nome']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Categoria: ${alimento['categoria']}'),
                                    Text('Tipo: ${alimento['tipo']}'),
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      toggleAlimento(alimento['id'], 'Almoço');
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Selecione os alimentos para o almoço:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: ListView.builder(
                            itemCount: _alimentosAlmoco.length,
                            itemBuilder: (context, index) {
                              final alimento = _alimentosAlmoco[index];
                              final isChecked = selectedAlmoco.contains(alimento['id']);

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(File(alimento['foto'])),
                                ),
                                title: Text(alimento['nome']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Categoria: ${alimento['categoria']}'),
                                    Text('Tipo: ${alimento['tipo']}'),
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      toggleAlimento(alimento['id'], 'Café');
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Selecione os alimentos para a janta:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: ListView.builder(
                            itemCount: _alimentosJanta.length,
                            itemBuilder: (context, index) {
                              final alimento = _alimentosJanta[index];
                              final isChecked = selectedJanta.contains(alimento['id']);

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(File(alimento['foto'])),
                                ),
                                title: Text(alimento['nome']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Categoria: ${alimento['categoria']}'),
                                    Text('Tipo: ${alimento['tipo']}'),
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      toggleAlimento(alimento['id'], 'Janta');
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 40, 106, 86)),
                          ),
                          onPressed: () async {
                            if (id == null) {
                              await _insereRegistro();
                            }

                            if (id != null) {
                              await _atualizaRegistro(id);
                            }

                            Navigator.of(context).pop();
                          },
                          child: Text(id == null ? 'Novo cardápio' : 'Atualizar'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _insereRegistro() async {
    print('Café da Manhã: $selectedCafeDaManha');
    print('Almoço: $selectedAlmoco');
    print('Janta: $selectedJanta');
    // Insira os alimentos selecionados no banco de dados como parte do novo cardápio.
    // await DatabaseHelper.insereCardapio(selectedCafeDaManha, selectedAlmoco, selectedJanta);
    _exibeTodosRegistros();
  }

  Future<void> _atualizaRegistro(int id) async {
    print('Café da Manhã: $selectedCafeDaManhaã');
    print('Almoço: $selectedAlmoco');
    print('Janta: $selectedJanta');
    // Atualize o cardápio existente com os novos alimentos selecionados.
    // await DatabaseHelper.atualizaCardapio(id, selectedCafeDaManhã, selectedAlmoco, selectedJanta);
    _exibeTodosRegistros();
  }

  void _removeRegistro(int id) async {
    await DatabaseHelper.removeCardapio(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Cardapio removido com sucesso!'),
    ));
    _exibeTodosRegistros();
  }
  
  void _compartilhaRegistro(int userId) {
    final usuario = _registros.firstWhere((element) => element['id'] == userId);
    final userName = usuario['nome'];

    final shareText = 'Nome: $userName\nIdade: anos';

    Share.share(shareText, subject: 'Dados do Usuário');
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
                Navigator.pop(context);
                _showForm(id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Deletar'),
              onTap: () {
                Navigator.pop(context);
                _removeRegistro(id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Compartilhar'),
              onTap: () {
                Navigator.pop(context);
                _compartilhaRegistro(id);
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
                    labelText: 'Buscar cardapios por nome',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredRegistros.length,
                  itemBuilder: (context, index) {
                    final cardapio = _filteredRegistros[index];
                    final String photoPath = cardapio['foto'];

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
                          title: Text(cardapio['nome']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Categoria: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${cardapio['categoria']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Tipo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${cardapio['tipo']}'),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () => _showOptionsModal(cardapio['id']),
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
