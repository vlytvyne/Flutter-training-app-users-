import 'package:architecture/data/repositories/OnlineRepository.dart';
import 'package:test/test.dart';

void main() {
	test("Test network call", () async {
		final response = await OnlineRepository().getRandomUser(1);
		expect(response.users.length, 20);
	});
}