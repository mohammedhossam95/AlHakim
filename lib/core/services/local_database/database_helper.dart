import 'dart:io';

import 'package:alhakim/core/params/address_params.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '/core/utils/log_utils.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 2;
  static const String _tableName = 'adresses';
  static Future<void> initDB() async {
    if (_database != null) {
      return;
    } else {
      try {
        String path =
            '${Platform.isIOS ? getLibraryDirectory() : getDatabasesPath()}Sulalat.db';
        _database = await openDatabase(
          path,
          version: _version,
          onCreate: (Database database, int version) async {
            Log.d('database Created');
            if (Platform.isIOS) {
              await database.execute(
                'PRAGMA sqflite -- db_config_defensive_off',
              );
            }
            await database.execute(
              'CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY, '
              'method TEXT, '
              'city_id TEXT, '
              'area TEXT, '
              'building_no TEXT, '
              'floor TEXT, '
              'apartment TEXT, '
              'name TEXT, '
              'notes TEXT, '
              'latitude TEXT, '
              'longitude TEXT, '
              'address_details TEXT, '
              '"default" INTEGER'
              ')',
            );
          },
          onUpgrade: (Database database, int oldVersion, int newVersion) async {
            Log.d('database Upgrading from version $oldVersion to $newVersion');
            if (oldVersion < 2) {
              // Add the default column for version 2
              try {
                await database.execute(
                  'ALTER TABLE $_tableName ADD COLUMN "default" INTEGER',
                );
                Log.d('Added default column to $_tableName');
              } catch (e) {
                Log.e('Error adding default column: ${e.toString()}');
                // Column might already exist, ignore the error
              }
            }
          },
        );
        Log.d('database Created successfully');
      } catch (e) {
        Log.e('dataBase error ${e.toString()}');
      }
    }
  }

  static Future<int> insert(AddressParams params) async {
    Log.i('insert Function called');
    try {
      final id = await _database!.insert(_tableName, params.toMap());
      Log.i('insert Function Success with id: $id');
      return id;
    } catch (e) {
      Log.i('insert Function Error ${e.toString()}');
      rethrow; // Re-throw to let the repository handle the error properly
    }
  }

  static Future<int> deleteTableData() async {
    return await _database!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> getList() async {
    List<Map<String, dynamic>> maps = await _database!.query(_tableName);
    return maps;
  }

  static Future<void> deleteTable() async {
    try {
      String path =
          '${Platform.isIOS ? getLibraryDirectory() : getDatabasesPath()}mago.db';
      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (Database database, int version) async {
          Log.d('database DROP');

          await database.execute('DROP TABLE IF EXISTS $_tableName ');
        },
      );
      Log.d('database DROP successfully');
    } catch (e) {
      Log.e('dataBase DROP error ${e.toString()}');
    }
  }
}
