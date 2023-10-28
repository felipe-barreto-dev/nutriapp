class Usuario {
  final int id;
  final String nome;
  final DateTime dataNascimento;
  final String foto;

  Usuario({
    required this.id,
    required this.nome,
    required this.dataNascimento,
    required this.foto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data_nascimento': dataNascimento.toIso8601String(),
      'foto': foto,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      dataNascimento: DateTime.parse(map['data_nascimento']),
      foto: map['foto'],
    );
  }
}
