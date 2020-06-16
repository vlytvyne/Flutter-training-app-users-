import 'dart:async';

import 'package:architecture/OnlineRepository.dart';
import 'package:architecture/UserAPI.dart';
import 'package:architecture/UsersListFragment.dart';
import 'package:architecture/UsersResponse.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test/test.dart';

void main() {
	test("Test network call", () async {
		final response = await OnlineRepository().getRandomUser(1);
		expect(response.users.length, 20);
	});
}