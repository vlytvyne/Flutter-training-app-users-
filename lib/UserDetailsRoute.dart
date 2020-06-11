import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'UsersResponse.dart';

class UserDetailsRoute extends StatelessWidget {

	final UserModel user;

  const UserDetailsRoute({Key key, this.user}) : super(key: key);

	@override
  Widget build(BuildContext context) =>
			Scaffold(
				appBar: buildAppBar(context),
				body: buildBody(context),
			);

	AppBar buildAppBar(context) =>
			AppBar(
				title: Text("User Details"),
			);

	Widget buildBody(context) =>
			SingleChildScrollView(
			  child: Column(
			    children: <Widget>[
			      buildAvatarWithNameOnIt(),
			  	  buildInfoField(context, "Gender", user.gender),
			  	  buildInfoField(context, "Email", user.email),
			  	  buildInfoField(context, "Phone", user.phone),
			  	],
			  ),
			);

	Widget buildAvatarWithNameOnIt() =>
			Stack(
				children: <Widget>[
					buildAvatar(),
					buildNameOnAvatar()
				],
			);

	Widget buildAvatar() =>
			SizedBox(
	      height: 300,
	      width: double.infinity,
	      child: Hero(
	        tag: user.picture.large,
	        child: FittedBox(
	          fit: BoxFit.fitWidth,
	          child: CachedNetworkImage(imageUrl: user.picture.large,)
	        ),
	      )
	    );

	SizedBox buildNameOnAvatar() =>
			SizedBox(
				height: 300,
				width: double.infinity,
				child: Padding(
					padding: const EdgeInsets.all(16.0),
					child: Align(
						alignment: Alignment.bottomLeft,
						child: Text(
							user.name.fullname,
							style: TextStyle(
								fontSize: 36,
								fontWeight: FontWeight.w700,
								color: Colors.white,
							),
						),
					),
				),
			);

	Widget buildInfoField(context, String title, String value) =>
			Padding(
			  padding: const EdgeInsets.symmetric(horizontal: 16),
			  child: Column(
			  	children: <Widget>[
			  		SizedBox(height: 8,),
			  		Align(
						  alignment: Alignment.centerLeft,
			  		  child: Text(
			  		  	title,
			  		  	style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
			  		  ),
			  		),
			  		SizedBox(
			  			height: 4,
			  		),
			  		Align(
						  alignment: Alignment.centerLeft,
			  		  child: Text(
			  		  	value,
			  		  	style: TextStyle(fontSize: 20, color: Colors.black),
			  		  ),
			  		),
			  		Divider(
						  thickness: 1,
					  ),
			  	],
			  ),
			);
}