import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../screens/user_details/UserDetailsRoute.dart';
import '../data/network/models/UsersResponse.dart';

class UserTile extends StatelessWidget {

	final User user;
	final VoidCallback onClick;
	final Function(bool) onSelected;
  final hasSelectionOption;

	const UserTile(this.user, {Key key, this.onClick, this.hasSelectionOption: false, this.onSelected,}) : super(key: key);

	@override
	Widget build(BuildContext context) =>
			ListTile(
				title: Text(
					user.name.fullname,
					style: TextStyle(fontSize: 20),
				),
				subtitle: Text(
					user.email,
					style: TextStyle(fontSize: 18),
				),
				onTap: onClick ?? () {},
				leading: buildAvatar(context),
				trailing: hasSelectionOption ?
					Checkbox(
						value: user.isSelected,
						onChanged: onSelected,
					)
						:
					SizedBox.shrink(),
			);

	Widget buildAvatar(context) =>
			Hero(
				tag: user.name.fullname + context.hashCode.toString(),
				child: ClipOval(
					child: SizedBox(
						height: 40,
						width: 40,
						child: CachedNetworkImage(
							imageUrl: user.picture.large,
							placeholder: (context, url) => Container(color: Colors.blue,),
						),
					),
				),
			);
}