class Cardapio {
  final int id;
  final int idUsuario;
  final int cafe1Id;
  final int cafe2Id;
  final int cafe3Id;
  final int almoco1Id;
  final int almoco2Id;
  final int almoco3Id;
  final int almoco4Id;
  final int almoco5Id;
  final int janta1Id;
  final int janta2Id;
  final int janta3Id;
  final int janta4Id;

  Cardapio({
    required this.id,
    required this.idUsuario,
    required this.cafe1Id,
    required this.cafe2Id,
    required this.cafe3Id,
    required this.almoco1Id,
    required this.almoco2Id,
    required this.almoco3Id,
    required this.almoco4Id,
    required this.almoco5Id,
    required this.janta1Id,
    required this.janta2Id,
    required this.janta3Id,
    required this.janta4Id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_usuario': idUsuario,
      'cafe1_id': cafe1Id,
      'cafe2_id': cafe2Id,
      'cafe3_id': cafe3Id,
      'almoco1_id': almoco1Id,
      'almoco2_id': almoco2Id,
      'almoco3_id': almoco3Id,
      'almoco4_id': almoco4Id,
      'almoco5_id': almoco5Id,
      'janta1_id': janta1Id,
      'janta2_id': janta2Id,
      'janta3_id': janta3Id,
      'janta4_id': janta4Id,
    };
  }

  factory Cardapio.fromMap(Map<String, dynamic> map) {
    return Cardapio(
      id: map['id'],
      idUsuario: map['id_usuario'],
      cafe1Id: map['cafe1_id'],
      cafe2Id: map['cafe2_id'],
      cafe3Id: map['cafe3_id'],
      almoco1Id: map['almoco1_id'],
      almoco2Id: map['almoco2_id'],
      almoco3Id: map['almoco3_id'],
      almoco4Id: map['almoco4_id'],
      almoco5Id: map['almoco5_id'],
      janta1Id: map['janta1_id'],
      janta2Id: map['janta2_id'],
      janta3Id: map['janta3_id'],
      janta4Id: map['janta4_id'],
    );
  }
}
