import 'package:architecture/UsersResponse.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'UserAPI.g.dart';

@RestApi(baseUrl: "https://randomuser.me/api/")
abstract class UserAPI {

	factory UserAPI(Dio dio, {String baseUrl}) = _UserAPI;

	@GET("")
	Future<UsersResponse> getRandomUsers(@Query("seed") String seed,
	                                     @Query("results") int amount,
	                                     @Query("page") int page);

}