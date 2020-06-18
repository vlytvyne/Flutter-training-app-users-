import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsFragment extends StatelessWidget {

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
					    buildUserSeedField(context),
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

	Widget buildUserSeedField(context) =>
			Form(
				child: Row(
					children: <Widget>[
						buildTextField(context),
						buildApplyButton(context)
					],
				),
			);

	Center buildApplyButton(context) => 
			Center(
			  child: Padding(
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
			      onPressed: () {  },
			    ),
			  ),
			);

	Widget buildTextField(context) => 
			Expanded(
			  child: TextFormField(
					textAlign: TextAlign.center,
				  maxLength: 8,
				  style: TextStyle(fontSize: 20),
				  decoration: InputDecoration(
					  labelText: 'User seed',
					  enabledBorder: OutlineInputBorder(
						    borderSide: BorderSide(
							    color: Theme.of(context).primaryColor,
						    ),
					    ),
					  focusedBorder: OutlineInputBorder(
						    borderSide: BorderSide(
							    color: Theme.of(context).primaryColor,
							    width: 2,
						    ),
					    ),
					  counterText: '',
				  ),
			  ),
			);
	
	Widget buildPlatformToggle(context) =>
			ToggleButtons(
				fillColor: Theme.of(context).highlightColor,
				selectedColor: Theme.of(context).accentColor,
				renderBorder: false,
				children: <Widget>[
					buildToggleButton('Android'),
					buildToggleButton('iOS'),
				],
				borderRadius: BorderRadius.circular(30),
				isSelected: [true, false],
				onPressed: (index) {},
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
		return Column(
			children: <Widget>[
				buildRadioListTile('Blue', Colors.blue, 0),
				buildRadioListTile('Pink', Colors.pink, 1),
				buildRadioListTile('Green', Colors.green, 2),
			],
		);
	}

	RadioListTile<int> buildRadioListTile(title, color, value) =>
			RadioListTile(
				title: Text(
					title,
					style: TextStyle(
							color: color
					),
				),
				value: 0,
				groupValue: 0,
				onChanged: (value) {},
			);

}