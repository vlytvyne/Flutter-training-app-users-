import 'package:architecture/data/filters/UserFilter.dart';
import 'package:architecture/data/network/models/UsersResponse.dart';
import 'package:architecture/screens/user_details/UserDetailsRoute.dart';
import 'package:architecture/utils/Mixins.dart';
import 'package:architecture/widgets/ModelSheetUserFilter.dart';
import 'package:architecture/widgets/SafeStreamBuilder.dart';
import 'package:architecture/widgets/SearchField.dart';
import 'package:architecture/widgets/UserTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'UserStorageVM.dart';

class UserStorageFragment extends StatefulWidget {

  @override
  _UserStorageFragmentState createState() => _UserStorageFragmentState();
}

class _UserStorageFragmentState extends State<UserStorageFragment> with AfterLayoutMixin<UserStorageFragment> {

	final _vm = UserStorageVM();

	@override
	void afterFirstLayout(BuildContext context) {
		_vm.loadUsers();
	}

  @override
  Widget build(BuildContext context) {
  	return Scaffold(
		  appBar: _buildAppBar(context),
  	  body: _buildBody(),
  	);
  }

  AppBar _buildAppBar(context) =>
		  AppBar(
			  title: Text('Saved users'),
			  actions: <Widget>[
			  	IconButton(
					  icon: Icon(Icons.filter_list),
					  onPressed: () {
					  	showModalBottomSheet(
							  context: context,
							  builder: (context) => buildModelSheet(context),
						  );
					  },
				  )
			  ],
		  );

	Widget _buildBody() =>
			Stack(
				children: <Widget>[
					_buildListWithSearch(context),
					buildLoadingIndicator(),
				]
			);

	Widget _buildListWithSearch(context) =>
			Column(
				children: <Widget>[
					SearchField(
						onTextChanged: _vm.setSearchQuery,
					),
					Expanded(
						child: SafeStreamBuilder<List<User>>(
							stream: _vm.userListStream,
							builder: (context, snapshot) => snapshot.data.length != 0 ?
								_buildUsersList(context, snapshot.data)
										:
								Center(child: Text('No users')),
						),
					),
				],
			);

	Widget _buildUsersList(context, List<User> list) =>
			ListView.builder(
				itemCount: list.length,
				itemBuilder: (context, index) => _buildUserTile(context, list[index]),
			);

	_buildUserTile(context, User user) =>
			Dismissible(
				key: ValueKey(user.name.fullname),
				direction: DismissDirection.endToStart,
				background: _buildDismissBackground(),
				child: UserTile(
					user,
					onClick: () => _onTileClick(context, user),
				),
				onDismissed: (_) => {
					_vm.deleteUser(user),
					_showUndoSnackBar(context, user)
				}
			);

	Container _buildDismissBackground() =>
			Container(
				color: Colors.red[600],
				child: Align(
					alignment: Alignment.centerRight,
					child: Padding(
						padding: const EdgeInsets.only(right: 24),
						child: Icon(
							Icons.delete,
							color: Colors.white,
						),
					),
				),
			);

	_onTileClick(context, user) {
		Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => UserDetailsRoute(user,))
		);
	}

	_showUndoSnackBar(context, User user) {
		Scaffold.of(context).showSnackBar(
			SnackBar(
				content: Text('${user.name.fullname} has been deleted'),
				action: SnackBarAction(
					label: 'UNDO',
					onPressed: _vm.undoLastDelete,
				),
			)
		);
	}

	Widget buildLoadingIndicator() =>
			SafeStreamBuilder<bool>(
				stream: _vm.loadingStream,
				builder: (context, snapshot) => Visibility(visible: snapshot.data, child: LinearProgressIndicator(),)
			);

	Widget buildModelSheet(context) =>
			SafeStreamBuilder<UserFilter>(
				stream: _vm.filterStream,
				builder: (context, snapshot) => ModelSheetUserFilter(
					filter: snapshot.data,
					onApply: (filter) {
						Navigator.of(context).pop();
						_vm.setFilter(filter);
					},
				),
			);

	@override
	void dispose() {
		_vm.dispose();
		super.dispose();
	}
}