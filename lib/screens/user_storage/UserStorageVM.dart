import 'package:architecture/data/filters/UserFilter.dart';
import 'package:architecture/data/repositories/OfflineRepository.dart';
import 'package:architecture/data/network/models/UsersResponse.dart';
import 'package:rxdart/rxdart.dart';

class UserStorageVM {

	final _userList = <User>[];
	final _userListForUndo = <User>[];
	static UserFilter _filter = UserFilter(true, true, true);

	User _userForUndo;

	final _userListEmitter = BehaviorSubject<List<User>>();
	Stream<List<User>> get userListStream => _userListEmitter.stream;

	final _loadingEmitter = BehaviorSubject<bool>();
	Stream<bool> get loadingStream => _loadingEmitter.stream;

	final _filterEmitter = BehaviorSubject<UserFilter>.seeded(_filter);
	Stream<UserFilter> get filterStream => _filterEmitter.stream;

	loadUsers() async {
		_userList.clear();
		_loadingEmitter.add(true);
		final localUsers = await OfflineRepository().fetchUsers(filter: _filter);
		_userList.addAll(localUsers);
		_userListEmitter.add(_userList);
		_loadingEmitter.add(false);
	}

	deleteUser(User user) {
		OfflineRepository().deleteUser(user);
		_userForUndo = user;
		_userListForUndo.clear();
		_userListForUndo.addAll(_userList);
		_userList.remove(user);
		_userListEmitter.add(_userList);
	}
	
	undoLastDelete() {
		OfflineRepository().saveUser(_userForUndo);
		_userList.clear();
		_userList.addAll(_userListForUndo);
		_userListEmitter.add(_userList);
	}

	setFilter(UserFilter filter) {
		_filter = filter;
		_filterEmitter.add(_filter);
		loadUsers();
	}

	dispose() {
		_userListEmitter.close();
		_loadingEmitter.close();
		_filterEmitter.close();
	}

}