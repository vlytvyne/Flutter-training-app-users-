import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'UserDetailsRoute.dart';
import 'UsersResponse.dart';

class UserTile extends StatelessWidget {

	final UserModel user;
	final int index;
	final VoidCallback onClick;
	final Function(bool) onChecked;

	const UserTile(this.user, this.index, this.onClick, this.onChecked, {Key key}) : super(key: key);

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
				onTap: onClick,
				leading: buildAvatar(),
				trailing: Checkbox(
					value: user.isFavorite,
					onChanged: onChecked,
				),
			);

	Widget buildAvatar() =>
			Hero(
				tag: user.name.fullname,
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