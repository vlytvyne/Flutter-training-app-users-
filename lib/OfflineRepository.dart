//import 'package:architecture/UsersResponse.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//class OfflineRepository {
//
//	SharedPreferences storage;
//
//	factory OfflineRepository() => _instance;
//
//	static final _instance = OfflineRepository._createInstance();
//
//	OfflineRepository._createInstance() {
//		SharedPreferences.getInstance().then((value) => storage = value);
//	}
//
//	saveUser(UserModel user) {
//		storage.setString(key, value)
//	}
//
//
//}