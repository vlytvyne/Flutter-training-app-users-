import 'package:architecture/data/db/models/UserDbModel.dart';
import 'package:floor/floor.dart';

const GENDER_MALE = 'male';
const GENDER_FEMALE = 'female';

@dao
abstract class UserDao {

	@Query('SELECT * FROM Users ORDER BY fullname')
	Future<List<UserDbModel>> fetchAllUsersASC();

	@Query('SELECT * FROM Users ORDER BY fullname DESC')
	Future<List<UserDbModel>> fetchAllUsersDESC();

	@Query('SELECT * FROM Users WHERE gender = :gender ORDER BY fullname ASC')
	Future<List<UserDbModel>> fetchGenderUsersASC(String gender);

	@Query('SELECT * FROM Users WHERE gender = :gender ORDER BY fullname DESC')
	Future<List<UserDbModel>> fetchGenderUsersDESC(String gender);

	@Insert(onConflict: OnConflictStrategy.ignore)
	Future<void> insertUser(UserDbModel user);

	@Insert(onConflict: OnConflictStrategy.ignore)
	Future<void> insertUsers(List<UserDbModel> users);

	@delete
	Future<void> deleteUser(UserDbModel user);

}