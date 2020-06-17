// required package imports
import 'dart:async';
import 'package:architecture/data/db/dao/UserDao.dart';
import 'package:architecture/data/db/models/UserDbModel.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'AppDatabase.g.dart'; // the generated code will be there

@Database(version: 1, entities: [UserDbModel])
abstract class AppDatabase extends FloorDatabase  {

	UserDao get userDao;
}