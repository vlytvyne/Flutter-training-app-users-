import 'package:architecture/data/repositories/OfflineRepository.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/repositories/OnlineRepository.dart';
import '../../data/network/models/UsersResponse.dart';

class UserGalleryVM {

	int _nextPage = 1;

	bool _preventLoading = false;
	final List<User> _userList = [];

	final _userListEmitter = BehaviorSubject<List<User>>();
	Stream<List<User>> get userListStream => _userListEmitter.stream;

	final _loadingEmitter = BehaviorSubject<bool>();
	Stream<bool> get loadingStream => _loadingEmitter.stream;

	final _refreshEventEmitter = BehaviorSubject<void>();
	Stream<void> get refreshEventStream => _refreshEventEmitter.stream;

	final _usersSavedEventEmitter = BehaviorSubject<int>();
	Stream<int> get usersSavedEventStream => _usersSavedEventEmitter.stream;

	Future loadUsers() async {
		if (_preventLoading) {
			return;
		}
		_preventLoading = true;
		_loadingEmitter.add(true);
		await _performLoading();
		_preventLoading = false;
		_loadingEmitter.add(false);
	}

	Future _performLoading() async {
		var response = await OnlineRepository().getRandomUser(_nextPage);
		_nextPage++;
		_userList.addAll(response.users);
		_userListEmitter.add(_userList);
	}

	Future refreshUsers() async {
		if (_preventLoading) {
			return;
		}
		_nextPage = 1;
		_userList.clear();
		await loadUsers();
		_refreshEventEmitter.add(null);
	}

	setSelected(User user, bool isFavorite) {
		_userList.where((element) => element == user).first.isSelected = isFavorite;
		_userListEmitter.add(_userList);
	}
	
	saveSelectedUsers() {
		final usersToSave = _userList.where((user) => user.isSelected).toList();
		if (usersToSave.length == 0) {
			return;
		}
		OfflineRepository().saveUsers(usersToSave);
		_usersSavedEventEmitter.add(usersToSave.length);
		_userList.forEach((user) => user.isSelected = false);
		_userListEmitter.add(_userList);
	}

	dispose() {
		_userListEmitter.close();
		_loadingEmitter.close();
		_refreshEventEmitter.close();
		_usersSavedEventEmitter.close();
	}
}