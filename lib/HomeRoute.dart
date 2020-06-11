import 'package:architecture/UsersFragment.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

	final _fragments = {
		0: UsersListFragment(),
		1: Text("Page 1")
	};

	int _currentFragmentId = 0;

	@override
  Widget build(BuildContext context) =>
	    Scaffold(
		    appBar: buildAppBar(context),
		    drawer: buildDrawer(context),
		    body: buildBody(context, _currentFragmentId),
	    );

  AppBar buildAppBar(context) =>
		  AppBar(
			  title: Text("Home"),
		  );

	Drawer buildDrawer(context) =>
			Drawer(
				child: ListView(
					padding: EdgeInsets.zero,
					children: <Widget> [
						buildDrawerHeader(context),
						buildDrawerButton(context, "Users", 0),
						buildDrawerButton(context, "Next page", 1),
					],
				),
			);

	MediaQuery buildDrawerHeader(context) =>
			MediaQuery.removePadding(
				context: context,
				removeTop: true,
			  child: DrawerHeader(
				  decoration: BoxDecoration(color: Colors.blue),
			    padding: EdgeInsets.zero,
				  child: Padding(
				    padding: const EdgeInsets.only(left: 16, bottom: 32),
				    child: Align(
					    alignment: Alignment.centerLeft,
					    child: Text(
						    "Architecture test",
						    style: TextStyle(fontSize: 30, color: Colors.white),
					    ),
				    ),
			    ),
				),
		  );

	Widget buildDrawerButton(context, text, fragmentId) =>
			ListTile(
		    title: Text(
		      text,
		      style: TextStyle(fontSize: 20),
		    ),
		    onTap: () {
					Navigator.pop(context);
			    setState(() => _currentFragmentId = fragmentId);
		    }
		  );

	Widget buildBody(context, fragmentId) {
		if (_fragments.containsKey(fragmentId)) {
			return _fragments[_currentFragmentId];
		} else {
			return Text("Not Found");
		}
	}
}