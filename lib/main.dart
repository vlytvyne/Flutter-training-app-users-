import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home/HomeRoute.dart';

void main() {
	runApp(App());
}

class App extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'Flutter Demo',
			theme: buildThemeData(context),
			home: HomeRoute(),
		);
	}

	ThemeData buildThemeData(BuildContext context) {
	  return ThemeData(
			textTheme: GoogleFonts.cabinTextTheme(
				Theme.of(context).textTheme,
			),
	    primaryColor: Colors.blue,
			accentColor: Colors.blue,
		  backgroundColor: Colors.blue[200],
			cursorColor: Colors.blue,
		  highlightColor: Colors.blue[100],
//	    platform: TargetPlatform.android
		);
	}
}
