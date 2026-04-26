import 'dart:convert';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteDatabaseHelper {
  static final _databaseName = 'alhakim.db';
  static final _databaseVersion = 1;

  static final _tableName = 'favorites';

  // Columns
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDescription = 'description';
  static const columnFinalPrice = 'final_price';
  static const columnOldPrice = 'old_price';
  static const columnFreeShipping = 'free_shipping';
  static const columnQuantity = 'quantity';
  static const columnWeight = 'weight';
  static const columnCategoryId = 'category_id';
  static const columnImage = 'image';
  static const columnCuttingOptions = 'cutting_options';
  static const columnWrappingOptions = 'wrapping_options';
  static const columnForceCutting = 'force_choose_cutting';
  static const columnForceWrapping = 'force_choose_wrapping';
  static const columnIsFavorite = 'is_favorite';
  FavoriteDatabaseHelper._privateConstructor();
  static final FavoriteDatabaseHelper instance =
      FavoriteDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT,
            $columnDescription TEXT,
            $columnFinalPrice REAL,
            $columnOldPrice REAL,
            $columnFreeShipping INTEGER,
            $columnQuantity INTEGER,
            $columnWeight INTEGER,
            $columnCategoryId INTEGER,
            $columnImage TEXT,
            $columnCuttingOptions TEXT,
            $columnWrappingOptions TEXT,
            $columnForceCutting INTEGER,
            $columnForceWrapping INTEGER,
            $columnIsFavorite INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Insert / Replace favorite
  Future<void> insertFavoriteItem(dynamic product) async {
    final db = await database;

    await db.insert(_tableName, {
      columnId: product.id,
      columnName: product.name,
      columnDescription: product.description,
      columnFinalPrice: product.finalPrice,
      columnOldPrice: product.oldPrice,
      columnFreeShipping: product.freeShipping == true ? 1 : 0,
      columnQuantity: product.quantity,
      columnWeight: product.weight,
      columnCategoryId: product.category?.id,
      columnImage: product.image,
      columnCuttingOptions: jsonEncode(
        product.cuttingOptions?.map((e) => (e as dynamic).toJson()).toList(),
      ),
      columnWrappingOptions: jsonEncode(
        product.wrappingOptions?.map((e) => (e as dynamic).toJson()).toList(),
      ),
      columnForceCutting: product.forceChooseCuttingOption,
      columnForceWrapping: product.forceChooseWrappingOption,
      columnIsFavorite: 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    log('Product ${product.id} saved to favorites');
  }

  Future<void> deleteFavoriteItem(int productId) async {
    final db = await database;
    await db.delete(_tableName, where: '$columnId = ?', whereArgs: [productId]);
  }

  Future<bool> isItemInFavorites(int productId) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: '$columnId = ?',
      whereArgs: [productId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getAllFavoriteItems() async {
    final db = await database;
    return db.query(_tableName);
  }
}
