import 'dart:async';

import 'package:architecture/OnlineRepository.dart';
import 'package:architecture/UserAPI.dart';
import 'package:architecture/UsersFragment.dart';
import 'package:architecture/UsersResponse.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test/test.dart';

void main() {
	test("Test network call", () async {
		final response = await OnlineRepository().getRandomUser(10);
		print(response.users.length);
	});
}