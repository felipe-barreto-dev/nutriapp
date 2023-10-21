import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE usuario(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        data_nascimento DATE,
        foto TEXT
      )
      """);
    await database.execute("""CREATE TABLE alimentos(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        foto TEXT,
        categoria TEXT,
        tipo TEXT
      )
      """);

    await database.execute("""CREATE TABLE cardapio(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        id_usuario INTEGER,
        cafe1_id INTEGER,
        cafe2_id INTEGER,
        cafe3_id INTEGER,
        almoco1_id INTEGER,
        almoco2_id INTEGER,
        almoco3_id INTEGER,
        almoco4_id INTEGER,
        almoco5_id INTEGER,
        janta1_id INTEGER,
        janta2_id INTEGER,
        janta3_id INTEGER,
        janta4_id INTEGER,
        FOREIGN KEY (id_usuario) REFERENCES usuario(id),
        FOREIGN KEY (cafe1_id) REFERENCES alimentos(id),
        FOREIGN KEY (cafe2_id) REFERENCES alimentos(id),
        FOREIGN KEY (cafe3_id) REFERENCES alimentos(id),
        FOREIGN KEY (almoco1_id) REFERENCES alimentos(id),
        FOREIGN KEY (almoco2_id) REFERENCES alimentos(id),
        FOREIGN KEY (almoco3_id) REFERENCES alimentos(id),
        FOREIGN KEY (almoco4_id) REFERENCES alimentos(id),
        FOREIGN KEY (almoco5_id) REFERENCES alimentos(id),
        FOREIGN KEY (janta1_id) REFERENCES alimentos(id),
        FOREIGN KEY (janta2_id) REFERENCES alimentos(id),
        FOREIGN KEY (janta3_id) REFERENCES alimentos(id),
        FOREIGN KEY (janta4_id) REFERENCES alimentos(id)
      )
      """);
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'nutriapp.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> insereUsuario(String nome, DateTime dataNascimento, String foto) async {
    final database = await DatabaseHelper.database();

    final data = {
      'nome': nome,
      'data_nascimento': dataNascimento.toIso8601String(), // Convert DateTime to ISO 8601 format
      'foto': foto,
    };

    final id = await database.insert('usuario', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> atualizaUsuario(int id, String nome, DateTime dataNascimento, String foto) async {
    final database = await DatabaseHelper.database();

    final data = {
      'nome': nome,
      'data_nascimento': dataNascimento.toIso8601String(), // Convert DateTime to ISO 8601 format
      'foto': foto,
    };

    final result = await database.update('usuario', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<List<Map<String, dynamic>>> exibeTodosUsuarios() async {
    final database = await DatabaseHelper.database();
    return database.query('usuario', orderBy: "id");
  }

  static Future<Map<String, dynamic>?> retornaUsuario(int id) async {
    final database = await DatabaseHelper.database();
    final results = await database.query('usuario', where: "id = ?", whereArgs: [id], limit: 1);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  static Future<void> removeUsuario(int id) async {
    final database = await DatabaseHelper.database();
    try {
      await database.delete("usuario", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Ocorreu algum erro ao remover o usuário: $err");
    }
  }

  static Future<int> insereAlimento(String nome, String foto, String categoria, String tipo) async {
    final database = await DatabaseHelper.database();

    final data = {
      'nome': nome,
      'foto': foto,
      'categoria': categoria,
      'tipo': tipo,
    };

    final id = await database.insert('alimentos', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> exibeTodosAlimentos() async {
    final database = await DatabaseHelper.database();
    return database.query('alimentos', orderBy: "id");
  }

  static Future<Map<String, dynamic>?> retornaAlimento(int id) async {
    final database = await DatabaseHelper.database();
    final results = await database.query('alimentos', where: "id = ?", whereArgs: [id], limit: 1);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  static Future<int> atualizaAlimento(int id, String nome, String foto, String categoria, String tipo) async {
    final database = await DatabaseHelper.database();

    final data = {
      'nome': nome,
      'foto': foto,
      'categoria': categoria,
      'tipo': tipo,
    };

    final result = await database.update('alimentos', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> removeAlimento(int id) async {
    final database = await DatabaseHelper.database();
    try {
      await database.delete("alimentos", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Ocorreu algum erro ao remover o alimento: $err");
    }
  }

  static Future<int> insereCardapio(
      int idUsuario,
      int cafe1Id,
      int cafe2Id,
      int cafe3Id,
      int almoco1Id,
      int almoco2Id,
      int almoco3Id,
      int almoco4Id,
      int almoco5Id,
      int janta1Id,
      int janta2Id,
      int janta3Id,
      int janta4Id,
    ) async {
    final database = await DatabaseHelper.database();

    final data = {
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

    final id = await database.insert('cardapio', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Obtém as informações do cardápio
  static Future<Map<String, dynamic>?> retornaCardapio(int idCardapio) async {
    final database = await DatabaseHelper.database();
    final results = await database.query('cardapio', where: "id = ?", whereArgs: [idCardapio], limit: 1);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

}
