import 'package:architecture/utils/Mixins.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/SafeStreamBuilder.dart';
import '../user_details/UserDetailsRoute.dart';
import '../../widgets/UserTile.dart';
import '../../data/network/models/UsersResponse.dart';
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
			  SafeStreamBuilder<List<UserModel>>(
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

	Widget buildUsersList(List<UserModel> list) =>
			ListView.builder(
				itemCount: list.length,
				itemBuilder: (context, index) => buildUserTile(context, list[index]),
			);

	buildUserTile(context, UserModel user) =>
			Dismissible(
				key: ValueKey(user.name.fullname),
				direction: DismissDirection.endToStart,
				background: Container(
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
				),
				child: UserTile(
					user,
					onClick: () => onTileClick(context, user),
				),
				onDismissed: (_) => {
					_vm.deleteUser(user),
					Scaffold.of(context).showSnackBar(
						SnackBar(
							content: Text('${user.name.fullname} has been deleted'),
							action: SnackBarAction(
								label: 'UNDO',
								onPressed: _vm.undoLastDelete,
							),
						)
					)
				}
			);

	onTileClick(context, user) {
		Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => UserDetailsRoute(user: user,))
		);
	}
}