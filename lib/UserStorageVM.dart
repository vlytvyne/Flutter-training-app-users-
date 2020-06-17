import 'package:architecture/OfflineRepository.dart';
import 'package:architecture/UsersResponse.dart';
import 'package:rxdart/rxdart.dart';

class UserStorageVM {

	final _userList = <UserModel>[];

	final _userListEmitter = BehaviorSubject<List<UserModel>>();
	Stream<List<UserModel>> get userListStream => _userListEmitter.stream;

	final _loadingEmitter = BehaviorSubject<bool>();
	Stream<bool> get loadingStream => _loadingEmitter.stream;

	loadAllUsers() async {
		_loadingEmitter.add(true);
		final localUsers = await OfflineRepository().fetchAllUsers();
		_userList.addAll(localUsers);
		_userListEmitter.add(_userList);
		_loadingEmitter.add(false);
	}

	deleteUser(UserModel user) {
		OfflineRepository().deleteUser(user);
		_userList.remove(user);
		_userListEmitter.add(_userList);
	}

	dispose() {
		_userListEmitter.close();
		_loadingEmitter.close();
	}

}