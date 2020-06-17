import 'dart:async';

import 'package:architecture/utils/Mixins.dart';
import 'package:architecture/screens/user_details/UserDetailsRoute.dart';
import 'package:architecture/widgets/SearchField.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../widgets/SafeStreamBuilder.dart';
import '../../widgets/UserTile.dart';
import 'UserGalleryVM.dart';
import '../../data/network/models/UsersResponse.dart';

class UserGalleryFragment extends StatefulWidget {

	UserGalleryFragment({Key key}) : super(key: key);

	@override
	_UserGalleryFragmentState createState() => _UserGalleryFragmentState();
}

class _UserGalleryFragmentState extends State<UserGalleryFragment> with
		AfterLayoutMixin<UserGalleryFragment> {

	final _vm = UserGalleryVM();
	final _scrollController = ScrollController();
	final streamSubscriptions = <StreamSubscription>[];

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
		return Scaffold(
			appBar: buildAppBar(),
			floatingActionButton: buildFAB(),
		  body: Builder(
			  builder: (context) {
				  registerSnackBarListeners(context);
			  	return Stack(
					  children: <Widget>[
						  buildListWithSearch(context),
						  buildLoadingIndicator()
					  ],
				  );
			  },
		  ),
		);
	}

	AppBar buildAppBar() =>
			AppBar(
				title: Text('User gallery'),
			);

	Widget buildFAB() =>
			SafeStreamBuilder<List<User>>(
				stream: _vm.usersListStream,
				builder: (context, snapshot) => FloatingActionButton.extended(
					label: Text('Save ${snapshot.data.where((user) => user.isSelected).length}'),
					onPressed: _vm.saveSelectedUsers,
					icon: Icon(Icons.save),
				),
			);

	void registerSnackBarListeners(context) {
		final subscription1 = _vm.refreshEventStream.listen(
      (_) => Scaffold.of(context).showSnackBar(
	      SnackBar(
	        duration: Duration(seconds: 2),
	        content: Text('Users list has been refreshed'),
        )
      )
	  );
	  final subscription2 = _vm.usersSavedEventStream.listen(
		  (amount) => Scaffold.of(context).showSnackBar(
			  SnackBar(
				  duration: Duration(seconds: 2),
				  content: Text('$amount users have been saved'),
			  )
		  )
    );
	  streamSubscriptions.add(subscription1);
	  streamSubscriptions.add(subscription2);
  }

	Column buildListWithSearch(context) {
		return Column(
			children: <Widget>[
				SearchField(
					onTextChanged: _vm.setSearchQuery,
				),
				Expanded(
					child: SafeStreamBuilder<List<User>>(
						stream: _vm.usersListStream,
						builder: (context, snapshot) => buildUsersList(context, snapshot.data),
					),
				),
			],
		);
	}

	Widget buildUsersList(context, List<User> list) =>
			RefreshIndicator(
				child: ListView.builder(
					controller: _scrollController,
					itemCount: list.length,
					itemBuilder: (context, index) => buildUserTile(context, list[index]),
				),
				onRefresh: _vm.refreshUsers,
			);

	buildUserTile(context, User user) =>
			UserTile(
					user,
					hasSelectionOption: true,
					onClick: () => onTileClick(context, user),
					onSelected: (checked) => _vm.setSelected(user, checked)
			);

	onTileClick(context, user) {
		Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => UserDetailsRoute(user: user,))
		);
	}

	Widget buildLoadingIndicator() =>
			SafeStreamBuilder<bool>(
			  stream: _vm.loadingStream,
			  builder: (context, snapshot) => Visibility(visible: snapshot.data, child: LinearProgressIndicator(),)
		  );

	@override
	void dispose() {
		streamSubscriptions.forEach((element) {element.cancel();});
		_vm.dispose();
		super.dispose();
	}
	
}