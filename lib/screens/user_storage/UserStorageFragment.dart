import 'package:architecture/data/network/models/UsersResponse.dart';
import 'package:architecture/screens/user_details/UserDetailsRoute.dart';
import 'package:architecture/utils/Mixins.dart';
import 'package:architecture/widgets/SafeStreamBuilder.dart';
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
		_vm.loadAllUsers();
	}

  @override
  Widget build(BuildContext context) {
  	return Stack(
		  children: <Widget>[
			  SafeStreamBuilder<List<User>>(
				  stream: _vm.userListStream,
				  builder: (context, snapshot) => buildUsersList(snapshot.data),
			  ),
			  SafeStreamBuilder<bool>(
				  stream: _vm.loadingStream,
				  builder: (context, snapshot) => Visibility(visible: snapshot.data, child: LinearProgressIndicator(),)
			  )
		  ],
	  );
  }

	Widget buildUsersList(List<User> list) =>
			ListView.builder(
				itemCount: list.length,
				itemBuilder: (context, index) => buildUserTile(context, list[index]),
			);

	buildUserTile(context, User user) =>
			Dismissible(
				key: ValueKey(user.name.fullname),
				direction: DismissDirection.endToStart,
				background: buildDismissBackground(),
				child: UserTile(
					user,
					onClick: () => onTileClick(context, user),
				),
				onDismissed: (_) => {
					_vm.deleteUser(user),
					showUndoSnackBar(context, user)
				}
			);

	Container buildDismissBackground() =>
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

	onTileClick(context, user) {
		Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => UserDetailsRoute(user: user,))
		);
	}

	showUndoSnackBar(context, User user) {
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
}