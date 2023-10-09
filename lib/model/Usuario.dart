class Usuario {
  final String _nome = "";
  final DateTime _dataNascimento = DateTime(1);
  final String _foto = "";

  get nome {
    return _nome;
  }

  get dataNascimento {
    return _dataNascimento;
  }

  get foto {
    return _foto;
  }

  Usuario.criar({required String nome, required DateTime dataNascimento, required String foto}) {
    //teste
  }

}
