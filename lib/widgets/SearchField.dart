import 'package:flutter/material.dart';

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