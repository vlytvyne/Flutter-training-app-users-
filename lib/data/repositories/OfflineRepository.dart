import 'package:architecture/data/db/AppDatabase.dart';
import 'package:architecture/data/db/models/UserDbModel.dart';
import 'package:architecture/data/network/models/UsersResponse.dart';

class OfflineRepository {

	AppDatabase _dbInstance;

	factory OfflineRepository() => _instance;

	static final _instance = OfflineRepository._createInstance();

	OfflineRepository._createInstance();

	Future<AppDatabase> _getDb() async {
		if (_dbInstance == null) {
			_dbInstance = await $FloorAppDatabase.inMemoryDatabaseBuilder().build(); //TODO: change to real db
		}
		return _dbInstance;
	}

	Future<void> saveUser(UserModel user) async {
		final db = await _getDb();
		return db.userDao.insertUser(UserDbModel.fromUserModel(user));
	}

	Future<void> saveUsers(List<UserModel> users) async {
		final db = await _getDb();
		return db.userDao.insertUsers(users.map((user) => UserDbModel.fromUserModel(user)).toList());
	}

	Future<List<UserModel>> fetchAllUsers() async {
		final db = await _getDb();
		final userDbModels = await db.userDao.fetchAllUsers();
		return userDbModels.map((e) => e.toUserModel()).toList();
	}

	Future<void> deleteUser(UserModel user) async {
		final db = await _getDb();
		db.userDao.deleteUser(UserDbModel.fromUserModel(user));
	}

}