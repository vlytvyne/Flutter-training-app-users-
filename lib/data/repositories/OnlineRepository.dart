import 'package:architecture/data/network/UserAPI.dart';
import 'package:architecture/data/network/models/UsersResponse.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const USERS_IOP = 20;
const DEFAULT_USERS_SEED = '123';

class OnlineRepository {

	factory OnlineRepository() => _instance;

	static final _instance = OnlineRepository._createInstance();

	OnlineRepository._createInstance();

	final UserAPI _userAPI = UserAPI(Dio());

	String usersSeed = DEFAULT_USERS_SEED;
	//requests
	Future<UsersResponse> getRandomUser(int page) => _userAPI.getRandomUsers(usersSeed, USERS_IOP, page);
}