import 'dart:ffi';

import 'dart:ffi';

import 'package:rxdart/rxdart.dart';
import 'OnlineRepository.dart';
import 'UsersResponse.dart';

class UsersListVM {

	int _nextPage = 1;

	bool _preventLoading = false;
	List<UserModel> _usersList = [];

	String _searchQuery;

	final _userListEmitter = BehaviorSubject<List<UserModel>>();
	Stream<List<UserModel>> get usersListStream => _userListEmitter.stream;

	final _loadingEmitter = BehaviorSubject<bool>();
	Stream<bool> get loadingStream => _loadingEmitter.stream;

	final _refreshEventEmitter = BehaviorSubject<Void>();
	Stream<Void> get refreshEventStream => _refreshEventEmitter.stream;

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
		_usersList.addAll(response.users);
		_userListEmitter.add(_usersList);
	}

	Future refreshUsers() async {
		if (_preventLoading) {
			return;
		}
		_nextPage = 1;
		_usersList.clear();
		await loadUsers();
		_refreshEventEmitter.add(null);
	}

	setFavorite(UserModel user, bool isFavorite) {
		_usersList.where((element) => element == user).first.isFavorite = isFavorite;
		_userListEmitter.add(_usersList);
	}

	setSearchQuery(String query) {
		print("new query $query");
		_searchQuery = query;
		if (query.isEmpty) {
			_preventLoading = false;
			refreshUsers();
		} else {
			_preventLoading = true;
			_filterUsers();
		}
	}

	_filterUsers() {
		final filteredList = _usersList.where(
			(user) => user.name.fullname.toLowerCase().startsWith(
					_searchQuery.toLowerCase()
			)
		).toList();
		_usersList.clear();
		_usersList.addAll(filteredList);
		_userListEmitter.add(_usersList);
	}

	deleteUser(UserModel user) {
		_usersList.remove(user);
		_userListEmitter.add(_usersList);
	}

	dispose() {
		_userListEmitter.close();
		_loadingEmitter.close();
		_refreshEventEmitter.close();
	}
}