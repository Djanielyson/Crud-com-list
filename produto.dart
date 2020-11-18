import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tabelaProduto = "tabelaProduto";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String marcacolum = "marcaColum";
final String precoColum = "precoColum";
final String quantidadeColum = "quantidadecolum";

class ProdutoHelper {
  static final ProdutoHelper _instance = ProdutoHelper.internal();

  factory ProdutoHelper() => _instance;

  ProdutoHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "produtosnew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $tabelaProduto($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $marcacolum TEXT,"
          "$precoColum TEXT, $quantidadeColum TEXT)");
    });
  }

  Future<Produto> saveProduto(Produto produto) async {
    Database dbProduto = await db;
    produto.id = await dbProduto.insert(tabelaProduto, produto.toMap());
    return produto;
  }

  Future<Produto> getProduto(int id) async {
    Database dbProduto = await db;
    List<Map> maps = await dbProduto.query(tabelaProduto,
        columns: [
          idColumn,
          nameColumn,
          marcacolum,
          precoColum,
          quantidadeColum
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Produto.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteProduto(int id) async {
    Database dbProduto = await db;
    return await dbProduto
        .delete(tabelaProduto, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateProduto(Produto produto) async {
    Database dbProduto = await db;
    return await dbProduto.update(tabelaProduto, produto.toMap(),
        where: "$idColumn = ?", whereArgs: [produto.id]);
  }

  Future<List> getAllProdutos() async {
    Database dbProduto = await db;
    List listMap = await dbProduto.rawQuery("SELECT * FROM $tabelaProduto");
    List<Produto> listProduto = List();
    for (Map m in listMap) {
      listProduto.add(Produto.fromMap(m));
    }
    return listProduto;
  }

  Future<int> getNumber() async {
    Database dbProduto = await db;
    return Sqflite.firstIntValue(
        await dbProduto.rawQuery("SELECT COUNT(*) FROM $tabelaProduto"));
  }

  Future close() async {
    Database dbProduto = await db;
    dbProduto.close();
  }
}

class Produto {
  int id;
  String name;
  String marca;
  String preco;
  String quantidade;

  Produto();

  Produto.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    marca = map[marcacolum];
    preco = map[precoColum];
    quantidade = map[quantidadeColum];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      marcacolum: marca,
      precoColum: preco,
      quantidadeColum: quantidade
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Produto(id: $id, name: $name, marca: $marca, preço: $preco, quantidade: $quantidade)";
  }
}
