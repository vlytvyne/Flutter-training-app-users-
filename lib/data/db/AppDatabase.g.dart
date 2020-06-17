// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao _userDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Users` (`firstName` TEXT, `lastName` TEXT, `fullname` TEXT, `largePictureUrl` TEXT, `email` TEXT, `gender` TEXT, `phone` TEXT, PRIMARY KEY (`firstName`, `lastName`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userDbModelInsertionAdapter = InsertionAdapter(
            database,
            'Users',
            (UserDbModel item) => <String, dynamic>{
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'fullname': item.fullname,
                  'largePictureUrl': item.largePictureUrl,
                  'email': item.email,
                  'gender': item.gender,
                  'phone': item.phone
                }),
        _userDbModelDeletionAdapter = DeletionAdapter(
            database,
            'Users',
            ['firstName', 'lastName'],
            (UserDbModel item) => <String, dynamic>{
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'fullname': item.fullname,
                  'largePictureUrl': item.largePictureUrl,
                  'email': item.email,
                  'gender': item.gender,
                  'phone': item.phone
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _usersMapper = (Map<String, dynamic> row) => UserDbModel(
      row['firstName'] as String,
      row['lastName'] as String,
      row['fullname'] as String,
      row['largePictureUrl'] as String,
      row['email'] as String,
      row['gender'] as String,
      row['phone'] as String);

  final InsertionAdapter<UserDbModel> _userDbModelInsertionAdapter;

  final DeletionAdapter<UserDbModel> _userDbModelDeletionAdapter;

  @override
  Future<List<UserDbModel>> fetchAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM Users ORDER BY fullname',
        mapper: _usersMapper);
  }

  @override
  Future<void> insertUser(UserDbModel user) async {
    await _userDbModelInsertionAdapter.insert(user, OnConflictStrategy.ignore);
  }

  @override
  Future<void> insertUsers(List<UserDbModel> users) async {
    await _userDbModelInsertionAdapter.insertList(
        users, OnConflictStrategy.ignore);
  }

  @override
  Future<void> deleteUser(UserDbModel user) async {
    await _userDbModelDeletionAdapter.delete(user);
  }
}
