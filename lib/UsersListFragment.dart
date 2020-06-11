import 'package:architecture/OnlineRepository.dart';
import 'package:architecture/UserDetailsRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'UsersListVM.dart';
import 'UsersResponse.dart';

class UsersListFragment extends StatefulWidget {

	UsersListFragment({Key key}) : super(key: key);

	@override
	_UsersListFragmentState createState() => _UsersListFragmentState();
}

class _UsersListFragmentState extends State<UsersListFragment> with AutomaticKeepAliveClientMixin<UsersListFragment> {

	final vm = UsersListVM();
	final _scrollController = ScrollController();

	bool get isScrolledToEnd => _scrollController.position.pixels >= _scrollController.position.maxScrollExtent;

	@override
	void initState() {
		_scrollController.addListener(() { if (isScrolledToEnd) vm.loadUsers(); });
		vm.loadUsers();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		super.build(context);
		return Stack(
			children: <Widget>[
				StreamBuilder(
					stream: vm.usersListStream,
					initialData: vm.initialUserList,
					builder: (context, snapshot) => buildUsersList(snapshot.data),
				),
				StreamBuilder(
					stream: vm.loadingStream,
					initialData: vm.initialLoading,
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
					itemBuilder: (context, index) => UserTile(list[index], index),
				),
				onRefresh: vm.refreshUsers,
			);

	@override
	bool get wantKeepAlive => true;

	@override
	void dispose() {
		vm.dispose();
		super.dispose();
	}
	
}

class UserTile extends StatelessWidget {

	final UserModel user;
	final int index;

	const UserTile(this.user, this.index, {Key key}) : super(key: key);

	@override
	Widget build(BuildContext context) =>
			ListTile(
				title: Text(
					user.name.fullname,
					style: TextStyle(fontSize: 20),
				),
				subtitle: Text(
					user.email,
					style: TextStyle(fontSize: 18),
				),
				onTap: () => onTileClick(context),
				leading: buildAvatar(),
			);

	onTileClick(context) {
		Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => UserDetailsRoute(user: user,))
		);
	}

	Widget buildAvatar() =>
		 Hero(
			 tag: user.picture.large,
			 child: ClipOval(
				 child: SizedBox(
					 height: 40,
					 width: 40,
					 child: CachedNetworkImage(
						 imageUrl: user.picture.large,
						 placeholder: (context, url) => Container(color: Colors.blue,),
					 ),
				 ),
			 ),
		 );
}