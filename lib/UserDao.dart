import 'package:architecture/UserDbModel.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {

	@Query('SELECT * FROM Users')
	Future<List<UserDbModel>> fetchAllUsers();

	@insert
	Future<void> insertUser(UserDbModel user);

}