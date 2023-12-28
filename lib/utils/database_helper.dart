// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:stock_management/utils/base_url_domain.dart';

// class DatabaseHelper {
//   // Singleton instance of DatabaseHelper
//   static DatabaseHelper _databaseHelper = DatabaseHelper();

//   // private vari. holds the reference to SQ lite database
//   static Database? _database;

//   // factory constructor return singleton instance
//   factory DatabaseHelper() {
//     // if (_databaseHelper == null) {
//     //   _databaseHelper = DatabaseHelper._createInstance();
//     // }
//     return _databaseHelper ??= DatabaseHelper._createInstance();
//   }

//   //private constructor for Singlrton pattern
//   DatabaseHelper._createInstance();

//   //getter for Database instance
//   Future<Database> get database async {
//     //if database already initilize return it
//     if (_database != null) {
//       return _database!;
//     }
//     //if database not initilize then call initDatabase to create and open it
//     _database = await initilizeDatabase();
//     return _database!;
//   }

//   // initialize SqLite Database
//   Future<Database> initilizeDatabase() async {
//     // get the path SQLite Database file
//     String databasePath = await getDatabasesPath();
//     log('Database Path : $databasePath');

//     var newPath = join(databasePath, "$dbName");

//     //To check Database Exist for this path
//     var exists = await databaseExists(newPath);
//     if (!exists) {
//       try {
//         await Directory(dirname(newPath)).create(recursive: true);

//         //open the Database for specified path
//         // _database =
//         //     await openDatabase(newPath, version: 1, onCreate: _onCreate);
//       } catch (e) {
//         log('Catch error : $e');
//       }
//       //copy from asset
//       ByteData data = await rootBundle.load(join("assets", "$dbName"));
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//       await File(newPath).writeAsBytes(bytes, flush: true);
//     } else {
//       //open database already exists
//       // _database = await openDatabase(newPath, version: 1);
//       print('Opening  existing Database');
//     }

//     var database = await openDatabase(
//       newPath,
//       version: 1,
//       onCreate: _oncreate, //_oncreate,
//       onUpgrade: _onUpgrade, //onUpgrade,
//       readOnly: false,
//     );
//     return database;
//   }

//   //Upgrade function
//   void _onUpgrade(
//     Database database,
//     int oldVersion,
//     int newVersion,
//   ) {
//     if (newVersion > oldVersion) {}
//   }

//   //Oncreate function
//   void _oncreate(Database db, int version) async {
//     // create Table and perform any setup here

//     await db.execute('');
//   }
// }
