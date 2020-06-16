import 'package:architecture/Mixins.dart';
import 'package:architecture/UserDetailsRoute.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'SafeStreamBuilder.dart';
import 'UserTile.dart';
import 'UsersListVM.dart';
import 'UsersResponse.dart';

class UsersListFragment extends StatefulWidget {

	UsersListFragment({Key key}) : super(key: key);

	@override
	_UsersListFragmentState createState() => _UsersListFragmentState();
}

class _UsersListFragmentState extends State<UsersListFragment> with
		AutomaticKeepAliveClientMixin<UsersListFragment>,
		AfterLayoutMixin<UsersListFragment> {

	final _vm = UsersListVM();
	final _scrollController = ScrollController();

	bool get isScrolledToEnd => _scrollController.position.pixels >= _scrollController.position.maxScrollExtent;

	@override
	void initState() {
		_scrollController.addListener(() { if (isScrolledToEnd) _vm.loadUsers(); });
		super.initState();
	}

	@override
	void afterFirstLayout(BuildContext context) {
		_vm.loadUsers();
	}

	@override
	Widget build(BuildContext context) {
		super.build(context);
		return Stack(
			children: <Widget>[
				SafeStreamBuilder(
					stream: _vm.usersListStream,
					builder: (context, snapshot) => buildUsersList(snapshot.data),
				),
				SafeStreamBuilder(
					stream: _vm.loadingStream,
					builder: (context, snapshot) => Visibility(visible: snapshot.data, child: LinearProgressIndicator(),)
				)
			],
		);
	}

	Widget buildUsersList(List<UserModel> list) =>
			RefreshIndicator(
				child: ListView.builder(
					controller: _scrollController,
					itemCount: list.length,
					itemBuilder: (context, index) => UserTile(
							list[index],
							index,
							() => onTileClick(context, list[index]),
							(checked) => _vm.setFavorite(list[index], checked)
					),
				),
				onRefresh: _vm.refreshUsers,
			);

	@override
	bool get wantKeepAlive => true;

	onTileClick(context, user) {
		Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => UserDetailsRoute(user: user,))
		);
	}

	@override
	void dispose() {
		_vm.dispose();
		super.dispose();
	}
	
}