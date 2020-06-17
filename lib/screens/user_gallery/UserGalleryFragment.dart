import 'package:architecture/utils/Mixins.dart';
import 'package:architecture/screens/user_details/UserDetailsRoute.dart';
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
		AutomaticKeepAliveClientMixin<UserGalleryFragment>,
		AfterLayoutMixin<UserGalleryFragment> {

	final _vm = UserGalleryVM();
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
		return Scaffold(
			floatingActionButton: buildFAB(),
		  body: Builder(
			  builder: (context) {
				  registerSnackBarListeners(context);
			  	return Stack(
					  children: <Widget>[
						  buildListWithSearch(context),
						  SafeStreamBuilder<bool>(
							  stream: _vm.loadingStream,
							  builder: (context, snapshot) => Visibility(visible: snapshot.data, child: LinearProgressIndicator(),)
						  )
					  ],
				  );
			  },
		  ),
		);
	}

	Widget buildFAB() {
	  return SafeStreamBuilder<List<UserModel>>(
		  stream: _vm.usersListStream,
	    builder: (context, snapshot) => FloatingActionButton.extended(
				label: Text('Save ${snapshot.data.where((user) => user.isSelected).length}'),
				onPressed: _vm.saveSelectedUsers,
				icon: Icon(Icons.save),
			),
	  );
	}

	void registerSnackBarListeners(BuildContext context) {
	  _vm.refreshEventStream.listen(
      (_) => Scaffold.of(context).showSnackBar(
	      SnackBar(
	        duration: Duration(seconds: 2),
	        content: Text('Users list has been refreshed'),
        )
      )
	  );
	  _vm.usersSavedEventStream.listen(
		  (amount) => Scaffold.of(context).showSnackBar(
			  SnackBar(
				  duration: Duration(seconds: 2),
				  content: Text('$amount users have been saved'),
			  )
		  )
    );
	  }

	Column buildListWithSearch(context) {
	  return Column(
	  	children: <Widget>[
	  		SearchField(
				  onTextChanged: _vm.setSearchQuery,
			  ),
	  		Expanded(
	  		  child: SafeStreamBuilder<List<UserModel>>(
	  		  	stream: _vm.usersListStream,
	  		  	builder: (context, snapshot) => buildUsersList(context, snapshot.data),
	  		  ),
	  		),
	  	],
	  );
	}

	Widget buildUsersList(context, List<UserModel> list) =>
			RefreshIndicator(
				child: ListView.builder(
					controller: _scrollController,
					itemCount: list.length,
					itemBuilder: (context, index) => buildUserTile(context, list[index]),
				),
				onRefresh: _vm.refreshUsers,
			);

	buildUserTile(context, UserModel user) =>
			UserTile(
				user,
				hasSelectionOption: true,
				onClick: () => onTileClick(context, user),
				onSelected: (checked) => _vm.setSelected(user, checked)
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