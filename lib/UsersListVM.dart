import 'package:rxdart/rxdart.dart';
import 'OnlineRepository.dart';
import 'UsersResponse.dart';

class UsersListVM {

	int nextPage = 1;
	bool isLoading = false;
	List<UserModel> _usersList = [];

	final _userListEmitter = BehaviorSubject<List<UserModel>>();
	Stream<List<UserModel>> get usersListStream => _userListEmitter.stream;
	final initialUserList = <UserModel>[];

	final _loadingEmitter = BehaviorSubject<bool>();
	Stream<bool> get loadingStream => _loadingEmitter.stream;
	final initialLoading = true;

	loadUsers() async {
		if (isLoading) {
			return;
		}
		isLoading = true;
		_loadingEmitter.add(true);
		await performLoading();
		isLoading = false;
		_loadingEmitter.add(false);
	}

	Future performLoading() async {
		var response = await OnlineRepository().getRandomUser(nextPage);
		nextPage++;
		_usersList.addAll(response.users);
		_userListEmitter.add(_usersList);
	}

	dispose() {
		_userListEmitter.close();
		_loadingEmitter.close();
	}
}