import 'package:flutter/material.dart';
import 'package:nutriapp/helpers/database_helper.dart';

class CadastroCardapio extends StatefulWidget {
  const CadastroCardapio({Key? key}) : super(key: key);

  @override
  CadastroCardapioState createState() => CadastroCardapioState();
}

class CadastroCardapioState extends State<CadastroCardapio> {
  List<Map<String, dynamic>> _registros = [];
  List<Map<String, dynamic>> _alimentos = [];
  List<Map<String, dynamic>> _usuarios = [];
  bool _isLoading = false;
  int id_usuario = 0;
  int cafe1 = 0;
  int cafe2 = 0;
  int cafe3 = 0;
  int almoco1 = 0;
  int almoco2 = 0;
  int almoco3 = 0;
  int almoco4 = 0;
  int almoco5 = 0;
  int janta1 = 0;
  int janta2 = 0;
  int janta3 = 0;
  int janta4 = 0;

  List<String> categorias = ['Café', 'Almoço', 'Janta'];

  int _getInitialValueForCategoria(String categoria) {
    final alimentosFiltrados = _alimentos.where((alimento) {
      String categoriaAlimento = alimento['categoria']; // Supondo que a categoria esteja em uma chave chamada 'categoria'
      return categoriaAlimento == categoria;
    }).toList();

    return alimentosFiltrados.isNotEmpty ? alimentosFiltrados[0]['id'] : 0;
  }

