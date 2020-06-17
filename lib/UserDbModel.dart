import 'package:floor/floor.dart';
import 'UsersResponse.dart';

@Entity(tableName: 'Users', primaryKeys: ['firstName', 'lastName'])
class UserDbModel {

	final String firstName;
	final String lastName;
	final String fullname;
	final String largePictureUrl;
	final String email;
	final String gender;
	final String phone;

  UserDbModel(this.firstName, this.lastName, this.fullname, this.largePictureUrl, this.email, this.gender, this.phone);

  factory UserDbModel.fromUserModel(UserModel user) =>
		  UserDbModel(user.name.first, user.name.last, user.name.fullname, user.picture.large, user.email, user.gender, user.phone);

  UserModel toUserModel() =>
		  UserModel(UserName(firstName, lastName), UserPicture(largePictureUrl), email, gender, phone);

}