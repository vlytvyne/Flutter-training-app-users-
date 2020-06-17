import 'package:architecture/UserDbModel.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {

	@Query('SELECT * FROM Users')
	Future<List<UserDbModel>> fetchAllUsers();

	@Insert(onConflict: OnConflictStrategy.ignore)
	Future<void> insertUser(UserDbModel user);

	@Insert(onConflict: OnConflictStrategy.ignore)
	Future<void> insertUsers(List<UserDbModel> users);

	@delete
	Future<void> deleteUser(UserDbModel user);

}