import 'package:architecture/data/configs/ThemeConfig.dart';
import 'package:architecture/screens/settings/SettingsVM.dart';
import 'package:architecture/widgets/SafeStreamBuilder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens/home/HomeRoute.dart';

void main() {
	runApp(App());
}

class App extends StatelessWidget {
	
	//handling user theming
	@override
	Widget build(BuildContext context) {
		return Provider<SettingsVM>(
			create: (_) => SettingsVM(),
		  dispose: (_, vm) => vm.dispose(),
		  child: Builder(
			  builder: (context) =>
			  SafeStreamBuilder<ThemeConfig>(
				  stream: Provider.of<SettingsVM>(context).themeConfigStream,
			    builder: (context, snapshot) =>
				    MaterialApp(
				      debugShowCheckedModeBanner: false,
				      title: 'Flutter Demo',
				      theme: _buildThemeData(context, snapshot.data),
				      home: HomeRoute(),
				    ),
			  ),
		  ),
		);
	}

	ThemeData _buildThemeData(BuildContext context, ThemeConfig config) {
		final platform = config.platform == ThemePlatform.ANDROID ? TargetPlatform.android : TargetPlatform.iOS;
		final color = _extractColor(config.color);
	  return ThemeData(
			textTheme: GoogleFonts.cabinTextTheme(Theme.of(context).textTheme,),
	    primaryColor: color,
			accentColor: color,
		  backgroundColor: color[200],
			cursorColor: color,
	    platform: platform
		);
	}

// ignore: missing_return
	MaterialColor _extractColor(ThemeColor color) {
		switch (color) {
			case ThemeColor.BLUE: return Colors.blue;
			case ThemeColor.PINK: return Colors.pink;
			case ThemeColor.GREEN: return Colors.green;
		}
	}
}
