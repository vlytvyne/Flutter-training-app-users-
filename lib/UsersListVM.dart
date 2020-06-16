import 'package:rxdart/rxdart.dart';
import 'OnlineRepository.dart';
import 'UsersResponse.dart';

class UsersListVM {

	int _nextPage = 1;
	bool _isLoading = false;
	List<UserModel> _usersList = [];

	final _userListEmitter = BehaviorSubject<List<UserModel>>();
	Stream<List<UserModel>> get usersListStream => _userListEmitter.stream;

	final _loadingEmitter = BehaviorSubject<bool>();
	Stream<bool> get loadingStream => _loadingEmitter.stream;

	Future loadUsers() async {
		if (_isLoading) {
			return;
		}
		_isLoading = true;
		_loadingEmitter.add(true);
		await performLoading();
		_isLoading = false;
		_loadingEmitter.add(false);
	}

	Future performLoading() async {
		var response = await OnlineRepository().getRandomUser(_nextPage);
		_nextPage++;
		_usersList.addAll(response.users);
		_userListEmitter.add(_usersList);
	}

	Future refreshUsers() async {
		if (_isLoading) {
			return;
		}
		_nextPage = 1;
		_usersList.clear();
		await loadUsers();
	}

	setFavorite(UserModel user, bool isFavorite) {
		_usersList.where((element) => element == user).first.isFavorite = isFavorite;
		_userListEmitter.add(_usersList);
	}

	dispose() {
		_userListEmitter.close();
		_loadingEmitter.close();
	}
}