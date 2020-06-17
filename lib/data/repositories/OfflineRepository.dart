import 'package:architecture/data/db/AppDatabase.dart';
import 'package:architecture/data/db/dao/UserDao.dart';
import 'package:architecture/data/db/models/UserDbModel.dart';
import 'package:architecture/data/filters/UserFilter.dart';
import 'package:architecture/data/network/models/UsersResponse.dart';

class OfflineRepository {

	AppDatabase _dbInstance;

	factory OfflineRepository() => _instance;

	static final _instance = OfflineRepository._createInstance();

	OfflineRepository._createInstance();

	Future<AppDatabase> _getDb() async {
		if (_dbInstance == null) {
			_dbInstance = await $FloorAppDatabase.databaseBuilder('app_database').build();
		}
		return _dbInstance;
	}

	Future<void> saveUser(User user) async {
		final db = await _getDb();
		return db.userDao.insertUser(UserDbModel.fromUserModel(user));
	}

	Future<void> saveUsers(List<User> users) async {
		final db = await _getDb();
		return db.userDao.insertUsers(users.map((user) => UserDbModel.fromUserModel(user)).toList());
	}

	Future<List<User>> fetchUsers({UserFilter filter}) async {
		final db = await _getDb();
		List<UserDbModel> userDbModels;
		if (filter == null) {
			userDbModels = await db.userDao.fetchAllUsersASC();
		} else {
			userDbModels = await _applyFilterToQuery(db.userDao, filter);
		}
		return userDbModels.map((e) => e.toUserModel()).toList();
	}

// ignore: missing_return
	Future<List<UserDbModel>> _applyFilterToQuery(UserDao userDao, UserFilter filter) async {
	  if (filter.ascendingOrder) {
	  	if (filter.showBothGenders) {
	  		return userDao.fetchAllUsersASC();
	  	} else if (filter.showMen) {
	  		return userDao.fetchGenderUsersASC(GENDER_MALE);
	  	} else if (filter.showWomen) {
	  		return userDao.fetchGenderUsersASC(GENDER_FEMALE);
	  	}
	  } else {
	  	if (filter.showBothGenders) {
	  		return userDao.fetchAllUsersDESC();
	  	} else if (filter.showMen) {
	  		return userDao.fetchGenderUsersDESC(GENDER_MALE);
	  	} else if (filter.showWomen) {
	  		return userDao.fetchGenderUsersDESC(GENDER_FEMALE);
	  	}
	  }
	}

	Future<void> deleteUser(User user) async {
		final db = await _getDb();
		db.userDao.deleteUser(UserDbModel.fromUserModel(user));
	}

}