  @override
  void initState() {
    super.initState();
    _exibeTodosRegistros();
    _exibeTodosAlimentos();
    _exibeTodosUsuarios();

    cafe1 = _getInitialValueForCategoria('Café');
    cafe2 = _getInitialValueForCategoria('Café');
    cafe3 = _getInitialValueForCategoria('Café');
    almoco1 = _getInitialValueForCategoria('Almoço');
    almoco2 = _getInitialValueForCategoria('Almoço');
    almoco3 = _getInitialValueForCategoria('Almoço');
    almoco4 = _getInitialValueForCategoria('Almoço');
    almoco5 = _getInitialValueForCategoria('Almoço');
    janta1 = _getInitialValueForCategoria('Janta');
    janta2 = _getInitialValueForCategoria('Janta');
    janta3 = _getInitialValueForCategoria('Janta');
    janta4 = _getInitialValueForCategoria('Janta');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCafeSelector(String label, int selectedValue, String categoria, void Function(int?) onChanged) {
    List<Map<String, dynamic>> alimentosFiltrados = _alimentos.where((alimento) {
      String categoriaAlimento = alimento['categoria']; // Supondo que a categoria esteja em uma chave chamada 'categoria'
      return categoriaAlimento == categoria;
    }).toList();

    // Adicione a opção vazia ou "Selecione uma opção" como o primeiro item
    alimentosFiltrados.insert(0, {
      'id': 0,
      'nome': 'Selecione uma opção',
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontSize: 16)),
        DropdownButton<int>(
          value: selectedValue,
          items: alimentosFiltrados.map((alimento) {
            return DropdownMenuItem<int>(
              value: alimento['id'],
              child: Text(alimento['nome']),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _exibeTodosRegistros() async {
    final data = await DatabaseHelper.exibeTodosCardapios();
    setState(() {
      _registros = data;
      _isLoading = false;
    });
  }

  void _exibeTodosAlimentos() async {
    final data = await DatabaseHelper.exibeTodosAlimentos();
    setState(() {
      _alimentos = data;
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

  void _showForm(int? id) async {
    if (id != null) {
      final registroExistente = _registros.firstWhere((element) => element['id'] == id);
      id_usuario = registroExistente['id_usuario'];
      cafe1 = registroExistente['cafe1_id'];
      cafe2 = registroExistente['cafe2_id'];
      cafe3 = registroExistente['cafe3_id'];
      almoco1 = registroExistente['almoco1_id'];
      almoco2 = registroExistente['almoco2_id'];
      almoco3 = registroExistente['almoco3_id'];
      almoco4 = registroExistente['almoco4_id'];
      almoco5 = registroExistente['almoco5_id'];
      janta1 = registroExistente['janta1_id'];
      janta2 = registroExistente['janta2_id'];
      janta3 = registroExistente['janta3_id'];
      janta4 = registroExistente['janta4_id'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              DropdownButton<int>(
                value: id_usuario,
                items: _usuarios.map((user) {
                  return DropdownMenuItem<int>(
                    value: user['id'],
                    child: Text(user['nome']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    id_usuario = newValue!;
                  });
                },
              ),
                SizedBox(height: 20),
                Text('Café', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildCafeSelector('Café 1', cafe1, 'Café', (newValue) {
                  setState(() {
                    cafe1 = newValue!;
                  });
                }),
                _buildCafeSelector('Café 2', cafe2, 'Café', (newValue) {
                  setState(() {
                    cafe2 = newValue!;
                  });
                }),
                _buildCafeSelector('Café 3', cafe3, 'Café', (newValue) {
                  setState(() {
                    cafe3 = newValue!;
                  });
                }),
                SizedBox(height: 20),
                Text('Almoço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildCafeSelector('Almoço 1', almoco1, 'Almoço', (newValue) {
                  setState(() {
                    almoco1 = newValue!;
                  });
                }),
                _buildCafeSelector('Almoço 2', almoco2, 'Almoço', (newValue) {
                  setState(() {
                    almoco2 = newValue!;
                  });
                }),
                _buildCafeSelector('Almoço 3', almoco3, 'Almoço', (newValue) {
                  setState(() {
                    almoco3 = newValue!;
                  });
                }),
                _buildCafeSelector('Almoço 4', almoco4, 'Almoço', (newValue) {
                  setState(() {
                    almoco4 = newValue!;
                  });
                }),
                _buildCafeSelector('Almoço 5', almoco5, 'Almoço', (newValue) {
                  setState(() {
                    almoco5 = newValue!;
                  });
                }),
                SizedBox(height: 20),
                Text('Janta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildCafeSelector('Janta 1', janta1, 'Janta', (newValue) {
                  setState(() {
                    janta1 = newValue!;
                  });
                }),
                _buildCafeSelector('Janta 2', janta2, 'Janta', (newValue) {
                  setState(() {
                    janta2 = newValue!;
                  });
                }),
                _buildCafeSelector('Janta 3', janta3, 'Janta', (newValue) {
                  setState(() {
                    janta3 = newValue!;
                  });
                }),
                _buildCafeSelector('Janta 4', janta4, 'Janta', (newValue) {
                  setState(() {
                    janta4 = newValue!;
                  });
                }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (id == null) {
                      await _insereRegistro();
                    }

                    if (id != null) {
                      await _atualizaRegistro(id);
                    }

                    cafe1 = 0;
                    cafe2 = 0;
                    cafe3 = 0;
                    almoco1 = 0;
                    almoco2 = 0;
                    almoco3 = 0;
                    almoco4 = 0;
                    almoco5 = 0;
                    janta1 = 0;
                    janta2 = 0;
                    janta3 = 0;
                    janta4 = 0;

                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Novo alimento' : 'Atualizar'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _insereRegistro() async {
    await DatabaseHelper.insereCardapio(
      id_usuario,
      cafe1,
      cafe2,
      cafe3,
      almoco1,
      almoco2,
      almoco3,
      almoco4,
      almoco5,
      janta1,
      janta2,
      janta3,
      janta4,
    );
    _exibeTodosRegistros();
  }

  Future<void> _atualizaRegistro(int id) async {
    await DatabaseHelper.atualizaCardapio(
      id,
      id_usuario,
      cafe1,
      cafe2,
      cafe3,
      almoco1,
      almoco2,
      almoco3,
      almoco4,
      almoco5,
      janta1,
      janta2,
      janta3,
      janta4,
    );
    _exibeTodosRegistros();
  }

  void _removeRegistro(int id) async {
    await DatabaseHelper.removeCardapio(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Cardápio removido com sucesso!'),
    ));
    _exibeTodosRegistros();
  }

  // Função para obter o nome do alimento com base no ID
  String getNomeAlimento(int id) {
    final alimento = _alimentos.firstWhere((element) => element['id'] == id, orElse: () => <String, dynamic>{});
    return alimento['nome'] ?? 'Alimento não encontrado';
  }

  // Função para criar uma seção de refeição
  Widget buildRefeicao(String title, List<int> refeicaoIDs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        for (int id in refeicaoIDs) Text(getNomeAlimento(id), style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
      ],
    );
  }

  List<int> dynamicListToIntList(List<dynamic> dynamicList) {
    return dynamicList.cast<int>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _registros.length,
              itemBuilder: (context, index) {
                final registro = _registros[index];

                final cafeIDs = dynamicListToIntList([registro['cafe1_id'], registro['cafe2_id'], registro['cafe3_id']]);
                final almocoIDs = dynamicListToIntList([registro['almoco1_id'], registro['almoco2_id'], registro['almoco3_id'], registro['almoco4_id'], registro['almoco5_id']]);
                final jantaIDs = dynamicListToIntList([registro['janta1_id'], registro['janta2_id'], registro['janta3_id'], registro['janta4_id']]);

                return Card(
                  color: Color.fromARGB(255, 237, 250, 211),
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Text('Cardápio de ${_usuarios.firstWhere((element) => element['id'] == registro['id_usuario'])['nome']}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        buildRefeicao('Café', cafeIDs),
                        buildRefeicao('Almoço', almocoIDs),
                        buildRefeicao('Janta', jantaIDs),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(registro['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeRegistro(registro['id']),
                          ),
                        ],
                      ),
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
