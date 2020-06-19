import 'package:architecture/data/configs/ThemeConfig.dart';
import 'package:architecture/data/db/AppDatabase.dart';
import 'package:architecture/data/db/dao/UserDao.dart';
import 'package:architecture/data/db/models/UserDbModel.dart';
import 'package:architecture/data/filters/UserFilter.dart';
import 'package:architecture/data/network/models/UsersResponse.dart';
import 'package:architecture/data/repositories/OnlineRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const PREFS_THEME_COLOR_KEY = 'themeColor';
const PREFS_THEME_PLATFORM_KEY = 'themePlatform';
const PREFS_USERS_SEED_KEY = 'usersSeed';

class OfflineRepository {

	AppDatabase _dbInstance;
	SharedPreferences _prefsInstance;

	factory OfflineRepository() => _instance;

	static final _instance = OfflineRepository._createInstance();

	OfflineRepository._createInstance();

	Future<AppDatabase> _getDb() async {
		if (_dbInstance == null) {
			_dbInstance = await $FloorAppDatabase.databaseBuilder('app_database').build();
		}
		return _dbInstance;
	}

	Future<SharedPreferences> _getPrefs() async {
		if (_prefsInstance == null) {
			_prefsInstance = await SharedPreferences.getInstance();
		}
		return _prefsInstance;
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

	Future<void> saveThemeConfig(ThemeConfig config) async {
		SharedPreferences prefs = await _getPrefs();
		prefs.setInt(PREFS_THEME_COLOR_KEY, ThemeColor.values.indexOf(config.color));
		prefs.setInt(PREFS_THEME_PLATFORM_KEY, ThemePlatform.values.indexOf(config.platform));
	}
	
	Future<ThemeConfig> fetchThemeConfig() async {
		SharedPreferences prefs = await _getPrefs();
		final color = _getThemeColor(prefs);
		final platform = _getThemePlatform(prefs);
		return ThemeConfig(color, platform);
	}

	ThemeColor _getThemeColor(SharedPreferences prefs) {
		if (prefs.containsKey(PREFS_THEME_COLOR_KEY)) {
			return ThemeColor.values[prefs.getInt(PREFS_THEME_COLOR_KEY)];
		} else {
			return ThemeConfig.defaultConfig.color;
		}
	}

	ThemePlatform _getThemePlatform(SharedPreferences prefs) {
		if (prefs.containsKey(PREFS_THEME_PLATFORM_KEY)) {
			return ThemePlatform.values[prefs.getInt(PREFS_THEME_PLATFORM_KEY)];
		} else {
			return ThemeConfig.defaultConfig.platform;
		}
	}
	
	Future<void> saveUsersSeed(String newSeed) async {
		final prefs = await _getPrefs();
		prefs.setString(PREFS_USERS_SEED_KEY, newSeed);
	}

	Future<String> getUsersSeed() async {
		final prefs = await _getPrefs();
		if (prefs.containsKey(PREFS_USERS_SEED_KEY)) {
			return prefs.getString(PREFS_USERS_SEED_KEY);
		} else {
			return DEFAULT_USERS_SEED;
		}
	}

}