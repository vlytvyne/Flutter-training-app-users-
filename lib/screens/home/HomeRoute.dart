import 'package:architecture/screens/settings/SettingsFragment.dart';
import 'package:architecture/screens/settings/SettingsVM.dart';
import 'package:architecture/screens/user_gallery/UserGalleryFragment.dart';
import 'package:architecture/screens/user_storage/UserStorageFragment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

	int _currentPage = 0;

	final _pageController = PageController();

	@override
  Widget build(BuildContext context) =>
	    Scaffold(
		    body: buildPageView(),
		    bottomNavigationBar: buildBottomNavigationBar(),
	    );

	BottomNavigationBar buildBottomNavigationBar() =>
			BottomNavigationBar(
		    currentIndex: _currentPage,
		    onTap: (index) {
		      _pageController.jumpToPage(index);
		      setState(() => _currentPage = index);
		    },
		    items: <BottomNavigationBarItem>[
		    	buildBottomNavItem(Icons.group, 'User Gallery'),
		    	buildBottomNavItem(Icons.supervised_user_circle, 'Saved Users'),
		    	buildBottomNavItem(Icons.settings, 'Settings'),
		    ],
	    );

	BottomNavigationBarItem buildBottomNavItem(IconData icon, String text) =>
			BottomNavigationBarItem(
				icon: Icon(icon),
				title: Text(text),
			);

	PageView buildPageView() =>
			PageView(
		    controller: _pageController,
		    children: [
			    UserGalleryFragment(),
			    UserStorageFragment(),
			    SettingsFragment(Provider.of<SettingsVM>(context, listen: false)),
		    ],
		    physics: NeverScrollableScrollPhysics()
	    );
}