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
		    appBar: _buildAppBar(context),
		    body: _buildBody(context),
	    );

  Widget _buildAppBar(context) =>
		  AppBar(
			  title: Text('Settings'),
		  );

	Widget _buildBody(context) =>
			SingleChildScrollView(
			  child: Padding(
			    padding: const EdgeInsets.symmetric(horizontal: 12),
			    child: Column(
			    	children: <Widget>[
					    _buildSettingTitle(context, 'Loaded users set'),
					    _buildUserSeedForm(context),
			  		  _buildSettingTitle(context, 'Platform'),
			  		  _buildPlatformToggle(context),
					    _buildSettingTitle(context, 'Color theme'),
					    _buildThemeColorSelect(context),
			    	],
			    ),
			  ),
			);

	Widget _buildSettingTitle(context, title) =>
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

	_ChangeUserSeedForm _buildUserSeedForm(context) =>
			_ChangeUserSeedForm(
		    currentSeed: _vm.currentUsersSeed,
		    onApply: (newSeed) {
			    _vm.setUserSeed(newSeed);
			    _showSeedAppliedSnack(context);
		    }
	    );

	Widget _buildPlatformToggle(context) =>
			SafeStreamBuilder<ThemePlatform>(
				stream: _vm.themePlatformStream,
				builder: (context, snapshot) =>
					ToggleButtons(
				    fillColor: Theme.of(context).primaryColor.withAlpha(30),
				    selectedColor: Theme.of(context).accentColor,
				    renderBorder: false,
				    children: <Widget>[
				      _buildToggleButton('Android'),
				      _buildToggleButton('iOS'),
				    ],
				    borderRadius: BorderRadius.circular(30),
				    isSelected: [snapshot.data == ThemePlatform.ANDROID, snapshot.data == ThemePlatform.IOS],
				    onPressed: (index) => _vm.setThemePlatform(index == 0 ? ThemePlatform.ANDROID : ThemePlatform.IOS),
				  ),
			);

	Container _buildToggleButton(title) =>
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

	Widget _buildThemeColorSelect(context) {
		return SafeStreamBuilder<ThemeColor>(
			stream: _vm.themeColorStream,
		  builder: (context, snapshot) =>
			  Column(
			    children: <Widget>[
			      _buildRadioListTile('Blue', Colors.blue, 0, snapshot.data),
			      _buildRadioListTile('Pink', Colors.pink, 1, snapshot.data),
			      _buildRadioListTile('Green', Colors.green, 2, snapshot.data),
			    ],
		    ),
		);
	}

	Widget _buildRadioListTile(title, color, value, ThemeColor themeColor) =>
			RadioListTile(
				title: Text(
					title,
					style: TextStyle(color: color),
				),
				value: value,
				groupValue: _convertThemeColorToGroupValue(themeColor),
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

	_convertThemeColorToGroupValue(ThemeColor color) {
		switch (color) {
			case ThemeColor.BLUE: return 0;
			case ThemeColor.PINK: return 1;
			case ThemeColor.GREEN: return 2;
		}
	}

	_showSeedAppliedSnack(context) {
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
					  _buildTextField(context),
					  _buildApplyButton(context)
				  ],
			  ),
		  );

  Widget _buildTextField(context) =>
		  Expanded(
			  child: TextFormField(
				  initialValue: currentSeed,
				  validator: _validateInput,
				  onSaved: (newSeed) {
					  FocusScope.of(context).unfocus();
				  	onApply(newSeed);
				  },
				  textAlign: TextAlign.center,
				  maxLength: 8,
				  style: TextStyle(fontSize: 20),
				  decoration: InputDecoration(
					  labelText: 'User seed',
					  enabledBorder: _createBorder(1, Theme.of(context).primaryColor),
					  focusedBorder: _createBorder(2, Theme.of(context).primaryColor),
					  errorBorder: _createBorder(1, Colors.red),
					  focusedErrorBorder: _createBorder(2, Colors.red),
					  counterText: '',
				  ),
			  ),
		  );

  String _validateInput(String text) {
	  if (text.isEmpty) {
		  return "Seed can't be empty";
	  }
	  return null;
  }

	OutlineInputBorder _createBorder(double width, Color color) =>
			OutlineInputBorder(
				borderSide: BorderSide(
					color: color,
					width: width,
				),
			);

  Widget _buildApplyButton(context) =>
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