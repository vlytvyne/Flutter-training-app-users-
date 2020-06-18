import 'package:architecture/data/configs/ThemeConfig.dart';
import 'package:architecture/screens/settings/SettingsVM.dart';
import 'package:architecture/widgets/SafeStreamBuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsFragment extends StatelessWidget {

	final SettingsVM _vm;

  const SettingsFragment(this._vm, {Key key}) : super(key: key);

	@override
  Widget build(BuildContext context) =>
			Scaffold(
		    appBar: buildAppBar(context),
		    body: buildBody(context),
	    );

  Widget buildAppBar(context) =>
		  AppBar(
			  title: Text('Settings'),
		  );

	Widget buildBody(context) =>
			SingleChildScrollView(
			  child: Padding(
			    padding: const EdgeInsets.symmetric(horizontal: 12),
			    child: Column(
			    	children: <Widget>[
					    buildSettingTitle(context, 'Loaded users set'),
					    buildUserSeedForm(context),
			  		  buildSettingTitle(context, 'Platform'),
			  		  buildPlatformToggle(context),
					    buildSettingTitle(context, 'Color theme'),
					    buildThemeColorSelect(context),
			    	],
			    ),
			  ),
			);

	Widget buildSettingTitle(context, title) =>
			Padding(
			  padding: const EdgeInsets.symmetric(vertical: 16),
			  child: Align(
			  	alignment: Alignment.centerLeft,
			  	child: Text(
			  		title,
			  		style: TextStyle(
			  			fontSize: 30,
			  			fontWeight: FontWeight.w400
			  		),
			  	)
			  ),
			);

	_ChangeUserSeedForm buildUserSeedForm(context) =>
			_ChangeUserSeedForm(
		    currentSeed: _vm.currentUsersSeed,
		    onApply: (newSeed) {
			    _vm.setUserSeed(newSeed);
			    showSeedAppliedSnack(context);
		    }
	    );

	Widget buildPlatformToggle(context) =>
			SafeStreamBuilder<ThemePlatform>(
				stream: _vm.themePlatformStream,
				builder: (context, snapshot) =>
					ToggleButtons(
				    fillColor: Theme.of(context).primaryColor.withAlpha(30),
				    selectedColor: Theme.of(context).accentColor,
				    renderBorder: false,
				    children: <Widget>[
				      buildToggleButton('Android'),
				      buildToggleButton('iOS'),
				    ],
				    borderRadius: BorderRadius.circular(30),
				    isSelected: [snapshot.data == ThemePlatform.ANDROID, snapshot.data == ThemePlatform.IOS],
				    onPressed: (index) => _vm.setThemePlatform(index == 0 ? ThemePlatform.ANDROID : ThemePlatform.IOS),
				  ),
			);

	Container buildToggleButton(title) =>
			Container(
				height: 60,
				width: 120,
				child: Center(
					child: Text(
						title,
						style: TextStyle(
								fontSize: 26
						),
					)
				)
			);

	Widget buildThemeColorSelect(context) {
		return SafeStreamBuilder<ThemeColor>(
			stream: _vm.themeColorStream,
		  builder: (context, snapshot) =>
			  Column(
			    children: <Widget>[
			      buildRadioListTile('Blue', Colors.blue, 0, snapshot.data),
			      buildRadioListTile('Pink', Colors.pink, 1, snapshot.data),
			      buildRadioListTile('Green', Colors.green, 2, snapshot.data),
			    ],
		    ),
		);
	}

	Widget buildRadioListTile(title, color, value, ThemeColor themeColor) =>
			RadioListTile(
				title: Text(
					title,
					style: TextStyle(color: color),
				),
				value: value,
				groupValue: convertThemeColorToGroupValue(themeColor),
				onChanged: (value) {
					switch (value) {
						case 0:_vm.setThemeColor(ThemeColor.BLUE);
							break;
						case 1: _vm.setThemeColor(ThemeColor.PINK);
							break;
						case 2: _vm.setThemeColor(ThemeColor.GREEN);
							break;
					}
				},
			);

	convertThemeColorToGroupValue(ThemeColor color) {
		switch (color) {
			case ThemeColor.BLUE: return 0;
			case ThemeColor.PINK: return 1;
			case ThemeColor.GREEN: return 2;
		}
	}

	showSeedAppliedSnack(context) {
		Scaffold.of(context).showSnackBar(
			SnackBar(
				content: Text('User seed has been applied'),
				duration: Duration(seconds: 2),
			)
		);
	}

}



class _ChangeUserSeedForm extends StatelessWidget {

	final _formKey = GlobalKey<FormState>();

	final Function(String) onApply;
	final String currentSeed;

	_ChangeUserSeedForm({Key key, this.onApply, this.currentSeed}) : super(key: key);
	
  @override
  Widget build(BuildContext context) =>
		  Form(
			  key: _formKey,
			  child: Row(
				  crossAxisAlignment: CrossAxisAlignment.start,
				  children: <Widget>[
					  buildTextField(context),
					  buildApplyButton(context)
				  ],
			  ),
		  );

  Widget buildTextField(context) =>
		  Expanded(
			  child: TextFormField(
				  initialValue: currentSeed,
				  validator: validateInput,
				  onSaved: (newSeed) {
					  FocusScope.of(context).unfocus();
				  	onApply(newSeed);
				  },
				  textAlign: TextAlign.center,
				  maxLength: 8,
				  style: TextStyle(fontSize: 20),
				  decoration: InputDecoration(
					  labelText: 'User seed',
					  enabledBorder: createBorder(1, Theme.of(context).primaryColor),
					  focusedBorder: createBorder(2, Theme.of(context).primaryColor),
					  errorBorder: createBorder(1, Colors.red),
					  focusedErrorBorder: createBorder(2, Colors.red),
					  counterText: '',
				  ),
			  ),
		  );

  String validateInput(String text) {
	  if (text.isEmpty) {
		  return "Seed can't be empty";
	  }
	  return null;
  }

	OutlineInputBorder createBorder(double width, Color color) =>
			OutlineInputBorder(
				borderSide: BorderSide(
					color: color,
					width: width,
				),
			);

  Widget buildApplyButton(context) =>
		  Padding(
			  padding: const EdgeInsets.only(left: 12),
			  child: MaterialButton(
				  height: 60,
				  child: Text(
					  'Apply',
					  style: TextStyle(
						  color: Theme.of(context).primaryColor,
						  fontSize: 20
					  )
				  ),
				  onPressed: () {
					  if (_formKey.currentState.validate()) {
							_formKey.currentState.save();
					  }
				  },
			  ),
		  );

}