
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBService {
  DBService._();

  static DBService? _instance;

  static DBService get instance{
    _instance ??= DBService._();
    return _instance!;
  }

  /// init db
  Database? database;

  initDB() async {
    try {
      var databaseFactory = databaseFactoryFfi;
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "delivery_db");
      databaseFactory.setDatabasesPath(path);
      database = await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
          version: 2,
          onCreate: (db , version){
            try {
              Batch batch = db.batch();
              batch.execute('''
                CREATE TABLE bill (
                  id INTEGER NOT NULL PRIMARY KEY,
                  sendUserName TEXT NOT NULL,
                  sendUserPhone TEXT NOT NULL,
                  getUserName TEXT NOT NULL,
                  getUserPhone TEXT NOT NULL,
                  getUserAddress TEXT NOT NULL,
                  getCount TEXT NOT NULL,
                  paymentMethod TEXT NOT NULL,
                  status INTEGER NOT NULL,
                  freight TEXT NOT NULL,
                  createTime INTEGER NOT NULL,
                  sn TEXT NOT NULL,
                  printBillNum TEXT(10) DEFAULT 1
                )''');
              batch.execute('''
                CREATE TABLE user (
                  id INTEGER NOT NULL PRIMARY KEY,
                  UserName TEXT NOT NULL,
                  UserPhone TEXT NOT NULL,
                  UserAddress TEXT,
                  createTime INTEGER NOT NULL
                )''');
              batch.commit();
            } catch (err) {
              throw (err);
            }
          },
        onUpgrade: (Database db, int oldVersion, int newVersion){
          if(oldVersion  < newVersion){
            try {
              Batch batch = db.batch();
              batch.execute('ALTER TABLE bill ADD printBillNum TEXT(10) DEFAULT 1');
              batch.commit();
            } catch (err) {
              throw (err);
            }
          }
        }
      ));
    } catch (err) {
      throw (err);
    }
  }



}