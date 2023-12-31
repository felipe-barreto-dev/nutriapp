import 'dart:io';

import 'package:nutriapp/helpers/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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
    if (mealType == 'Café') {
      if (selectedCafeDaManha.contains(id)) {
        selectedCafeDaManha.remove(id);
      } else {
        if (selectedCafeDaManha.length < 3) {
          selectedCafeDaManha.add(id);
        } else {
          // Implemente um tratamento para lidar com o caso de seleção de mais de 3 alimentos.
        }
      }
    } else if (mealType == 'Almoço') {
      if (selectedAlmoco.contains(id)) {
        selectedAlmoco.remove(id);
      } else {
        if (selectedAlmoco.length < 5) {
          selectedAlmoco.add(id);
        } else {
          // Implemente um tratamento para lidar com o caso de seleção de mais de 3 alimentos.
        }
      }
    } else if (mealType == 'Janta') {
      if (selectedJanta.contains(id)) {
        selectedJanta.remove(id);
      } else {
        if (selectedJanta.length < 4) {
          selectedJanta.add(id);
        } else {
          // Implemente um tratamento para lidar com o caso de seleção de mais de 3 alimentos.
        }
      }
    } else {
      return;
    }
  }

  void toggleUsuario(int id) {
    if (selectedUsuario.contains(id)) {
      selectedUsuario.remove(id);
    } else {
      selectedUsuario.remove(selectedUsuario);
      selectedUsuario.add(id);
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
      _alimentosCafe =
          data.where((element) => element['categoria'] == 'Café').toList();
      _alimentosAlmoco =
          data.where((element) => element['categoria'] == 'Almoço').toList();
      _alimentosJanta =
          data.where((element) => element['categoria'] == 'Janta').toList();
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
          .where((registro) => _usuarios
              .firstWhere(
                  (element) => registro['id_usuario'] == element['id'])['nome']
              .toLowerCase()
              .contains(searchText))
          .toList();
    });
  }

  void _showForm(int? id) async {
    if (id != null) {
      final registroExistente =
          _registros.firstWhere((element) => element['id'] == id);

      selectedUsuario.add(registroExistente['id_usuario']);

      selectedCafeDaManha.add(registroExistente['cafe1_id']);
      selectedCafeDaManha.add(registroExistente['cafe2_id']);
      selectedCafeDaManha.add(registroExistente['cafe3_id']);

      selectedAlmoco.add(registroExistente['almoco1_id']);
      selectedAlmoco.add(registroExistente['almoco2_id']);
      selectedAlmoco.add(registroExistente['almoco3_id']);
      selectedAlmoco.add(registroExistente['almoco4_id']);
      selectedAlmoco.add(registroExistente['almoco5_id']);

      selectedJanta.add(registroExistente['janta1_id']);
      selectedJanta.add(registroExistente['janta2_id']);
      selectedJanta.add(registroExistente['janta3_id']);
      selectedJanta.add(registroExistente['janta4_id']);
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
                    padding: const EdgeInsets.all(7.0),
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
                              final isChecked =
                                  selectedUsuario.contains(usuario['id']);

                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: usuario['foto'].isNotEmpty
                                      ? FileImage(File(usuario['foto']))
                                      : null,
                                  child: usuario['foto'].isEmpty
                                      ? const Icon(Icons.person,
                                          size: 30, color: Colors.white)
                                      : null,
                                ),
                                title: Text(usuario['nome']),
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
                              final isChecked =
                                  selectedCafeDaManha.contains(alimento['id']);

                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: alimento['foto'].isNotEmpty
                                      ? FileImage(File(alimento['foto']))
                                      : null,
                                  child: alimento['foto'].isEmpty
                                      ? const Icon(Icons.dinner_dining,
                                          size: 30, color: Colors.white)
                                      : null,
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
                              final isChecked =
                                  selectedAlmoco.contains(alimento['id']);

                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: alimento['foto'].isNotEmpty
                                      ? FileImage(File(alimento['foto']))
                                      : null,
                                  child: alimento['foto'].isEmpty
                                      ? const Icon(Icons.dinner_dining,
                                          size: 30, color: Colors.white)
                                      : null,
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
                              final isChecked =
                                  selectedJanta.contains(alimento['id']);

                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: alimento['foto'].isNotEmpty
                                      ? FileImage(File(alimento['foto']))
                                      : null,
                                  child: alimento['foto'].isEmpty
                                      ? const Icon(Icons.dinner_dining,
                                          size: 30, color: Colors.white)
                                      : null,
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
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 40, 106, 86)),
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
                          child:
                              Text(id == null ? 'Novo cardápio' : 'Atualizar'),
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
    List<int> usuarioList = selectedUsuario.toList();
    List<int> cafeDaManhaList = selectedCafeDaManha.toList();
    List<int> almocoList = selectedAlmoco.toList();
    List<int> jantaList = selectedJanta.toList();

    // Insira os alimentos selecionados no banco de dados como parte do novo cardápio.
    await DatabaseHelper.insereCardapio(
        usuarioList[0],
        cafeDaManhaList[0],
        cafeDaManhaList[1],
        cafeDaManhaList[2],
        almocoList[0],
        almocoList[1],
        almocoList[2],
        almocoList[3],
        almocoList[4],
        jantaList[0],
        jantaList[1],
        jantaList[2],
        jantaList[3]);
    _exibeTodosRegistros();
  }

  Future<void> _atualizaRegistro(int id) async {
    List<int> usuarioList = selectedUsuario.toList();
    List<int> cafeDaManhaList = selectedCafeDaManha.toList();
    List<int> almocoList = selectedAlmoco.toList();
    List<int> jantaList = selectedJanta.toList();
    // Atualize o cardápio existente com os novos alimentos selecionados.
    await DatabaseHelper.atualizaCardapio(
        id,
        usuarioList[0],
        cafeDaManhaList[0],
        cafeDaManhaList[1],
        cafeDaManhaList[2],
        almocoList[0],
        almocoList[1],
        almocoList[2],
        almocoList[3],
        almocoList[4],
        jantaList[0],
        jantaList[1],
        jantaList[2],
        jantaList[3]);
    _exibeTodosRegistros();
  }

  void _removeRegistro(int id) async {
    await DatabaseHelper.removeCardapio(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Cardapio removido com sucesso!'),
    ));
    _exibeTodosRegistros();
  }

  void _compartilhaRegistro(int cardapioId) {
    final cardapio =
        _registros.firstWhere((element) => element['id'] == cardapioId);
    final usuarioId = cardapio['id_usuario'];
    final cafe1Id = cardapio['cafe1_id'];
    final cafe2Id = cardapio['cafe2_id'];
    final cafe3Id = cardapio['cafe3_id'];
    final almoco1Id = cardapio['almoco1_id'];
    final almoco2Id = cardapio['almoco2_id'];
    final almoco3Id = cardapio['almoco3_id'];
    final almoco4Id = cardapio['almoco4_id'];
    final almoco5Id = cardapio['almoco5_id'];
    final janta1Id = cardapio['janta1_id'];
    final janta2Id = cardapio['janta2_id'];
    final janta3Id = cardapio['janta3_id'];
    final janta4Id = cardapio['janta4_id'];

    final usuario =
        _usuarios.firstWhere((element) => element['id'] == usuarioId);

    final cafe1 =
        _alimentosCafe.firstWhere((element) => element['id'] == cafe1Id);
    final cafe2 =
        _alimentosCafe.firstWhere((element) => element['id'] == cafe2Id);
    final cafe3 =
        _alimentosCafe.firstWhere((element) => element['id'] == cafe3Id);

    final almoco1 =
        _alimentosAlmoco.firstWhere((element) => element['id'] == almoco1Id);
    final almoco2 =
        _alimentosAlmoco.firstWhere((element) => element['id'] == almoco2Id);
    final almoco3 =
        _alimentosAlmoco.firstWhere((element) => element['id'] == almoco3Id);
    final almoco4 =
        _alimentosAlmoco.firstWhere((element) => element['id'] == almoco4Id);
    final almoco5 =
        _alimentosAlmoco.firstWhere((element) => element['id'] == almoco5Id);

    final janta1 =
        _alimentosJanta.firstWhere((element) => element['id'] == janta1Id);
    final janta2 =
        _alimentosJanta.firstWhere((element) => element['id'] == janta2Id);
    final janta3 =
        _alimentosJanta.firstWhere((element) => element['id'] == janta3Id);
    final janta4 =
        _alimentosJanta.firstWhere((element) => element['id'] == janta4Id);

    final shareText = 'Nome: ${usuario['nome']}'
        '\nOpções para o café da manhã:\n${cafe1['nome']}\n${cafe2['nome']}\n${cafe3['nome']}'
        '\nOpções para o almoço:\n${almoco1['nome']}\n${almoco2['nome']}\n${almoco3['nome']}\n${almoco4['nome']}\n${almoco5['nome']}'
        '\nOpções para o jantar:\n${janta1['nome']}\n${janta2['nome']}\n${janta3['nome']}\n${janta4['nome']}';

    Share.share(shareText, subject: 'Dados do Cardápio');
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
                      return Card(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        margin: const EdgeInsets.all(7.5),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 158, 209, 197),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: const Color.fromARGB(255, 255, 255, 255),
                            title: Text(_usuarios.firstWhere((element) =>
                                element['id'] ==
                                cardapio['id_usuario'])['nome']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                const Row(
                                  children: [
                                    Text('Opções para o café da manhã: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosCafe.firstWhere((element) => element['id'] == cardapio['cafe1_id'])['nome']}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosCafe.firstWhere((element) => element['id'] == cardapio['cafe2_id'])['nome']}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosCafe.firstWhere((element) => element['id'] == cardapio['cafe3_id'])['nome']}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Row(
                                  children: [
                                    Text('Opções para o almoço: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosAlmoco.firstWhere((element) => element['id'] == cardapio['almoco1_id'])['nome']}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosAlmoco.firstWhere((element) => element['id'] == cardapio['almoco2_id'])['nome'] ?? 'Alimento não encontrado'}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosAlmoco.firstWhere((element) => element['id'] == cardapio['almoco3_id'])['nome'] ?? 'Alimento não encontrado'}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosAlmoco.firstWhere((element) => element['id'] == cardapio['almoco4_id'])['nome'] ?? 'Alimento não encontrado'}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosAlmoco.firstWhere((element) => element['id'] == cardapio['almoco5_id'])['nome'] ?? 'Alimento não encontrado'}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Row(
                                  children: [
                                    Text('Opções para o jantar: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosJanta.firstWhere((element) => element['id'] == cardapio['janta1_id'])['nome'] ?? 'Alimento não encontrado'}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosJanta.firstWhere((element) => element['id'] == cardapio['janta2_id'])['nome'] ?? 'Alimento não encontrado'}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosJanta.firstWhere((element) => element['id'] == cardapio['janta3_id'])['nome'] ?? 'Alimento não encontrado'}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                        '${_alimentosJanta.firstWhere((element) => element['id'] == cardapio['janta4_id'])['nome'] ?? 'Alimento não encontrado'}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () =>
                                  _showOptionsModal(cardapio['id']),
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
