import 'package:architecture/data/network/models/UsersResponse.dart';
import 'package:architecture/data/repositories/OfflineRepository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
	//change $FloorAppDatabase.databaseBuilder('app_database.db').build(); to
	//$FloorAppDatabase.inMemoryDatabaseBuilder().build(); In Offline Repo before test
	test("Db insert and fetch user", () async {
		await OfflineRepository().saveUser(User(UserName('Vasyl1', 'Bubka'), UserPicture('123'), 'email', 'male', '123'));
		await OfflineRepository().saveUser(User(UserName('Vasyl2', 'Bubka'), UserPicture('123'), 'email', 'male', '123'));
		await OfflineRepository().saveUser(User(UserName('Vasyl Last', 'Bubka'), UserPicture('123'), 'email', 'male', '123'));
		final users = await OfflineRepository().fetchUsers();

		expect(users.length, 3);
		expect(users.last.name.first, 'Vasyl Last');
	});
}