import 'package:architecture/UserAPI.dart';
import 'package:architecture/UsersResponse.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const USERS_SEED = "123";
const USERS_IOP = 20;

class OnlineRepository {

	factory OnlineRepository() => _instance;

	static final _instance = OnlineRepository._createInstance();

	OnlineRepository._createInstance();

	final UserAPI _userAPI = UserAPI(Dio()..interceptors.add(PrettyDioLogger()));

	//requests
	Future<UsersResponse> getRandomUser(int page) => _userAPI.getRandomUsers(USERS_SEED, USERS_IOP, page);
}