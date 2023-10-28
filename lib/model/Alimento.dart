class Alimento {
  final int id;
  final String nome;
  final String foto;
  final String categoria;
  final String tipo;

  Alimento({
    required this.id,
    required this.nome,
    required this.foto,
    required this.categoria,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'foto': foto,
      'categoria': categoria,
      'tipo': tipo,
    };
  }

  factory Alimento.fromMap(Map<String, dynamic> map) {
    return Alimento(
      id: map['id'],
      nome: map['nome'],
      foto: map['foto'],
      categoria: map['categoria'],
      tipo: map['tipo'],
    );
  }
}
