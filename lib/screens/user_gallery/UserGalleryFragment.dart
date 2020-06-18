import 'dart:async';

import 'package:architecture/data/network/models/UsersResponse.dart';
import 'package:architecture/utils/Mixins.dart';
import 'package:architecture/screens/user_details/UserDetailsRoute.dart';
import 'package:architecture/widgets/SafeStreamBuilder.dart';
import 'package:architecture/widgets/UserTile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'UserGalleryVM.dart';

class UserGalleryFragment extends StatefulWidget {

	UserGalleryFragment({Key key}) : super(key: key);

	@override
	_UserGalleryFragmentState createState() => _UserGalleryFragmentState();
}

class _UserGalleryFragmentState extends State<UserGalleryFragment> with
		AfterLayoutMixin<UserGalleryFragment> {

	final _vm = UserGalleryVM();
	final _scrollController = ScrollController();
	final _streamSubscriptions = <StreamSubscription>[];

	bool get _isScrolledToEnd => _scrollController.position.pixels >= _scrollController.position.maxScrollExtent;

	@override
	void initState() {
		_scrollController.addListener(() { if (_isScrolledToEnd) _vm.loadUsers(); });
		super.initState();
	}

	@override
	void afterFirstLayout(BuildContext context) {
		_vm.loadUsers();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: _buildAppBar(),
			floatingActionButton: _buildFAB(),
		  body: Builder(
			  builder: (context) {
				  _registerSnackBarListeners(context);
			  	return Stack(
					  children: <Widget>[
						  _buildUsersListWithRefresh(context),
						  _buildLoadingIndicator()
					  ],
				  );
			  },
		  ),
		);
	}

	AppBar _buildAppBar() =>
			AppBar(
				title: Text('User gallery'),
			);

	Widget _buildFAB() =>
			SafeStreamBuilder<List<User>>(
				stream: _vm.userListStream,
				builder: (context, snapshot) => FloatingActionButton.extended(
					label: Text('Save ${snapshot.data.where((user) => user.isSelected).length}'),
					onPressed: _vm.saveSelectedUsers,
					icon: Icon(Icons.save),
				),
			);

	void _registerSnackBarListeners(context) {
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
	  _streamSubscriptions.add(subscription1);
	  _streamSubscriptions.add(subscription2);
  }


	Widget _buildUsersListWithRefresh(context) =>
			RefreshIndicator(
				child: SafeStreamBuilder<List<User>>(
					stream: _vm.userListStream,
					builder: (context, snapshot) => _buildUsersList(context, snapshot.data),
				),
				onRefresh: _vm.refreshUsers,
			);

	Widget _buildUsersList(context, List<User> list) =>
			ListView.builder(
				controller: _scrollController,
				itemCount: list.length,
				itemBuilder: (context, index) => _buildUserTile(context, list[index]),
			);

	Widget _buildUserTile(context, User user) =>
			UserTile(
					user,
					hasSelectionOption: true,
					onClick: () => _onTileClick(context, user),
					onSelected: (checked) => _vm.setSelected(user, checked)
			);

	_onTileClick(context, user) {
		Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => UserDetailsRoute(user,))
		);
	}

	Widget _buildLoadingIndicator() =>
			SafeStreamBuilder<bool>(
			  stream: _vm.loadingStream,
			  builder: (context, snapshot) => Visibility(visible: snapshot.data, child: LinearProgressIndicator(),)
		  );

	@override
	void dispose() {
		_streamSubscriptions.forEach((element) {element.cancel();});
		_vm.dispose();
		super.dispose();
	}
	
}