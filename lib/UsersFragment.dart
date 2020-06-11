import 'package:architecture/OnlineRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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

	UsersListVM() {
		loadUsers();
	}

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
	  print("preform");
	}

	dispose() {
		_userListEmitter.close();
		_loadingEmitter.close();
	}
}

class UsersListFragment extends StatelessWidget {

	final vm = UsersListVM();
	final _scrollController = ScrollController();

	UsersListFragment() {
		_scrollController.addListener(() {
			if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
				vm.loadUsers();
			}
		});
	}

	@override
	Widget build(BuildContext context) =>
			Stack(
				children: <Widget>[
					StreamBuilder(
						stream: vm.usersListStream,
						initialData: vm.initialUserList,
						builder: (context, snapshot) => buildList(snapshot.data),
					),
					StreamBuilder(
						stream: vm.loadingStream,
						initialData: vm.initialLoading,
						builder: (context, snapshot) => Visibility(visible: snapshot.data, child: LinearProgressIndicator(),)
					)
				],
			);

	Widget buildList(List<UserModel> list) {
		return ListView.builder(
			controller: _scrollController,
			itemCount: list.length,
			itemBuilder: (context, index) => UserTile(list[index], index),
		);
	}

}

class UserTile extends StatelessWidget {

	final UserModel user;
	final int index;

	const UserTile(this.user, this.index, {Key key}) : super(key: key);

	@override
	Widget build(BuildContext context) =>
			ListTile(
				leading: Text(index.toString()),
				title: Text(user.name.fullname),
			);

}