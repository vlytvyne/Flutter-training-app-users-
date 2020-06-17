import 'package:architecture/UserGalleryFragment.dart';
import 'package:architecture/UserStorageFragment.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {

	final fragments = {
		0: UserGalleryFragment(),
		1: UserStorageFragment(),
		2: Text("Page 2"),
	};

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

	int _currentFragmentId = 0;

	final _pageController = PageController();

	@override
  Widget build(BuildContext context) =>
	    Scaffold(
		    appBar: buildAppBar(context),
		    drawer: buildDrawer(context),
		    body: PageView(
			    controller: _pageController,
			    children: widget.fragments.values.toList(),
			    physics: NeverScrollableScrollPhysics()
		    ),
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
						buildDrawerButton(context, "User Gallery", 0),
						buildDrawerButton(context, "User Storage", 1),
						buildDrawerButton(context, "page 2", 2),
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
					_pageController.jumpToPage(fragmentId);
					setState(() => _currentFragmentId = fragmentId);
		    },
				selected: fragmentId == _currentFragmentId,
		  );
}