import 'package:architecture/Mixins.dart';
import 'package:architecture/UserDetailsRoute.dart';
import 'package:flushbar/flushbar.dart';
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
		_vm.refreshEventStream.listen((_) => buildSnackbar(context).show(context));
		return Stack(
			children: <Widget>[
				buildListWithSearch(),
				SafeStreamBuilder(
					stream: _vm.loadingStream,
					builder: (context, snapshot) => Visibility(visible: snapshot.data, child: LinearProgressIndicator(),)
				)
			],
		);
	}

	Column buildListWithSearch() {
	  return Column(
	  	children: <Widget>[
	  		SearchField(
				  onTextChanged: _vm.setSearchQuery,
			  ),
	  		Expanded(
	  		  child: SafeStreamBuilder(
	  		  	stream: _vm.usersListStream,
	  		  	builder: (context, snapshot) => buildUsersList(snapshot.data),
	  		  ),
	  		),
	  	],
	  );
	}

	Widget buildUsersList(List<UserModel> list) =>
			RefreshIndicator(
				child: ListView.builder(
					controller: _scrollController,
					itemCount: list.length,
					itemBuilder: (context, index) => buildUserTile(list[index]),
				),
				onRefresh: _vm.refreshUsers,
			);

	buildUserTile(UserModel user) =>
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
					() => onTileClick(context, user),
					(checked) => _vm.setFavorite(user, checked)
				),
				onDismissed: (_) => _vm.deleteUser(user),
			);

	Flushbar buildSnackbar(context) =>
			Flushbar(
				message: 'User list has been refreshed',
				margin: EdgeInsets.all(8),
				borderRadius: 8,
				duration: Duration(seconds: 2),
				icon: Icon(Icons.info, color: Theme.of(context).primaryColor,),
				forwardAnimationCurve: Curves.bounceIn,
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

class SearchField extends StatelessWidget {

	final decorator = InputDecoration(
			border: InputBorder.none,
			focusedBorder: InputBorder.none,
			icon: Icon(Icons.search),
			hintText: 'Search'
	);
	
	final textStyle = TextStyle(
			fontSize: 18
	);

	final textController = TextEditingController();

	final Function(String) onTextChanged;

  SearchField({Key key, @required this.onTextChanged}) : super(key: key);

	@override
  Widget build(BuildContext context) =>
		  Material(
			  elevation: 4,
			  child: Container(
				  height: 60,
				  color: Colors.white,
				  child: Row(
					  children: <Widget>[
						  buildSearchField(),
						  buildCloseButton()
					  ],
				  ),
			  ),
		  );

	Expanded buildSearchField() => 
			Expanded(
			  child: Center(
				  child: Padding(
					  padding: const EdgeInsets.only(left: 16, right: 8),
					  child: TextField(
						  onChanged: onTextChanged,
						  controller: textController,
						  style: textStyle,
						  decoration: decorator,
					  ),
				  ),
			  ),
		  );

	IconButton buildCloseButton() =>
			IconButton(
				icon: Icon(Icons.close),
				onPressed: () {
					textController.clear();
					onTextChanged('');
				},
			);

}