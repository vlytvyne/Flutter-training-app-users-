import 'package:architecture/data/network/models/UsersResponse.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class UserDetailsRoute extends StatelessWidget {

	final User user;

  const UserDetailsRoute(this.user, {Key key}) : super(key: key);

	@override
  Widget build(BuildContext context) =>
			Scaffold(
				appBar: _buildAppBar(context),
				body: _buildBody(context),
			);

	AppBar _buildAppBar(context) =>
			AppBar(
				title: Text("User Details"),
			);

	Widget _buildBody(context) =>
			SingleChildScrollView(
			  child: Column(
			    children: <Widget>[
			      _buildAvatarWithNameOnIt(),
			  	  _buildInfoField(context, "Gender", user.gender),
			  	  _buildInfoField(context, "Email", user.email),
			  	  _buildInfoField(context, "Phone", user.phone),
			  	],
			  ),
			);

	Widget _buildAvatarWithNameOnIt() =>
			Stack(
				children: <Widget>[
					_buildAvatar(),
					_buildNameOnAvatar()
				],
			);

	Widget _buildAvatar() =>
			SizedBox(
	      height: 300,
	      width: double.infinity,
	      child: Hero(
		      tag: user.name.fullname,
	        child: FittedBox(
	          fit: BoxFit.fitWidth,
	          child: CachedNetworkImage(imageUrl: user.picture.large,)
	        ),
	      )
	    );

	SizedBox _buildNameOnAvatar() =>
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

	Widget _buildInfoField(context, String title, String value) =>
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