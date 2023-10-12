import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Database {
  // id: Chave primária do registro
  // title, description: nome e descrição do registro
  // created_at: Data e hora da criação do registro. Isso é retornado pelo banco de dados
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'banco.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Insere um novo registro
  static Future<int> insereRegistro(String title, String? descrption) async {
    final database = await Database.database();

    final data = {'title': title, 'description': descrption};

    final id = await database.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Retorna todos os registros da tabela
  static Future<List<Map<String, dynamic>>> exibeTodosRegistros() async {
    final database = await Database.database();
    return database.query('items', orderBy: "id");
  }

  // Retorna um único registro através de um ID
  // Esse método não foi usado mas deixado aqui para consulta
  static Future<List<Map<String, dynamic>>> retornaRegistro(int id) async {
    final database = await Database.database();
    return database.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Atualiza um registro
  static Future<int> atualizaRegistro(
      int id, String title, String? descrption) async {
    final database = await Database.database();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await database.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Remove um registro
  static Future<void> removeRegistro(int id) async {
    final database = await Database.database();
    try {
      await database.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Ocorreu algum erro ao remover o registro: $err");
    }
  }
}
