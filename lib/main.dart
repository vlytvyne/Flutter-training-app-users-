import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomeRoute.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
			);
	}
}
